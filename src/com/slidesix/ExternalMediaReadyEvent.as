package com.slidesix 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class ExternalMediaReadyEvent extends Event 
	{
		
		public function ExternalMediaReadyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 

		// Define static constant.
        public static const MEDIA_READY:String = "mediaReady";


		public override function clone():Event 
		{ 
			return new ExternalMediaReadyEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ExternalMediaReadyEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}