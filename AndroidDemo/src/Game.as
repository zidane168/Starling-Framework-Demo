package 
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	/**
	 * ...
	 * @author VịLH
	 */
	public class Game extends Sprite
	{
		
		public function Game() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			
			var textField:TextField;
			textField = new TextField(200, 200, "Welcome to my site");
			this.addChild(textField);
		}
		
	}

}