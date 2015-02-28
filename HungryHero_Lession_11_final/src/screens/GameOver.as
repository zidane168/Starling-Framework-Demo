package screens 
{
	import events.NavigationEvent;
	import objects.GameBackground;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author ViLH
	 */
	public class GameOver extends Sprite
	{
		private var bg:GameBackground;
		private var playAgainButton:Button;
		
		public function GameOver() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStaged);			
		}
		
		// show background + button 
		private function addedToStaged(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStaged);
			
			bg = new GameBackground();			
			this.addChild(bg);
			
			playAgainButton = new Button(Assets.getAtlas().getTexture("playAgain"));	// xem trong mySpriteSheet.xml
			playAgainButton.x = stage.stageWidth * 0.5 - playAgainButton.width * 0.5
			playAgainButton.y = stage.stageHeight * 0.5 - playAgainButton.height * 0.5;
			this.addChild(playAgainButton);
			
			playAgainButton.addEventListener(Event.TRIGGERED, onPlayAgainButtonClicked);
		}
		
		// khi clicked vào button playAgain
		private function onPlayAgainButtonClicked(e:Event):void 
		{
			this.removeEventListener(Event.TRIGGERED, onPlayAgainButtonClicked);			
						
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"playAgain" }, true) );		
		}
		
		public function disposeTemporaily():void
		{
			this.visible = false;
		}
		
	}

}