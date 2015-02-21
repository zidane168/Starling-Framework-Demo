package objects
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author VịLH
	 */
	public class Hero extends Sprite
	{
		private var heroArt:MovieClip;
		
		public function Hero()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createHeroArt();		
		}
		
		private function createHeroArt():void
		{
			heroArt = new MovieClip(Assets.getAtlas().getTextures("fly_"), 20);
			heroArt.x = Math.ceil( -heroArt.width / 2) - 100;
			heroArt.y = Math.ceil( -heroArt.height / 2);
			
			//scoreText.height = scoreText.textBounds.height + 10;	// vẽ khung bao quanh
			
			Starling.juggler.add(heroArt);
			
			this.addChild(heroArt);
		}
	
	}

}