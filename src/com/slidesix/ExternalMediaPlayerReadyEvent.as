package com.slidesix 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class ExternalMediaPlayerReadyEvent extends Event 
	{
		
		public function ExternalMediaPlayerReadyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 

		// Define static constant.
        public static const PLAYER_READY:String = "playerReady";


		public override function clone():Event 
		{ 
			return new ExternalMediaPlayerReadyEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ExternalMediaPlayerReadyEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}