package com.slidesix.vo.events
{
	import flash.events.EventDispatcher;
	
	[RemoteClass(alias="com.slidesix.vo.events.EventMembership")]
	[Entity]
	public class EventMembership extends EventDispatcher 
	{
		[Bindable]
		public var USERNAME:String;
		[Bindable]
		public var FIRSTNAME:String;
		[Bindable]
		public var LASTNAME:String;
		[Bindable]
		public var JOINEDON:Date;
		[Bindable]
		public var ISAPPROVED:Boolean;
		[Bindable]
		public var ISOWNER:Boolean;
		[Bindable]
		public var EVENTMEMBERSHIPID:int;
		[Bindable]
		public var EVENTID:int;
		[Bindable]
		public var USERID:int;
		public function EventMembership()
		{
		}
	}
}