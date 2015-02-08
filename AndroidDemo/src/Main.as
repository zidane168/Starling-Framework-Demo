package
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author VịLH
	 */
	
	 [SWF(width="1024",height="650",frameRate="60",backgroundColor="#ffffff")]	
	public class Main extends Sprite 
	{
		private var mStarling:Starling;
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
			
			this.addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			
			
		}
		
		private function this_addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			mStarling = new Starling(Game, stage);
			mStarling.start();
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}