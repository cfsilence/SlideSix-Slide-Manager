package com.slidesix 
{
	import flash.events.Event;
	
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class ExternalMediaPlayerCreatedEvent extends Event 
	{
		
		public function ExternalMediaPlayerCreatedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 

		// Define static constant.
        public static const PLAYER_CREATED:String = "playerCreated";


		public override function clone():Event 
		{ 
			return new ExternalMediaPlayerCreatedEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ExternalMediaPlayerCreatedEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}