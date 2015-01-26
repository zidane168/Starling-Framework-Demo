package events 
{
	import starling.events.Event;
	import objects.Hero;
	/**
	 * ...
	 * @author VịLH
	 */
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		public var params:Object;
		
		public function NavigationEvent(type:String, _param:Object = null, bubbles:Boolean=false) 
		{
			super(type, bubbles);	
			this.params = _param;
		}		
	}
}