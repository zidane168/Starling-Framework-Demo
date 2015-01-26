package
{
	import screens.InGame;
	import screens.Welcome;
	import starling.core.Starling;
	import flash.events.Event;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author VịLH
	 */
	
	 	
	[SWF(width="1024",height="650",frameRate="60",backgroundColor="#ffffff")]	
    public class Main extends Sprite
	{		
		private var _starling:Starling;
				
		public function Main()
		{
			super();		
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void 
		{
			_starling = new Starling(Game, stage);
			_starling.antiAliasing = 1;
			_starling.start();
		}			
	}
}

