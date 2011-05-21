/*

The MIT License

Copyright (c) 2008 Paul Whitelock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package com.flexblocks.imagecropper {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	// Events
	
	/**
	 * This event is dispatched when the component begins loading an image from a URL.
	 */ 
	
	[Event(name="sourceImageLoading")]
	
	/**
	 * This event is dispatched if an I/O error occurs while loading an image from a URL.
	 */ 
	
	[Event(name="sourceImageLoadError")]
	
	/**
	 * This event is dispatched when the component has completed loading an image from a URL or when a <code>BitmapData</code> object is specified for the <code>sourceImage</code> parameter.
	 */ 
	
	[Event(name="sourceImageReady")]
	
	/**
	 * This event is dispatched whenever the cropping rectangle is resized or repositioned using the mouse.
	 */
	 
	[Event(name="cropRectChanged")]
	
	/**
	 * This event is dispatched whenever <code>constrainToAspectRatio</code> is set to <code>true</code> and the component alters the aspect ratio of the cropping rectangle.
	 * 
	 * <p>One situation where the component will alter the aspect ratio of the cropping rectangle is if the cropping rectangle handle size is increased and the cropping rectangle is
	 * not large enough to contain the increased size of the handles. The other situation where the component will alter the aspect ratio of the cropping rectangle is when the cropping rectangle is initialized following
	 * a call to <code>setCropRect</code> and the parameters passed to <code>setCropRect</code> necessitate that the component change the cropping rectangle in order for it to be properly displayed within the component 
	 * (e.g., the coordinates passed for the cropping rectangle place part of the cropping rectangle outside of the component's display area).</p>
	 */
	 
	[Event(name="cropConstraintChanged")]
	
	/**
	 * If <code>constrainToAspectRatio</code> is set to <code>true</code> and a call to <code>setCropRect</code> is executed with a <code>width</code> or <code>height</code> value less than or equal to zero, 
	 * then <code>constrainToAspectRatio</code> will be disabled and this event will be dispatched.
	 */	
	
	[Event(name="cropConstraintDisabled")]
	
	/**
	 * This event is dispatched whenever the component alters the position of the cropping rectangle.
	 * 
	 * <p>If the cropping rectangle handle size is increased by setting the <code>handleSize</code> property and there is not enough room within the cropping rectangle to contain the larger handles, 
	 * then the component will increase the size of the cropping rectangle. If the position of the cropping rectangle changes when its size is increased, then this event will be dispatched.</p>
	 * 
	 * <p>This event is also dispatched if the position of the cropping rectangle is specified in a call to <code>setCropRect</code> but the cropping rectangle cannot be properly displayed in the component
	 * at the specified position. In this case the component will adjust the position of the cropping rectangle and dispatch the <code>cropPositionChanged</code> event.
	 */	
	
	[Event(name="cropPositionChanged")]

	/**
	 * This event is dispatched whenever the component alters the dimensions of the cropping rectangle.
	 * 
	 * <p>If the cropping rectangle handle size is increased by setting the <code>handleSize</code> property and there is not enough room within the cropping rectangle to contain the larger handles, 
	 * then the component will increase the size of the cropping rectangle and dispatch this event.</p>
	 * 
	 * <p>This event is also dispatched if the width and height of the cropping rectangle are specified in a call to <code>setCropRect</code> but the cropping rectangle cannot be properly displayed in the component
	 * using the specified dimensions. In this case the component will adjust the dimensions of the cropping rectangle and dispatch the <code>cropDimensionsChanged</code> event.
	 */	
	
	[Event(name="cropDimensionsChanged")]
	
	/**
	 * The ImageCropper component accepts a <code>String</code> (URL) pointing to an image file, or a <code>BitmapData</code> object that contains an image, and displays the image within the 
	 * component. If the size of the image exceeds the component's dimensions then the image is scaled so that it will entirely fit within the component.
	 *  
	 * <p>The image may be visually cropped by adjusting the boundries of a cropping rectangle using any of the four handles on the corners 
	 * of the rectangle. At any time a <code>BitmapData</code> object containing the cropped portion of the image may be retrieved, or 
	 * a <code>Rectangle</code> may be retrieved that defines the cropped portion of the image.</p>
	 * 
	 * <p>The cropping rectangle may be initialized using coordinates and dimensions relative to the component's display or relative to the source image.</p>
	 */
	
	public class ImageCropper extends UIComponent {
		
		// Track the enabled state of the component
		
		private var componentEnabled:Boolean = true;
		
		// Hand cursor for moving the cropping rectangle
		
		[Embed(source="hand.gif")]
		private var handCursor:Class;
		private var handCursorID:int = -1;
		
		// Source image object (can be a String object or a BitmapData object)
		
		private var imageSource:Object = null;
				
		// Component dimensions
		
		private var componentWidth:Number;
		private var componentHeight:Number;

		// Component bitmap variables

		private var componentBitmap:Bitmap;
		private var componentBitmapData:BitmapData;

		// Variables for loading an image
		
		private var newImageLoaded:Boolean = false;
		private var currentSource:Loader;
		
		// Component colors and alpha values
		
		private var bkgndColor:uint = 0xFF000000;
		private var bkgndAlpha:uint = 0xFF000000;
		private var cropMaskColor:uint = 0x4CFF0000;
		private var cropMaskAlpha:uint = 0x4C000000;
		private var cropHandleColor:uint = 0xFFFF0000;
		private var cropHandleAlpha:Number = .5;
		private var cropSelectionOutlineColor:uint = 0xFFFFFFFF;
		private var cropSelectionOutlineAlpha:Number = 1.; 
		
		// Image scaling variables		
		
		private var imageLocation:Point;
		private var imageScaleFactor:Number;
		private var imageScaledWidth:Number;
		private var imageScaledHeight:Number;
		private var imageBitmapData:BitmapData;
		private var scaledImageBitmapData:BitmapData;
		
		// Image cropping variables
		
		private var cropX:Number;
		private var cropY:Number;
		private var cropWidth:Number;
		private var cropHeight:Number;		
		private var newCroppingRect:Boolean = false;
		private var cropRatioActive:Boolean = false;
		private var cropRatio:Number = 0;
		private var cropRect:Rectangle;	
		private var croppingRectBitmapData:BitmapData;
		private var anchorX:Number;
		private var anchorY:Number;
		private var activeHandle:int;
		private var croppingRectIsImageScale:Boolean;
		private var cropMaskChanged:Boolean = false;
		
		// Crop sizing variables
		
		private var cropHandleSize:Number = 10;
		public var cropRectMinimumSize:Number = 20;
		public var cropRectMaxSize:Number = 1000;
		
		// Flag used to prevent a null object reference if updateDisplayList() is called by the Flex callLaterDispatcher() after destroy() is executed
		
		private var destroyed:Boolean = false;
		
		// Flag to indicate whether mouse listeners are active
		
		private var mouseListenersActive:Boolean = false;
		
		// Event constants
		
		/**
		 * Constant value for the <code>sourceImageLoading</code> event.
		 */
		
		public const SOURCE_IMAGE_LOADING:String = "sourceImageLoading";
		
		/**
		 * Constant value for the <code>sourceImageLoadError</code> event.
		 */
		
		public const SOURCE_IMAGE_LOAD_ERROR:String = "sourceImageLoadError";
		
		/**
		 * Constant value for the <code>sourceImageReady</code> event.
		 */

		public const SOURCE_IMAGE_READY:String = "sourceImageReady";

		/**
		 * Constant value for the <code>cropRectChanged</code> event.
		 */

		public const CROP_RECT_CHANGED:String = "cropRectChanged";

		/**
		 * Constant value for the <code>cropConstraintChanged</code> event.
		 */

		public const CROP_CONSTRAINT_CHANGED:String = "cropConstraintChanged";

		/**
		 * Constant value for the <code>cropConstraintDisabled</code> event.
		 */

		public const CROP_CONSTRAINT_DISABLED:String = "cropConstraintDisabled";
		
		/**
		 * Constant value for the <code>cropPositionChanged</code> event.
		 */

		public const CROP_POSITION_CHANGED:String = "cropPositionChanged";
				
		/**
		 * Constant value for the <code>cropDimensionsChanged</code> event.
		 */

		public const CROP_DIMENSIONS_CHANGED:String = "cropDimensionsChanged";		

		/**
		 * The version number of the ImageCropper component.
		 */

		public const VERSION:Number = 1.0;		
		
		// --------------------------------------------------------------------------------------------------
		// ImageCropper - Constructor
		// --------------------------------------------------------------------------------------------------

		/**
		 * Class constructor.
		 */
		
		public function ImageCropper() {
			
			// Initialize the superclass
					
			super();
		}
		
		// --------------------------------------------------------------------------------------------------
		// destroy - Call this function when finished using the component to release resources for garbage collection
		// --------------------------------------------------------------------------------------------------

		/**
		 * Call this method to dereference resources when the <code>ImageCropper</code> component is no longer needed. For example, if the <code>ImageCropper</code> component is
		 * used in a pop-up window and the window is closed, call <code>destroy</code> when removing the window. 
		 */
		
		public function destroy():void {
			
			// Set to prevent a null object reference if updateDisplayList() is called by the Flex callLaterDispatcher() after destroy() is executed
			
			destroyed = true;

			// Release memory used by Bitmaps and BitmapData objects
			
			if (componentBitmapData != null) {
				componentBitmapData.dispose();
				componentBitmapData = null;
				componentBitmap = null;
			}
			
			if (imageBitmapData != null) {
				imageBitmapData.dispose();
				imageBitmapData = null;
			}			
			
			if (scaledImageBitmapData != null) {
				scaledImageBitmapData.dispose();
				scaledImageBitmapData = null;
			}

			// Remove hand cursor if active
			
			if (handCursorID >= 0) {
				CursorManager.removeCursor(handCursorID);
				handCursorID = -1;
			}
			
			// Release any active listeners 
			
			activateListeners(false); 
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET enabled - Returns whether or not the component is enabled
		// --------------------------------------------------------------------------------------------------

		/**
		 * Whether the component can accept user interaction or changes to properties. If the <code>enabled</code> property is set to <code>false</code> then the cropping rectangle is removed
		 * and all component properties become read-only (except for the <code>enabled</code> property). In addition, calls to the <code>setCropRect</code> method are ignored. 
		 * 
		 * <p>The component may be re-enabled by setting the <code>enabled</code> property to <code>true</code>. 
		 * 
		 * @default true
		 */
				
		public override function get enabled():Boolean {
			
			return componentEnabled;
		}	

		// --------------------------------------------------------------------------------------------------
		// SET enabled - Sets whether or not the component is enabled
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */
		
		public override function set enabled(value:Boolean):void {
			
			// If the requested enabled state is different than the current enabled state
			
			if (componentEnabled != value) {
			
				// Call the super method
				
				super.enabled = value;
					
				// Save the new enbled state
				
				componentEnabled = value;
				
				// If an image is being displayed, activate or deactive the mouse listeners depending on the new enabled state
				
				if (imageBitmapData != null) activateListeners(componentEnabled);
				
				// Remove hand cursor if active
				
				if (handCursorID >= 0) {
					CursorManager.removeCursor(handCursorID);
					handCursorID = -1;
				}								
			
				// Schedule a redraw
			
				invalidateDisplayList();
			}
		}

		// --------------------------------------------------------------------------------------------------
		// GET backgroundColor - Returns the component's background color (behind the image)
		// --------------------------------------------------------------------------------------------------

		/**
		 * The background color for the component. The component background will be visible only when an image does not entirely fill the component area.
		 * 
		 * @default 0x00000000
		 */
				
		public function get backgroundColor():uint {
			return (bkgndColor & 0x00FFFFFF);
		}	

		// --------------------------------------------------------------------------------------------------
		// SET backgroundColor - Sets the component's background color (behind the image)
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */
		
		public function set backgroundColor(value:uint):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {

				bkgndColor = value;
				
				// Mask off high-order 8 bits and replace with the background alpha value
				
				bkgndColor &= 0x00FFFFFF;
				bkgndColor |= bkgndAlpha;
				
				// Schedule a redraw
				
				invalidateDisplayList();
			}
		}
						
		// --------------------------------------------------------------------------------------------------
		// GET backgroundAlpha - Returns the alpha level for the component's background color
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) for the component's background. The component background will be visible only when an image does not entirely fill the component area.
		 * 
		 * @default 0
		 */
		
		public function get backgroundAlpha():Number {
			if (bkgndAlpha > 0) return (bkgndAlpha >> 48) / 100;
			else return 0;
		}

		// --------------------------------------------------------------------------------------------------
		// SET backgroundAlpha - Sets the alpha level for the component's background color
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set backgroundAlpha(value:Number):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {
	
				// Value must be between 0 and 1
				
				if (value > 1) value = 1;
				else if (value < 0) value = 0;
				
				// Convert the Number to an 8 bit value and position the bits as the high order 8 bits
				
				var a:uint = Math.round(value * 255);
				bkgndAlpha = (Math.round(value * 255)) << 24;
				
				// Set the high order 8 bits of the background color to the alpha value
				
				bkgndColor &= 0x00FFFFFF;
				bkgndColor |= bkgndAlpha;
				
				// Schedule a redraw
				
				invalidateDisplayList();
			}
		}
				
		// --------------------------------------------------------------------------------------------------
		// GET maskColor - Returns the color used to mask unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * The color of the mask used to indicate the non-selected portion of the cropped image. The mask will be visible only when the dimensions of the cropping rectangle are smaller than the dimensions of the image.
		 * 
		 * @default 0x00FF0000
		 */

		public function get maskColor():uint {
			return (cropMaskColor & 0x00FFFFFF);
		}	

		// --------------------------------------------------------------------------------------------------
		// SET maskColor - Sets the color used to mask unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set maskColor(value:uint):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {
			
				cropMaskColor = value;
				
				// Mask off high-order 8 bits and replace with the mask alpha value
				
				cropMaskColor &= 0x00FFFFFF;
				cropMaskColor |= cropMaskAlpha;
				
				// Set a flag to indicate that a mask property has changed and schedule a property update
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
								
		// --------------------------------------------------------------------------------------------------
		// GET maskAlpha - Returns the alpha level for the unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) for the mask that is used to indicate the non-selected portion of the cropped image. The mask will only be visible when the dimensions of the cropping rectangle are smaller than the dimensions of the image.
		 * 
		 * @default 0.3
		 */
		
		public function get maskAlpha():Number {
			if (cropMaskAlpha > 0) return (cropMaskAlpha >> 48) / 100;
			else return 0;
		}				

		// --------------------------------------------------------------------------------------------------
		// SET maskAlpha - Sets the alpha level for the unselected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set maskAlpha(value:Number):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {
	
				// Value must be between 0 and 1
				
				if (value > 1) value = 1;
				else if (value < 0) value = 0;
				
				// Convert the Number to an 8 bit value and position the bits as the high order 8 bits
				
				var a:uint = Math.round(value * 255);
				cropMaskAlpha = (Math.round(value * 255)) << 24;
				
				// Set the high order 8 bits of the mask color to the alpha value
				
				cropMaskColor &= 0x00FFFFFF;
				cropMaskColor |= cropMaskAlpha;
				
				// Set a flag to indicate that a mask property has changed and schedule a property update
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}		

		// --------------------------------------------------------------------------------------------------
		// GET handleColor - Returns the color of the cropping handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * The color used for the four corner handles of the cropping rectangle.
		 * 
		 * @default 0x00FF0000
		 */

		public function get handleColor():uint {
			return (cropHandleColor & 0x00FFFFFF);
		}	

		// --------------------------------------------------------------------------------------------------
		// SET handleColor - Sets the color of the cropping handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set handleColor(value:uint):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {
	
				cropHandleColor = value;
				
				// Mask off high-order 8 bits and replace with the crop handle alpha value
				
				cropHandleColor &= 0x00FFFFFF;
				cropHandleColor |= cropHandleAlpha;
				
				// Set a flag to indicate that a mask property has changed and schedule a property update
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}		
								
		// --------------------------------------------------------------------------------------------------
		// GET handleAlpha - Returns the alpha level for the crop handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) for the four corner handles of the cropping rectangle.
		 * 
		 * @default 0.5
		 */

		public function get handleAlpha():Number {
			return cropHandleAlpha;
		}

		// --------------------------------------------------------------------------------------------------
		// SET handleAlpha - Sets the alpha level for the crop handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set handleAlpha(value:Number):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {

				// Value must be between 0 and 1
				
				if (value > 1) value = 1;
				else if (value < 0) value = 0;
				
				// Save the new alpha value
				
				cropHandleAlpha = value;
				
				// Set a flag to indicate that a mask property has changed and schedule a property update
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
								
		// --------------------------------------------------------------------------------------------------
		// GET outlineColor - Returns the color of the crop area outline
		// --------------------------------------------------------------------------------------------------

		/**
		 * The color used for single pixel outline drawn around the cropping rectangle and around the four corner handles of the cropping rectangle.
		 * 
		 * @default 0x00FFFFFF
		 */

		public function get outlineColor():uint {
			return cropSelectionOutlineColor;
		}
		
		// --------------------------------------------------------------------------------------------------
		// SET outlineColor - Sets the color of the crop area outline
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set outlineColor(value:uint):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {

				cropSelectionOutlineColor = value;
				
				// Set a flag to indicate that a mask property has changed and schedule a property update
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}		
		
		// --------------------------------------------------------------------------------------------------
		// GET outlineAlpha - Returns the alpha level for the crop area outline
		// --------------------------------------------------------------------------------------------------

		/**
		 * The level of transparency (0 to 1) used for the single pixel outline drawn around the cropping rectangle and around the four corner handles of the cropping rectangle.
		 * 
		 * @default 0
		 */

		public function get outlineAlpha():Number {
			return cropSelectionOutlineAlpha;
		}
				
		// --------------------------------------------------------------------------------------------------
		// SET outlineAlpha - Sets the alpha level for the crop area outline
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set outlineAlpha(value:Number):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {

				// Value must be between 0 and 1
				
				if (value > 1) value = 1;
				else if (value < 0) value = 0;
				
				// Save the new alpha value
				
				cropSelectionOutlineAlpha = value;
				
				// Set a flag to indicate that a mask property has changed and schedule a property update
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET handleSize - Returns the size of the cropping handles
		// --------------------------------------------------------------------------------------------------

		/**
		 * The size of each of the four corner handles of the cropping rectangle. The minimum allowed handle size is 3. 
		 * 
		 * @default 10
		 */

		public function get handleSize():Number {
			return cropHandleSize;
		}
		
		// --------------------------------------------------------------------------------------------------
		// SET handleSize - Sets the size of the cropping handles (the minimum handle size is 3)
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set handleSize(value:Number):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {
	
				// Remove hand cursor if active
				
				if (handCursorID >= 0) {
					CursorManager.removeCursor(handCursorID);
					handCursorID = -1;
				}
				
				// Minimum habdle size is 3
				
				cropHandleSize = value < 3 ? 3 : value;
				
				// Set the minimum allowed size for the cropping rectangle to twice the size of a handle
				
				cropRectMinimumSize = value * 2;
				
				// Set a flag to indicate that a mask property has changed and schedule a property update
				
				cropMaskChanged = true;
				invalidateProperties();
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET constrainToAspectRatio - Returns whether or not the dimensions of the cropping rectangle are constrained to the ratio of cropping rectangle's current width and height
		// --------------------------------------------------------------------------------------------------

		/**
		 * If set to <code>true</code> then the cropping rectangle will always maintain the aspect ratio that was active when the <code>constrainToAspectRatio</code> property was set.
		 * For example, suppose the cropping rectangle has dimensions of 200 x 100 (an aspect ratio of 2:1). If <code>constrainToAspectRatio</code> is set to <code>true</code> then 
		 * dragging any of the handles will cause the cropping rectangle to maintain a 2:1 relationship between the width and the height. If dragging a handle causes the width to increase 
		 * to 400, then the height of the cropping rectangle will be adjusted to 200. If the height is changed to 50, then the width will be adjusted to 100.
		 * 
		 * <p>Enabling <code>constrainToAspectRatio</code> can be useful if you wish to crop an image so that it can be scaled to fixed dimensions without distortion. For example,
		 * suppose that you want to crop an image so that it will exactly fit a target area that is 400 pixels wide and 600 pixels high. Since the target area has an aspect ratio of 2:3
		 * you'll want to call the <code>setCropRect</code> method to set an initial cropping rectangle with dimensions that conform to the target aspect ratio. In this case, let's say that 
		 * we set the cropping rectangle to a width of 80 and to a height of 120 (a ratio of 2:3). Now when we set <code>constrainToAspectRatio</code>
		 * to <code>true</code> the cropping rectangle will always maintain a width to height ratio of 2:3. Once the portion of the image to crop is selected, all that needs to be
		 * done is to retrieve the <code>BitmapData</code> from the <code>croppedBitmapData</code> parameter and then scale the <code>BitmapData</code> to the final size (400 x 600).<p>
		 * 
		 * Setting <code>constrainToAspectRatio</code> to <code>false</code> allows the width and height of the cropping rectangle to be adjusted independently. 
		 * 
		 * @default false
		 */

		public function get constrainToAspectRatio():Boolean {
			return cropRatioActive;
		}
		
		// --------------------------------------------------------------------------------------------------
		// SET constrainToAspectRatio - Sets whether or not to constrain the dimensions of the cropping rectangle to the ratio of cropping rectangle's current width and height
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set constrainToAspectRatio(constrain:Boolean):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {
			
				// If constrainToAspectRatio is true and both the width and height of the cropping rectangle is non-zero, calculate the cropRatio
				
				if (constrain) {				
					if (cropRect != null) cropRatio = cropRect.width / cropRect.height;
					else cropRatio = 0;
				}
				else cropRatio = 0;
				
				// Set a flag to indicate if the cropping rectangle is constained to the aspect ratio
				
				cropRatioActive = constrain;
			}
		}		

		// --------------------------------------------------------------------------------------------------
		// GET sourceImage - Returns the source image as a BitmapData object
		// --------------------------------------------------------------------------------------------------

		/**
		 * Either a <code>String</code> that contains a URL pointing to an image or a <code>BitmapData</code> object that contains an image.
		 * 
		 * <p>If a URL <code>String</code> is assigned to this parameter, then a <code>sourceImageLoading</code> event will be dispatched and the 
		 * component will begin loading the referenced image. Once the image has been loaded then a <code>sourceImageReady</code> event will be dispatched
		 * and the image will be displayed in the component. If an error occurs while loading the image, then a <code>sourceImageLoadError</code> event will be dispatched</p>
		 * 
		 * <p>If a <code>BitmapData</code> object is assigned to this parameter, then a <code>sourceImageReady</code> event will immediately be dispatched
		 * and the image contained in the <code>BitmapData</code> object will be displayed in the component.</p>
		 * 
		 * <p>When reading this parameter an <code>Object</code> will be returned of type <code>String</code> or of type <code>BitmapData</code>, depending upon what type of
		 * object was last assigned to the <code>sourceImage</code> parameter. If no assignment was made to the <code>sourceImage</code> parameter, then <code>null</code> is returned.</p>
		 */

		public function get sourceImage():Object {
			return imageSource;
		}
								
		// --------------------------------------------------------------------------------------------------
		// SET sourceImage - Sets the source image to be cropped
		// --------------------------------------------------------------------------------------------------

		/**
		 * @private
		 */

		public function set sourceImage(value:Object):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {
		
				// If a URL String or a BitmapData object has been passed
				
				if (value != null && (value is String || value is BitmapData)) {
					
					// Remove hand cursor if active
					
					if (handCursorID >= 0) {
						CursorManager.removeCursor(handCursorID);
						handCursorID = -1;
					}				
				
					// If an image has already been loaded, erase the image from the display and make sure listeners are disabled
					
					if (imageBitmapData != null) {
						if (componentBitmap != null) componentBitmapData.fillRect(componentBitmapData.rect, bkgndColor);		
						imageBitmapData.dispose();
						imageBitmapData = null;
						imageSource = null;
						activateListeners(false);
					}
	
					// If a URL was passed
					
					if (value is String) {
												
						// Create a loader for the requested image
						
						currentSource = new Loader();
						
						// Add listeners
						
						sourceLoadListeners(true);
	
						// Begin loading the requested image
						
						currentSource.load(new URLRequest(String(value)));
						
						// Dispatch load event
						
						dispatchEvent(new Event(SOURCE_IMAGE_LOADING));					
					}
					
					// Else a BitmapData object was passed
					
					else {
					
						// Clone passed BitmapData for the image
						
						imageBitmapData = BitmapData(value).clone();
						
						// Set flag that new image has been loaded
						
						newImageLoaded = true;			
						
						// Mark the component so that updateDisplayList() is  called during the next screen update
			
						invalidateDisplayList();
						
						// Save image source object
					
						imageSource = imageBitmapData;
					
						// Add event listeners
						
						activateListeners(true);
						
						// Dispatch image loaded notification event
					
						dispatchEvent(new Event(SOURCE_IMAGE_READY));					
					}
				}
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// GET croppedBitmapData - Returns the bitmap data for the cropped image at actual size
		// --------------------------------------------------------------------------------------------------

		/**
		 * The cropped source image as a <code>BitmapData</code> object. The cropped portion of the source image is defined by the position and the dimensions of the cropping rectangle.
		 */

		public function get croppedBitmapData():BitmapData {
		
			// If this function is called before the component has a chance to create componentBitmapData, then call initializeDisplay()
			
			if (componentBitmapData == null) initializeDisplay(this.width, this.height);
					
			// If the image has not been rendered yet, create a scaled version of the image that will fit within the component
					
			if (newImageLoaded) createScaledImage();		

			// If the cropping rectangle has changed but has not yet been initialized, then initialize the cropping rectangle before proceeding
			
			if (newCroppingRect) initializeCroppingRect();
			
			// Extract cropped area from image
			
			var croppedBitmap:BitmapData = null;
			var sourceImageRect:Rectangle = getCropRect();
			
			if (imageBitmapData != null && sourceImageRect != null && sourceImageRect.width > 0 && sourceImageRect.height > 0) {
				croppedBitmap = new BitmapData(sourceImageRect.width, sourceImageRect.height, false);
				croppedBitmap.copyPixels(imageBitmapData, sourceImageRect, new Point(0, 0));
			}
			
			return croppedBitmap;
		}
		
		// --------------------------------------------------------------------------------------------------
		// setCropRect - Set the initial crop area
		// --------------------------------------------------------------------------------------------------
		
		/**
		 * This method defines the position and the dimensions of the cropping rectangle within the component.
		 * 
		 * <p>Note that values specified for the <code>width</code>, <code>height</code>, <code>x</code> and <code>y</code> parameters can be relative to either the component (if <code>componentRelative</code> is <code>true</code>)
		 * or to the source image (if <code>componentRelative</code> is <code>false</code>).</p>
		 * 
  		 * <p>For example, suppose the component has dimensions of 250x250 but the source image has dimensions of 500x500. In this case the component will automatically scale the source image so that it fits within
  		 * the component area. If <code>componentRelative</code> is set to <code>false</code> then setting a cropping rectangle with dimensions of 100x50 will result in a cropping rectangle being drawn in the component
  		 * area with dimensions of 50x25 (i.e. the cropping rectangle dimensions are relative to the source image). If <code>componentRelative</code> is set to <code>true</code> then the cropping rectangle will be drawn with 
  		 * dimensions of 100x50 (i.e. the cropping rectangle dimensions are relative to the component area).</p>
  		 * 
  		 * <p>If the <code>width</code> or the <code>height</code> parameter is assigned a value of zero, then the cropping rectangle will be set to the full size of the image and any values specified for 
  		 * the <code>x</code> and <code>y</code> parameters will be ignored.</p>
		 * 
		 * @param width Sets the width of the cropping rectangle. Setting <code>width</code> to zero will result in both the width and the height of the cropping rectangle being set to the size of the image displayed in the component.
		 * 
		 * @param height Sets the height of the cropping rectangle. Setting <code>height</code> to zero will result in both the width and the height of the cropping rectangle being set to the size of the image displayed in the component.
		 * 
		 * @param x Sets the horizontal position of the cropping rectangle. Setting <code>x</code> to -1 will result in the cropping rectangle being centered vertically and horizontally in the component.
		 * 
		 * @param y Sets the vertical position of the cropping rectangle. Setting <code>y</code> to -1 will result in the cropping rectangle being centered vertically and horizontally in the component.
		 * 
		 * @param componentRelative When set to <code>true</code> then the <code>width</code>, <code>height</code>, <code>x</code> and <code>y</code> parameters are relative to the image 
		 * displayed in the component. When <code>componentRelative</code> is set to <code>false</code> then the parameters are relative to the source image. If the source image completely fits within
		 * the component without scaling, then <code>componentRelative</code> in essence has no effect since the component image and the source image are identical.
		 */

		public function setCropRect(width:Number = 0, height:Number = 0, x:Number = -1, y:Number = -1, componentRelative:Boolean = false):void {
			
			// If the ImageCropper component is enabled ...
			
			if (componentEnabled) {

				// Remove hand cursor if active
				
				if (handCursorID >= 0) {
					CursorManager.removeCursor(handCursorID);
					handCursorID = -1;
				}		
				
				// Make sure crop area values are not less than minimum allowed values
				
				if (width < 0) width = 0;
				if (height < 0) height = 0;
				if (x < -1) x = -1;
				if (y < -1) y = -1;
				
				// Save the initial position coordinates. If they are greater than or equal to zero then they are used to position the top-left corner of the cropping rectangle. 
				
				cropX = x;
				cropY = y;
				
				// Set the dimensions of the cropping rectangle
				
				cropWidth = width;
				cropHeight = height;
	
				// If either dimension is zero than the crop area will be set to the scaled image area. If the image has not yet been loaded the cropRatioActive will be set to false
				// because there is no way to detemine an aspect ratio.
	
				if (cropWidth == 0 || cropHeight == 0) {
					
					// If one dimension is zero, then set the other dimension to zero
					
					cropWidth = 0;
					cropHeight = 0;
					
					// If the cropping rectangle is constrained to the aspect ratio
					
					if (cropRatioActive) {
						
						// If there is an image then set the cropping rectangle's dimensions equal to the scaled image size (the ratio is set below)
						
						if (scaledImageBitmapData != null) {
							cropWidth = scaledImageBitmapData.width - 1;
							cropHeight = scaledImageBitmapData.height - 1;
						}
						
						// Else there is no image so there cannot be an aspect ratio constraint on the cropping rectangle
						
						else {
							dispatchEvent(new Event(CROP_CONSTRAINT_DISABLED));
							cropRatioActive = false;
						}
					}
				}
				
				// If componentRelative is set to true, then the cropping rectangle size will be set to the actual size specified (assuming it will fit within the image area).
				// If componentRelative is set to false, then the cropping rectangle size represents the size of the final image so the cropping rectangle will be scaled to match the scale of the selected image
				
				croppingRectIsImageScale = !componentRelative;
				
				// If constrainToAspectRatio is true and both the width and height of the cropping rectangle is non-zero, calculate the cropRatio
				
				if (cropRatioActive) cropRatio = cropWidth / cropHeight;
				else cropRatio = 0;
				
				// Set the "newCroppingRect" flag so that a BitMapData object will be constructed when updateDisplayList() is next called
				
				newCroppingRect = true;
				
				// Invalidate the display list in order to schedule a call to updateDisplayList()
							
				invalidateDisplayList();
			}		
		}	
				
		// --------------------------------------------------------------------------------------------------
		// getCropRect - Return the selected crop area
		// --------------------------------------------------------------------------------------------------

		/**
		 * Returns the position and the dimensions of the cropped portion of the image as a <code>Rectangle</code>.
		 * 
		 * @param componentRelative If set to <code>true</code> then the <code>Rectangle</code> returned represents the position and dimensions of the cropping rectangle in the component.
		 * If set to <code>false</code> then the <code>Rectangle</code> returned represents the position and dimensions of the crop area in the source image.
		 * 
		 * @param roundValues If set to <code>true</code> then all values in the returned <code>Rectangle</code> are rounded to integer values.
		 * 
		 * @return The position and dimensions of the crop area relative to the component (if <code>componentRelative</code> is <code>true</code>) or relative to the source image 
		 * (if <code>componentRelative</code> is <code>false</code>). If a cropping rectangle has not been defined, then <code>null</code> will be returned.
		 */
		
		public function getCropRect(componentRelative:Boolean = false, roundValues:Boolean = false):Rectangle {
		
			// The cropRect must be defined
			
			if (cropRect != null) {
				
				var requestedRect:Rectangle;
			
				// If the position and size of the cropping area in the component is requested, return the current cropRect
				
				if (componentRelative) requestedRect = cropRect.clone();
				
				// Else the cropRect is translated back to unscaled coordinates and dimensions and returned
				
				else requestedRect = new Rectangle(cropRect.x / imageScaleFactor, cropRect.y / imageScaleFactor, cropRect.width / imageScaleFactor, cropRect.height / imageScaleFactor);
				
				// If rounding was requested, round each rectangle value
				
				if (roundValues) {
					requestedRect.x = Math.round(requestedRect.x);
					requestedRect.y = Math.round(requestedRect.y);
					requestedRect.width = Math.round(requestedRect.width);
					requestedRect.height = Math.round(requestedRect.height);
				}
				
				// Return the Rectangle
				
				return requestedRect; 
			}
			
			else return null;
		}								
		
		// --------------------------------------------------------------------------------------------------
		// sourceLoadSuccess - Called when the source image has been loaded and initialized
		// --------------------------------------------------------------------------------------------------

		private function sourceLoadSuccess(event:Event):void {
			
			// Get the  bitmap data for the loaded image 
			
			imageBitmapData = Bitmap(currentSource.content).bitmapData.clone();
						
			// Remove the event listeners for loading the image and release the Loader
			
			sourceLoadListeners(false);
			
			// Save image source object
				
			imageSource = imageBitmapData;
			
			// Set flag that new image has been loaded
			
			newImageLoaded = true;
			
			// Mark the component so that updateDisplayList() is  called during the next screen update

			invalidateDisplayList();
							
			// Add event listeners
					
			activateListeners(true);

			// Dispatch image loaded notification event
				
			dispatchEvent(new Event(SOURCE_IMAGE_READY));					
		}		
		
		// --------------------------------------------------------------------------------------------------
		// sourceLoadFailure - Called when an error occurs loading the source image 
		// --------------------------------------------------------------------------------------------------

		private function sourceLoadFailure(event:IOErrorEvent):void {

			// Remove the event listeners
			
			sourceLoadListeners(false);

			// Dispatch image load error notification event
				
			dispatchEvent(new Event(SOURCE_IMAGE_LOAD_ERROR));								
		}		
		
		// --------------------------------------------------------------------------------------------------
		// sourceLoadListeners - Adds or removes listeners to monitor the source image load process
		// --------------------------------------------------------------------------------------------------

		private function sourceLoadListeners(addListeners:Boolean):void {
					
			// If listeners are being added
			
			if (addListeners) {
			
				// Request to be notified when the image has been loaded and initialized
						
				currentSource.contentLoaderInfo.addEventListener(Event.INIT, sourceLoadSuccess);
						
				// Request to be notified if an error occurs during the image load process
						
				currentSource.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, sourceLoadFailure);
			}
			
			// Else release resources
			
			else {
				
				// Remove the listeners
				
				currentSource.contentLoaderInfo.removeEventListener(Event.INIT, sourceLoadSuccess);
				currentSource.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, sourceLoadFailure);
				
				// Release the loader
			
				try {
					currentSource.close();
				}
				catch(e:Error) {};
				
				currentSource.unload();
				currentSource = null;				
			}	
		}		
								
		// --------------------------------------------------------------------------------------------------
		// activateListeners - Called to assign or release listeners for the component (mouse listeners should only be active when a source image is assigned) 
		// --------------------------------------------------------------------------------------------------

		private function activateListeners(addListeners:Boolean):void {

			if (addListeners && !mouseListenersActive) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				this.addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
				mouseListenersActive = true;
			}
			
			// Remove event listeners
			
			else if (!addListeners && mouseListenersActive) {
				this.removeEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				this.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, doMouseUp);
				systemManager.stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				mouseListenersActive = false;
				if (currentSource != null) sourceLoadListeners(false);
			}		
		}
		
		// --------------------------------------------------------------------------------------------------
		// mouseLocation - Given a mouse event, returns -1 if the mouse is outside of the cropping rectangle, 1 if the mouse is in the top-left handle, 2 if the mouse is in the top-right handle,
		//                 3 if the mouse is in the bottom-left handle, 4 if the mouse is in the bottom-right handle, or 0 if the mouse is in the interior of the cropping rectangle
		// --------------------------------------------------------------------------------------------------

		private function mouseLocation(event:MouseEvent):int {
			
			// Get the location of the mouse relative to the image area
			
			var mouseXLoc:Number = event.localX - imageLocation.x;
			var mouseYLoc:Number = event.localY - imageLocation.y;
						
			// If the cropping rectangle contains the mouse location point
			
			if (cropRect != null && cropRect.contains(mouseXLoc, mouseYLoc)) {
			
				// Calculate the distance between the top-left corner of the cropping rectangle to the mouse location
				
				var mouseDeltaX:Number = mouseXLoc - cropRect.x;
				var mouseDeltaY:Number = mouseYLoc - cropRect.y;
				
				// Top-left handle?
				
				if (mouseDeltaX <= cropHandleSize && mouseDeltaY <= cropHandleSize) return 1;
				
				// Top-right handle?
				
				else if (mouseDeltaX >= cropRect.width - cropHandleSize && mouseDeltaY <= cropRect.width && mouseDeltaY <= cropHandleSize) return 2;
				
				// Bottom-left handle?
								
				else if (mouseDeltaX <= cropHandleSize && mouseDeltaY >= cropRect.height - cropHandleSize && mouseDeltaY <= cropRect.height) return 3;

				// Bottom-right handle?

				else if (mouseDeltaX >= cropRect.width - cropHandleSize && mouseDeltaY <= cropRect.height && mouseDeltaY >= cropRect.height - cropHandleSize && mouseDeltaY <= cropRect.height) return 4;
				
				// Cropping rectangle interior
				
				else return 0;
			}
			
			// The mouse is not in the cropping rectangle area
			
			else return -1;
		}								
				
		// --------------------------------------------------------------------------------------------------
		// doMouseDown
		// --------------------------------------------------------------------------------------------------

		private function doMouseDown(event:MouseEvent):void {
			
			// Find out where the mouse down even occurred
			
			var mouseLoc:int = mouseLocation(event);			
			
			// If the cropping rectangle contains the mouse location point
			
			if (mouseLoc >= 0) {
			
				// Calculate the distance between the top-left corner of the cropping rectangle to the mouse location
				
				var mouseDeltaX:Number = event.localX - imageLocation.x - cropRect.x;
				var mouseDeltaY:Number = event.localY - imageLocation.y - cropRect.y;

				// Top-left handle?
				
				if (mouseLoc == 1) {
					anchorX = mouseDeltaX;
					anchorY = mouseDeltaY;					
					activeHandle = 1;
				}					
				
				// Top-right handle?
				
				else if (mouseLoc == 2) {
					anchorX = mouseDeltaX - cropRect.width;
					anchorY = mouseDeltaY;	
					activeHandle = 2;
				}					
				
				// Bottom-left handle?
								
				else if (mouseLoc == 3) {
					anchorX = mouseDeltaX;
					anchorY = mouseDeltaY - cropRect.height;	
					activeHandle = 3;
				}

				// Bottom-right handle?

				else if (mouseLoc == 4) {
					anchorX = mouseDeltaX - cropRect.width;
					anchorY = mouseDeltaY - cropRect.height;	
					activeHandle = 4;
				}
				
				// Cropping rectangle interior
				
				else {
					anchorX = mouseDeltaX;
					anchorY = mouseDeltaY;
					activeHandle = 0;
				}
				
				// Add listener for mouse events
				
				this.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, doMouseExit);
				systemManager.stage.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			}
		}
			
		// --------------------------------------------------------------------------------------------------
		// doMouseExit - Called when the mouse is outside of the Player area
		// --------------------------------------------------------------------------------------------------

		private function doMouseExit(event:Event):void {
			doMouseUp(null);
		}
		
		// --------------------------------------------------------------------------------------------------
		// doMouseUp
		// --------------------------------------------------------------------------------------------------

		private function doMouseUp(event:MouseEvent):void {
		
			// Clear active handle tracking variable
			
			activeHandle = -1;
			
			// Remove listeners
			
			this.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, doMouseUp);
			systemManager.stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			
			// Send event that the crop area has been updated 
			
			dispatchEvent(new Event(CROP_RECT_CHANGED));
		}		
					
		// --------------------------------------------------------------------------------------------------
		// doMouseMove - Follow the mouse and move or resize the cropping rectangle
		// --------------------------------------------------------------------------------------------------

		private function doMouseMove(event:MouseEvent):void {
			
			// If a cropping rectangle has been set and the mouse button is down
			
			if (croppingRectBitmapData != null && event.buttonDown) {
				
				// Local variables
				
				var topX:Number;
				var topY:Number;
				var btmX:Number;
				var btmY:Number;
				
				var scaledW:Number;
				var scaledH:Number; 
			
				// Get the location of the mouse relative to the cropping rectangle bitmap
				
				var mouseX:Number = event.localX - imageLocation.x;
				var mouseY:Number = event.localY - imageLocation.y;
				
				// Drag cropping rectangle
				
				if (activeHandle == 0) {
				
					// Calculate the new top-left corner of the cropping rectangle
					
					cropRect.x = mouseX - anchorX;
					cropRect.y = mouseY - anchorY;
					
					// Make sure that the entire cropping rectangle stays within the image area
					
					if (cropRect.x < 0) cropRect.x = 0;
					else {
						var maxX:Number = Math.floor(imageScaledWidth - cropRect.width - 1);
						if (cropRect.x > maxX) cropRect.x = maxX;
					}
					
					if (cropRect.y < 0) cropRect.y = 0;
					else {
						var maxY:Number = Math.floor(imageScaledHeight - cropRect.height - 1);
						if (cropRect.y > maxY) cropRect.y = maxY;
					}
				}
				
				// Top-left Handle
				
				else if (activeHandle == 1) {
					
					// Get the new position of the top-left corner of the cropping rectangle
					
					topX = mouseX - anchorX;
					topY = mouseY - anchorY;
					
					// If the new position of the top-left corner of the cropping rectangle is outside the top or left margin, then set the corner to the top or left margin
					
					if (topX < 0) topX = 0;
					if (topY < 0) topY = 0;
					
					// Get the current position of the bottom-right corner of the cropping rectangle
										
					btmX = cropRect.x + cropRect.width;
					btmY = cropRect.y + cropRect.height;
					
					// Calculate the new width of the cropping rectangle
					
					cropRect.width = btmX - topX;
					
					// If the new width is less than the minimum allowed size then set the new width to the minimum
					
					if (cropRect.width < cropRectMinimumSize) {
						cropRect.width = cropRectMinimumSize;
						topX = btmX - cropRectMinimumSize;
					}
					
					if (cropRect.width > cropRectMaxSize) {
						cropRect.width = cropRectMaxSize;
						topX = btmX - cropRectMaxSize;
					}
					
					
					// Set the new x position for the top-left corner of the cropping rectangle
					
					cropRect.x = topX;

					// Calculate the new height of the cropping rectangle
					
					cropRect.height = btmY - topY;
					
					// If the new height is less than the minimum allowed size then set the new height to the minimum
					
					if (cropRect.height < cropRectMinimumSize) {
						cropRect.height = cropRectMinimumSize;
						cropRect.y = btmY - cropRectMinimumSize;
					}
					if (cropRect.height > cropRectMaxSize) {
						cropRect.height = cropRectMaxSize;
						cropRect.y = btmY - cropRectMaxSize;
					}
					
					else cropRect.y = topY;
					
					// If a cropping ratio is defined
					
					if (cropRatioActive) {
						
						// If the cropping rectangle is not at the correct ratio
					
						if (cropRect.width / cropRect.height != cropRatio) {
							
							// Get a new scaled width for the cropping rectangle
							
							scaledW = cropRect.height * cropRatio;
							
							// If the new width is less then the minimum allowed width
							
							if (scaledW < cropRectMinimumSize) {
								
								// Set the width to the minimum
								
								scaledW = cropRectMinimumSize;
								
								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
								
								// Adjust the y coordinate of the cropping rectangle for the new scaled height
								
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// Move the horizontal position to compensate for the scaled width
							
							cropRect.x += cropRect.width - scaledW;
							
							// If the new width is to the left of the left margin
							
							if (cropRect.x < 0) {
								
								// Reduce the width of the cropping rectangle by the amount that the cropping rectangle extends past the left margin
								
								scaledW += cropRect.x;
								
								// Set the left edge of the cropping rectangle to the left margin
								
								cropRect.x = 0;

								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
								
								// Adjust the y coordinate of the cropping rectangle for the new scaled height
								
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// Set the scaled width for the cropping rectangle
							
							cropRect.width = scaledW;														
						}
					}					
				}
				
				// Top-right Handle
				
				else if (activeHandle == 2) {
					
					// Get the new position of the top-right corner of the cropping rectangle
					
					topX = mouseX - anchorX;
					topY = mouseY - anchorY;
										
					// Get the current position of the bottom-left corner of the cropping rectangle
										
					btmX = cropRect.x;
					btmY = cropRect.y + cropRect.height;
					
					// If the new position of the top-right corner of the cropping rectangle is outside the top or right margin, then set the corner to the top or right margin
					
					if (topX > imageScaledWidth - 1) topX = imageScaledWidth - 1;
					if (topY < 0) topY = 0;
					
					// Calculate the new width of the cropping rectangle
					
					cropRect.width = topX - btmX;
					
					// If the new width is less than the minimum allowed size then set the new width to the minimum
					
					if (cropRect.width < cropRectMinimumSize) {
						cropRect.width = cropRectMinimumSize;
						topX = btmX + cropRectMinimumSize;
					}
					if (cropRect.width > cropRectMaxSize) {
						cropRect.width = cropRectMaxSize;
						topX = btmX + cropRectMaxSize;
					}
					
					// Set the new x position for the top-left corner of the cropping rectangle
					
					cropRect.x = btmX;
					
					// Calculate the new height of the cropping rectangle
					
					cropRect.height = btmY - topY;
					
					// If the new height is less than the minimum allowed size then set the new height to the minimum
					
					if (cropRect.height < cropRectMinimumSize) {
						cropRect.height = cropRectMinimumSize;
						cropRect.y = btmY - cropRectMinimumSize;
					}
					else cropRect.y = topY;
					
					if (cropRect.height > cropRectMaxSize) {
						cropRect.height = cropRectMaxSize;
						cropRect.y = btmY - cropRectMaxSize;
					}
					else cropRect.y = topY;
					
					
					
					// If a cropping ratio is defined
					
					if (cropRatioActive) {
						
						// If the cropping rectangle is not at the correct ratio
					
						if (cropRect.width / cropRect.height != cropRatio) {
							
							// Get a new scaled width for the cropping rectangle
							
							scaledW = cropRect.height * cropRatio;
							
							// If the new width is less then the minimum allowed width
							
							if (scaledW < cropRectMinimumSize) {
								
								// Set the width to the minimum
								
								scaledW = cropRectMinimumSize;
								
								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
								
								// Adjust the y coordinate of the cropping rectangle for the new scaled height
								
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// If the new width exceeds the maximum allowed width
							
							if (cropRect.x + scaledW > imageScaledWidth - 1) {
								
								// Set the width to the maximum allowed
								
								scaledW = imageScaledWidth - 1 - cropRect.x;
								
								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
								
								// Adjust the y coordinate of the cropping rectangle for the new scaled height
								
								cropRect.y = cropRect.y + (cropRect.height - scaledH);
								
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// Set the scaled width for the cropping rectangle
							
							cropRect.width = scaledW;							
						}
					}
				}
				
				// Bottom-left Handle
				
				else if (activeHandle == 3) {
					
					// Get the new position of the bottom-left corner of the cropping rectangle
					
					btmX = mouseX - anchorX;
					btmY = mouseY - anchorY;

					// If the new position of the bottom-left corner of the cropping rectangle is outside the bottom or left margin, then set the corner to the bottom or left margin
					
					if (btmX < 0) btmX = 0;
					if (btmY > imageScaledHeight - 1) btmY = imageScaledHeight - 1;

					// Get the current position of the top-right corner of the cropping rectangle
										
					topX = cropRect.x + cropRect.width;
					topY = cropRect.y;

					// Calculate the new width of the cropping rectangle
					
					cropRect.width = topX - btmX;
					
					// If the new width is less than the minimum allowed size then set the new width to the minimum
					
					if (cropRect.width < cropRectMinimumSize) {
						cropRect.width = cropRectMinimumSize;
						btmX = topX - cropRectMinimumSize;
					}
					
					if (cropRect.width > cropRectMaxSize) {
						cropRect.width = cropRectMaxSize;
						btmX = topX - cropRectMaxSize;
					}
					
					
					// Set the new x position for the top-left corner of the cropping rectangle
					
					cropRect.x = btmX;
					
					// Calculate the new height of the cropping rectangle
					
					cropRect.height = btmY - topY;
					
					// If the new height is less than the minimum allowed size then set the new height to the minimum
					
					if (cropRect.height < cropRectMinimumSize) cropRect.height = cropRectMinimumSize;
					if (cropRect.height > cropRectMaxSize) cropRect.height = cropRectMaxSize;

					
					// Set the new y position for the top-left corner of the cropping rectangle
					
					cropRect.y = topY;
					
					// If a cropping ratio is defined
					
					if (cropRatioActive) {
						
						// If the cropping rectangle is not at the correct ratio
					
						if (cropRect.width / cropRect.height != cropRatio) {
							
							// Get a new scaled width for the cropping rectangle
							
							scaledW = cropRect.height * cropRatio;
							
							// If the new width is less then the minimum allowed width
							
							if (scaledW < cropRectMinimumSize) {
								
								// Set the width to the minimum
								
								scaledW = cropRectMinimumSize;
								
								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
																
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// Move the horizontal position to compensate for the scaled width
							
							cropRect.x += cropRect.width - scaledW;
							
							// If the new width is to the left of the left margin
							
							if (cropRect.x < 0) {
								
								// Reduce the width of the cropping rectangle by the amount that the cropping rectangle extends past the left margin
								
								scaledW += cropRect.x;
								
								// Set the left edge of the cropping rectangle to the left margin
								
								cropRect.x = 0;

								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
								
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// Set the scaled width for the cropping rectangle
							
							cropRect.width = scaledW;														
						}
					}					
				}
				
				// Bottom-right Handle				
				
				else if (activeHandle == 4) {
					
					// Get the new position of the bottom-left corner of the cropping rectangle
					
					btmX = mouseX - anchorX;
					btmY = mouseY - anchorY;
					
					// If the new position of the bottom-right corner of the cropping rectangle is outside the bottom or right margin, then set the corner to the bottom or right margin
					
					if (btmX > imageScaledWidth - 1) btmX = imageScaledWidth - 1;
					if (btmY > imageScaledHeight - 1) btmY = imageScaledHeight - 1;

					// Get the current position of the top-left corner of the cropping rectangle
										
					topX = cropRect.x;
					topY = cropRect.y;
					
					// Calculate the new width of the cropping rectangle
					
					cropRect.width = btmX - topX;
					
					// If the new width is less than the minimum allowed size then set the new width to the minimum
					
					if (cropRect.width < cropRectMinimumSize) {
						cropRect.width = cropRectMinimumSize;
						btmX = topX + cropRectMinimumSize;
					}
					if (cropRect.width > cropRectMaxSize) {
						cropRect.width = cropRectMaxSize;
						btmX = topX + cropRectMaxSize;
					}
										
					// Calculate the new height of the cropping rectangle
					
					cropRect.height = btmY - topY;
					
					// If the new height is less than the minimum allowed size then set the new height to the minimum
					
					if (cropRect.height < cropRectMinimumSize) cropRect.height = cropRectMinimumSize;
					if (cropRect.height > cropRectMaxSize) cropRect.height = cropRectMaxSize;
					
					// If a cropping ratio is defined
					
					if (cropRatioActive) {
						
						// If the cropping rectangle is not at the correct ratio
					
						if (cropRect.width / cropRect.height != cropRatio) {
							
							// Get a new scaled width for the cropping rectangle
							
							scaledW = cropRect.height * cropRatio;
							
							// If the new width is less then the minimum allowed width
							
							if (scaledW < cropRectMinimumSize) {
								
								// Set the width to the minimum
								
								scaledW = cropRectMinimumSize;
								
								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
																
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// If the new width exceeds the maximum allowed width
							
							if (cropRect.x + scaledW > imageScaledWidth - 1) {
								
								// Set the width to the maximum allowed
								
								scaledW = imageScaledWidth - 1 - cropRect.x;
								
								// Scale the height for the new width
								
								scaledH = scaledW / cropRatio;
																
								// Set the new height of the cropping rectangle
								
								cropRect.height = scaledH;
							}
							
							// Set the scaled width for the cropping rectangle
							
							cropRect.width = scaledW;							
						}
					}					
				}		
						
				// Render the cropping rectangle on top of the image
				
				drawCroppingRect();
				
				// Invalidate the display list to redraw the component
				
				invalidateDisplayList();				
			}
			
			// Else a handle is not active
			
			else {
				
				// If the cropping rectangle is smaller than the image dimensions and if the mouse is within the cropping rectangle but not in a handle then show the hand cursor
				
				if ((cropRect.width + 1 < Math.floor(imageScaledWidth) || cropRect.height + 1 < Math.floor(imageScaledHeight)) && mouseLocation(event) == 0) {
					if (handCursorID < 0) handCursorID = CursorManager.setCursor(handCursor, 2, -6, -3);
				}
				
				// Else the mouse is in a handle or outside of the cropping rectangle
				
				else {
					
					// If the hand cursor is active, remove it
					
					if (handCursorID >= 0) {
						CursorManager.removeCursor(handCursorID);
						handCursorID = -1;
					}										
				}
			}
		}
		
		// --------------------------------------------------------------------------------------------------
		// drawCroppingRect
		// --------------------------------------------------------------------------------------------------

		private function drawCroppingRect():void {
			
			// If the BitmapData object has been constructed, proceed to draw the cropping rectangle
			
			if (croppingRectBitmapData && componentEnabled) {
			
				// Clear the previous cropping rectangle by filling the bitmap with the mask color
				
				croppingRectBitmapData.fillRect(croppingRectBitmapData.rect, cropMaskColor);
				
				// Draw the transparent cropping rectangle area
				
				croppingRectBitmapData.fillRect(cropRect, 0x00FFFFFF);
				
				// Draw boarder around the cropping rectangle
				
				var border:Shape = new Shape();
				border.graphics.lineStyle(1, cropSelectionOutlineColor, cropSelectionOutlineAlpha);
				border.graphics.drawRect(cropRect.x, cropRect.y, cropRect.width, cropRect.height);
				croppingRectBitmapData.draw(border);	
				
				// Draw corner handles
				
				var handles:Shape = new Shape();
				handles.graphics.lineStyle(1, cropSelectionOutlineColor, cropSelectionOutlineAlpha);
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x, cropRect.y, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x + cropRect.width - cropHandleSize, cropRect.y, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x, cropRect.y + cropRect.height - cropHandleSize, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				handles.graphics.beginFill(cropHandleColor, cropHandleAlpha);
				handles.graphics.drawRect(cropRect.x + cropRect.width - cropHandleSize, cropRect.y + cropRect.height - cropHandleSize, cropHandleSize, cropHandleSize);
				handles.graphics.endFill();
				
				croppingRectBitmapData.draw(handles);
			}
		}		

		// --------------------------------------------------------------------------------------------------
		// commitProperties - Handle cropping rectangle property change (called by Flex when invalidateProperties is called after a change is made to a cropping rectangle property)
		// --------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		
		override protected function commitProperties():void {
			
			super.commitProperties();
			
			// If a property for the cropping rectangle has been changed
			
			if (cropMaskChanged) {
				
				// Reset property changed flag
				
				cropMaskChanged = false;
				
				// Check the cropping rectangle size to make sure that there is enough space to display the handles with no overlap; if there isn't, then increase the size of the cropping rectangle.

				if (cropRect != null && (cropRectMinimumSize > cropRect.width || cropRectMinimumSize > cropRect.height)) {
				
					var origRect:Rectangle = cropRect.clone();
						
					if (cropRect.y > imageScaledHeight - 1 - cropRectMinimumSize) cropRect.y = imageScaledHeight - 1 - cropRectMinimumSize;
					if (cropRect.x > imageScaledWidth - 1 - cropRectMinimumSize) cropRect.x = imageScaledWidth - 1 - cropRectMinimumSize;
					if (cropRect.height < cropRectMinimumSize) cropRect.height = cropRectMinimumSize;
					if (cropRect.width < cropRectMinimumSize) cropRect.width = cropRectMinimumSize;
					
					// If the aspect ratio is constrained, make sure that it doesn't change unless it's not possible to maintain the aspect ratio in the available space (given the current crop handle size)
					
					if (constrainToAspectRatio && cropRect.width != cropRect.height * cropRatio) {
						
						// Calculate what the new cropping rectangle width or the new cropping rectangle height will have to be in order to maintain the correct aspect ratio
						// (the dimension that is not less than the cropping rectangle cropRectMinimumSize will be used)
						
						var newWidth:Number = cropRect.height * cropRatio;
						var newHeight:Number = cropRect.width / cropRatio;
						
						// Increase width
						
						if (newWidth > cropRectMinimumSize) {
							
							// Set the cropping rectangle to the width that will maintain the aspect ratio
							
							cropRect.width = newWidth;
							
							// If the new width causes the crop box to extend beyond the right edge ...
							
							if (cropRect.x + cropRect.width > imageScaledWidth - 1) {
								
								// Find out how far off the edge the cropping rectangle extends
								
								var wDelta:Number = (cropRect.x + cropRect.width) - (imageScaledWidth - 1);
								
								// If there is room to the left of the cropping rectangle, adjust the left edge of the cropping rectangle so it fits in the available space
								
								if (cropRect.x - wDelta >= 0) cropRect.x = cropRect.x - wDelta;
								
								// Else there is no way to maintain the aspect ratio so extend the cropping rectangle from the left edge to the right edge, calculate the new aspect ratio, and dispatch an event indicating that the ratio has been altered
								
								else {
									cropRect.x = 0;
									cropRect.width = imageScaledWidth - 1;
									cropRatio = cropRect.width / cropRect.height;
									dispatchEvent(new Event(CROP_CONSTRAINT_CHANGED));
								}
							}
						}
						
						// Increase height
						
						else {
							
							// Set the cropping rectangle to the height that will maintain the aspect ratio
							
							cropRect.height = newHeight;
							
							// If the new height causes the crop box to extend beyond the bottom edge ...
							
							if (cropRect.y + cropRect.height > imageScaledHeight - 1) {
								
								// Find out how far off the edge the cropping rectangle extends
								
								var hDelta:Number = (cropRect.y + cropRect.height) - (imageScaledHeight - 1);
								
								// If there is room above the cropping rectangle, adjust the top edge of the cropping rectangle so it fits in the available space
								
								if (cropRect.y - hDelta >= 0) cropRect.y = cropRect.y - hDelta;
								
								// Else there is no way to maintain the aspect ratio so extend the cropping rectangle from the top to the bottom, calculate the new aspect ratio, and dispatch an event indicating that the ratio has been altered
								
								else {
									cropRect.y = 0;
									cropRect.height = imageScaledHeight - 1;
									cropRatio = cropRect.width / cropRect.height;
									dispatchEvent(new Event(CROP_CONSTRAINT_CHANGED));
									
								}
							}							
						}
					}

					// Dispatch events if the size of the handles cause the position or dimensions of the cropping rectangle to change
					
					if (cropRect.x != origRect.x || cropRect.y != origRect.y) dispatchEvent(new Event(CROP_POSITION_CHANGED));
					if (cropRect.width != origRect.width || cropRect.height != origRect.height) dispatchEvent(new Event(CROP_DIMENSIONS_CHANGED));
				}
				
				// Redraw the cropping rectangle area
				
				drawCroppingRect();
				
				// Schedule a display list update
				
				invalidateDisplayList();
			}
		}

		// --------------------------------------------------------------------------------------------------
		// measure - Sets the default component size and the component's minimum size in pixels 
		// --------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		
		override protected function measure():void {
			
			super.measure();
			
			if (!isNaN(componentWidth) && !isNaN(componentHeight)) {
			
				// Set default measurements
				
				measuredWidth = componentWidth;
				measuredHeight = componentHeight;
				
				// Set optional minimum size measurements
				
				measuredMinWidth = componentWidth;
				measuredMinHeight = componentHeight;
			}			
		}	

		// --------------------------------------------------------------------------------------------------
		// updateDisplayList - This method is called to size and position the children of the component based on all previous property and style settings.
		//                     It also draws any skins or graphic elements that the component uses. Note that the parent container determines the size of the component itself.
		// --------------------------------------------------------------------------------------------------
							
		/**
		 * @private
		 */

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {

			// The Flex callLaterDispatcher() can call updateDisplayList() after this component's destroy() method has been called but before it is garbage collected.
			// When destroy() is called the "destroyed" flag is set to prevent a null object reference error if updateDisplayList() is subsequently called.
			
			if (!destroyed) {
			
				super.updateDisplayList(unscaledWidth, unscaledHeight);
				
				// If the dimensions of the component have changed, create a new bitmap to match the components new size
				
				if (unscaledWidth != componentWidth || unscaledHeight != componentHeight) initializeDisplay(unscaledWidth, unscaledHeight);
				
				// If an image is loaded
				
				if (imageBitmapData != null) {	
					
					// If the image has not been rendered yet, create a scaled version of the image that will fit within the component
					
					if (newImageLoaded) createScaledImage();
									
					if (newCroppingRect) initializeCroppingRect();
					
					// Clear the current content
					
					componentBitmapData.fillRect(componentBitmapData.rect, bkgndColor);
					
					// Draw the scaled image in the component's display
					
					componentBitmapData.copyPixels(scaledImageBitmapData, scaledImageBitmapData.rect, imageLocation, null, null, true);
					
					// Draw the cropping overlay if the component is enabled
					
					if (componentEnabled && croppingRectBitmapData != null) componentBitmapData.copyPixels(croppingRectBitmapData, croppingRectBitmapData.rect, imageLocation, null, null, true);
				}
			}			
		}

		// --------------------------------------------------------------------------------------------------
		// initializeDisplay - Create the bitmap that represents the component's display
		// --------------------------------------------------------------------------------------------------
		
		private function initializeDisplay(newWidth:int, newHeight:int):void {
			
			if (newWidth > 0 && newHeight > 0) {
			
				// If a bitmap already exists (i.e., if the display area has been resized), remove the previous bitmap
	
				if (componentBitmap != null) {
					removeChild(componentBitmap);
					componentBitmapData.dispose();
				}
				
				// Create a Bitmap with smoothing enabled that matches the component's size and add it to the display list
				
				componentBitmapData = new BitmapData(newWidth, newHeight, true, bkgndColor);
				componentBitmap = new Bitmap(componentBitmapData);
				addChild(componentBitmap);
				
				// Save the current size of the component
				
				componentWidth = newWidth;
				componentHeight = newHeight;	
			}
		}		
					
		// --------------------------------------------------------------------------------------------------
		// initializeCroppingRect
		// --------------------------------------------------------------------------------------------------
		
		private function initializeCroppingRect():void {
			
			// The cropping rectangle cannot be initialized unless the imageCropper component is enabled and createScaledImage() has been called
			
			if (componentEnabled && scaledImageBitmapData != null) {
				
				// Determine if cropping rectangle is to be centered
				
				var centerCropRect:Boolean = (cropX == -1) || (cropY == -1);
			
				// Clear the initialization flag that was set when newCroppingRect() was called
				
				newCroppingRect = false;
				
				// If a cropping rectangle was previously defined, dispose of the BitmapData
				
				if (croppingRectBitmapData != null) croppingRectBitmapData.dispose();
				
				// Create the BitmapData for the cropping rectangle (the display area should match the image's display area)
				
				croppingRectBitmapData = new BitmapData(scaledImageBitmapData.width, scaledImageBitmapData.height, true, 0xAA000000);
				
				// If the width or height is zero, then the cropping rectangle will be set to the size of the image
				
				if (cropWidth == 0 || cropHeight == 0) {
					
					// Set width and height to the size of the image
					
					cropWidth = scaledImageBitmapData.width - 1;
					cropHeight = scaledImageBitmapData.height - 1;					
			
					// Save original cropping rectangle to determine if it had to be repositioned or resized in order to be valid
				
					var origRect:Rectangle = new Rectangle(cropX, cropY, cropWidth, cropHeight);
					
					// If the crop ratio is active, calculate the ratio and save it as the original ratio (in case it has to be changed later in this function)
					
					if (cropRatioActive) {
						cropRatio = cropWidth / cropHeight;
						var origCropRatio:Number = cropRatio;
					}
				}
					
				// If croppingRectIsImageScale is true, then scale the cropping rectangle dimensions so that it is drawn at the same scale as the selected image
				
				else if (croppingRectIsImageScale) {
					
					// If the crop ratio is active, save it as the original ratio (in case it has to be changed later in this function)
					
					if (cropRatioActive) origCropRatio = cropRatio;
					
					// If a specific location is defined for the cropping rectangle, convert the X and Y coordinates

					if (cropX >= 0 && cropY >= 0) {
						cropX *= imageScaleFactor;
						cropY *= imageScaleFactor;
					}
					
					// Convert width and height of the cropping rectangle
					
					cropWidth *= imageScaleFactor;
					cropHeight *= imageScaleFactor;
					
					// Save original cropping rectangle to determine if it had to be repositioned or resized in order to be valid
				
					origRect = new Rectangle(cropX, cropY, cropWidth, cropHeight);					
					
					// Make sure that the dimensions are not smaller than the size of the cropping rectangle handles
					
					if (cropWidth < cropRectMinimumSize) {
						cropHeight = cropHeight * (cropRectMinimumSize / cropWidth)
						cropWidth = cropRectMinimumSize;
					}
					
					if (cropHeight < cropRectMinimumSize) {
						cropWidth = cropWidth * (cropRectMinimumSize / cropHeight)
						cropHeight = cropRectMinimumSize;
					}
				}
				
				// Esle save original cropping rectangle to determine if it had to be repositioned or resized in order to be valid
				
				else origRect = new Rectangle(cropX, cropY, cropWidth, cropHeight);					
				
				// If the cropping rectangle is positioned absolutely (i.e., cropX and cropY > -1)
				
				if (!centerCropRect) {
										
					// If the absolute positioning causes the cropping rectangle to extend beyond the image area, try to reposition the cropping rectangle so that it touches rather than exceeds the image boundry

					if (cropX + cropWidth + 1 > scaledImageBitmapData.width) cropX = scaledImageBitmapData.width - cropWidth - 1;
					if (cropY + cropHeight + 1 > scaledImageBitmapData.height) cropY = scaledImageBitmapData.height - cropHeight - 1;
					
					// If the top or left-edge of the cropping rectangle extends beyond the top or left edge of the image area then decrease the height or width so that it fits within the image area
					// If a dimension of the cropping rectangle cannot fit, then set that dimension equal to the width or height of the image.
					
					if (cropX < 0) {
						cropWidth += cropX;
						if (cropWidth <= 0) cropWidth = scaledImageBitmapData.width - 1;
						cropX = 0;
					}
					
					if (cropY < 0) {
						cropHeight += cropY;
						if (cropHeight <= 0) cropHeight = scaledImageBitmapData.height - 1;
						cropY = 0;
					}
				}
			
				// Make sure that neither dimension exceeds the image dimensions
				
				if (cropWidth + 1 > scaledImageBitmapData.width) {
					cropWidth = scaledImageBitmapData.width - 1;
					if (cropRatioActive) cropHeight = cropWidth / cropRatio;
				}
				
				if (cropHeight + 1 > scaledImageBitmapData.height) {
					cropHeight = scaledImageBitmapData.height - 1;
					if (cropRatioActive) cropWidth = cropHeight * cropRatio;
				}
				
				// If the cropping rectangle is not absolutely positioned, then center the cropping rectangle in the image area
				
				if (centerCropRect) {
					cropX = (scaledImageBitmapData.width - cropWidth) / 2;
					cropY = (scaledImageBitmapData.height - cropHeight) / 2;
				}
								
				// If the absolute positioning causes the cropping rectangle to extend beyond the image area, try to reposition the cropping rectangle so that it touches rather than exceeds the image boundry

				if (cropX + cropWidth + 1 > scaledImageBitmapData.width) cropX = scaledImageBitmapData.width - cropWidth - 1;
				if (cropY + cropHeight + 1 > scaledImageBitmapData.height) cropY = scaledImageBitmapData.height - cropHeight - 1;
				
				// If adjusting cropX and cropY results in zero or negative space, reset the cropping rectangle to the image area
				
				if (scaledImageBitmapData.width - 1 <= cropX || scaledImageBitmapData.height - 1 <= cropY) {
					cropX = 0;
					cropY = 0;
					cropWidth = scaledImageBitmapData.width - 1
					cropHeight = scaledImageBitmapData.height - 1;
				}
				
				// Create the initial cropping rectangle centered in the display area
				
				cropRect = new Rectangle(cropX, cropY, cropWidth, cropHeight); 
				
				// Draw the initial cropping rectangle
				
				drawCroppingRect();
				
				// Dispatch events if the position, size, and/or aspect ratio of the cropping rectangle was changed
				
				if (!centerCropRect && (cropX != origRect.x || cropY != origRect.y)) dispatchEvent(new Event(CROP_POSITION_CHANGED));
				if (cropWidth != origRect.width || cropHeight != origRect.height) dispatchEvent(new Event(CROP_DIMENSIONS_CHANGED));
				if (cropRatioActive && !isNaN() && cropRatio != origCropRatio) dispatchEvent(new Event(CROP_CONSTRAINT_CHANGED));
			}			
		}
		
		// --------------------------------------------------------------------------------------------------
		// createScaledImage - Create a scaled version of the source image that will fit in the component's display area
		// --------------------------------------------------------------------------------------------------
		
		private function createScaledImage():void {

			if (imageBitmapData != null) {
				
				var imageWidth:Number = imageBitmapData.width;
				var imageHeight:Number = imageBitmapData.height;

				// Clear the flag that indicates that the image has not been processed yet by the createScaledImage() method
				
				newImageLoaded = false;				
				
				// Initialize the scaling factor to 1 (unscaled)
				
				imageScaleFactor = 1;
			
				// If the image size is larger than the component size
				
				if (imageWidth > componentWidth || imageHeight > componentHeight) {
				
					// Determine the ratio of the size of the loaded image to the component's size
					
					var newXScale:Number = imageWidth == 0 ? 1 : componentWidth / imageWidth;
					var newYScale:Number = imageHeight == 0 ? 1 : componentHeight / imageHeight;
					
					// Calculate the scaling factor based on which dimension must be scaled in order for the image to fit within the component
					
					var x:Number = 0;
					var y:Number = 0;
					
					if (newXScale > newYScale) {
						x = Math.floor((componentWidth - imageWidth * newYScale));
						imageScaleFactor = newYScale;
					}
					else {
						y = Math.floor((componentHeight - imageHeight * newXScale));
						imageScaleFactor = newXScale;
					}
					
					// Create a matrix to perform the image scaling
					
					var scaleMatrix:Matrix = new Matrix();
					scaleMatrix.scale(imageScaleFactor, imageScaleFactor);
					
					// Calculate the scaled size of the image
					
					imageScaledWidth = Math.ceil(imageBitmapData.width * imageScaleFactor);
					imageScaledHeight = Math.ceil(imageBitmapData.height * imageScaleFactor);
					
					// Calculate the new coordinates for the image so that it is centered within the component
					
					imageLocation = new Point(x - ((unscaledWidth - imageScaledWidth) / 2), y - ((unscaledHeight - imageScaledHeight) / 2))			
					
					// If there is a scaled BitmapData object from a previous image, dispose of the data
					
					if (scaledImageBitmapData != null) scaledImageBitmapData.dispose();
					
					// Create a new BitmapData object to hold the scaled image
					
					scaledImageBitmapData = new BitmapData(imageScaledWidth, imageScaledHeight, true, bkgndColor);
					
					// Create the scaled image (use smoothing)
					
					scaledImageBitmapData.draw(imageBitmapData, scaleMatrix, null, null, null, true);
				}
				
				// Else the image size is equal to or smaller than the component size
				
				else {
					
					// The scaled size is the actual size of the image
					
					imageScaledWidth = imageWidth;
					imageScaledHeight = imageHeight;
					
					// Set the new coordinates for the image so that it is centered within the component
					
					imageLocation = new Point((componentWidth - imageWidth) / 2, (componentHeight - imageHeight) / 2);
					
					// The image is unscaled, so just clone the BitmapData
					
					scaledImageBitmapData = imageBitmapData.clone();					
				}
			}			
		}
	}
}