package
{	
	import flash.display.Sprite;
	import starling.core.Starling;
	import flash.events.Event;	
	/**
	 * ...
	 * @author VịLH
	 */
	
	[SWF(width="400",height="300",frameRate="60",backgroundColor="#ffffff")]	
	public class Main extends Sprite
	{
		private var _starling:Starling;
		
		public function Main()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_starling = new Starling(Game, stage);
			_starling.start();
		}
	}
}

//  ------- chay tốt ------
// trace("Hàm này vẽ một hình bất kỳ");
//public function Main() 
//{	
//trace ("Hàm này vẽ một hình bất kỳ");
//_starling = new Starling(Game, stage);
//_starling.start();
//}