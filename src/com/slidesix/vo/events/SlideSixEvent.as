package com.slidesix.vo.events
{
	import flash.events.EventDispatcher;
	
	[RemoteClass(alias="com.slidesix.vo.events.Event")]
	[Entity]
	public class SlideSixEvent extends EventDispatcher 
	{
		[Bindable]
		[Id]
		public var ID:int;
		[Bindable]
		public var CONTACTURL:String;
		[Bindable]
		public var VENUE:String;
		[Bindable]
		public var STARTDATE:Date;
		[Bindable]
		public var ENDDATE:Date;
		[Bindable]
		public var COSTINFO:String;
		[Bindable]
		public var TRACKS:String;
		[Bindable]
		public var ORGANIZERINFO:String;
		[Bindable]
		public var SCHEDULEURL:String;
		[Bindable]
		public var RSSURL:String;
		[Bindable]
		public var EXTERNALHOMEPAGEURL:String;
		[Bindable]
		public var PATHTOBANNERIMAGE:String;
		[Bindable]
		public var PATHTOIMAGETHUMB:String;
		[Bindable]
		public var PATHTOIMAGE:String;
		[Bindable]
		public var NAME:String;
		[Bindable]
		public var JOINEDON:Date;
		[Bindable]
		public var DESCRIPTIONFULL:String;
		[Bindable]
		public var DESCRIPTIONSHORT:String;
		[Bindable]
		public var CREATEDON:Date;
		[Bindable]
		public var PENDINGMEMBERS:int;
		[Bindable]
		public var ISOWNER:Boolean;
		[Bindable]
		public var AUTOACCEPTMEMBERS:Boolean;
		[Bindable]
		public var ISAPPROVED:Boolean;
		[Bindable]
		public var ALIAS:String;
		[Bindable]
		public var ISFEATURED:Boolean;
		
		public function SlideSixEvent()
		{
		}
	}
}