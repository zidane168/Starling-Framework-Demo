package
{
	import events.NavigationEvent;
	import screens.GameOver;
	import screens.InGame;
	import screens.Welcome;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author VịLH
	 */
	public class Game extends Sprite
	{
		private var _screenWelcome:Welcome;
		private var _screenInGame:InGame;
		private var _screenGameOver:GameOver;
		
		public function Game()
		{
			super();
			
			// phải xài addtostage nhé, ko có bị lỗi khó hiểu
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			trace("Starling framework initalized!");
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, this_changeScreen);
			
			// In Game screen
			_screenInGame = new InGame();
			_screenInGame.disposeTemporaily();	// ẩn nó đi, addChild, hàm trong InGame
			this.addChild(_screenInGame);		// addChild
			
			
			
			// welcome screen
			_screenWelcome = new Welcome();
			addChild(_screenWelcome);			
			_screenWelcome.initialize();	// open lên, load button, hero, title, animation welcome screen		
		}
		
		private function this_changeScreen(e:NavigationEvent):void 
		{
			switch(e.params.id)
			{
				case "play":
					trace ("play - Game.as");	
					_screenWelcome.disposeTemporialy();					
					_screenInGame.initialize();
					
					break;
				
				case "gameOver":
					trace ("gameOver - Game.as");
					_screenInGame.disposeTemporaily();
					// Game Over screen
					_screenGameOver = new GameOver();
					this.addChild(_screenGameOver);			
					
					break;				
				
				case "playAgain":
					trace ("playAgain - Game.as");
					_screenGameOver.disposeTemporaily();	// ẩn screen GameOver
					
					_screenInGame.drawGame();	
					_screenInGame.displayScoreGame();
					_screenInGame.initialize();
					_screenInGame.lauchHero();
					
					break;
			}
		}
	}

}