package screens 
{
	import adobe.utils.CustomActions;
	import events.NavigationEvent;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author VịLH
	 */
	public class Welcome extends Sprite
	{		
		private var bg:Image;
		private var title:Image;
		private var hero:Image;
		
		private var playBtn:Button;
		private var aboutBtn:Button;
		
		private var heroY:int
		private var playBtnY:int;
		private var aboutBtnY:int;
		
		public function Welcome() 
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddToStage);
			
			heroY = 50;
			playBtnY = 210;
			aboutBtnY = 310;
		}
		
		private function onAddToStage(e:Event):void 
		{
			trace("welcome screen initalized!");
			
			drawScreen();
		}		
		
		private function drawScreen():void
		{
			bg = new Image(Assets.getTexture("BgWelcome"));
			this.addChild(bg);
						
			title = new Image(Assets.getAtlas().getTexture("logo"));
			title.x = 380;
			title.y = -80;
			this.addChild(title);
			
			hero = new Image(Assets.getAtlas().getTexture("heroIntroduce"));
			hero.x = -hero.width;
			hero.y = heroY;
			this.addChild(hero);
			
			
			playBtn = new Button(Assets.getAtlas().getTexture("play"));
			playBtn.x = 500;
			playBtn.y = playBtnY;
			this.addChild(playBtn);
			
			aboutBtn = new Button(Assets.getAtlas().getTexture("aboutNew"));
			aboutBtn.x = 410;
			aboutBtn.y = aboutBtnY;
			this.addChild(aboutBtn);
		
			// nhấn vào button
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		
		private function onMainMenuClick(e:Event):void 
		{
			var buttonClicked:Button = e.target as Button;
			if ((buttonClicked as Button) == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"play" }, true) );
			}
		}
		
		public function disposeTemporialy():void
		{
			this.visible = false;
			
			if (this.hasEventListener(Event.ENTER_FRAME)) 
				this.removeEventListener(Event.ENTER_FRAME, heroAnimation);	// remove hero, buttonplay, buttonabout -> bỏ chớp chớp			
		}
		
		public function initialize():void
		{
			this.visible = true;			
			trace ("initialized!");			
			hero.x = -hero.width;
			hero.y = 50;
			
			TweenLite.to(hero, 2, { x:80 } );		// hero bay vào	
			this.addEventListener(Event.ENTER_FRAME,  heroAnimation);
		}
		
		private function heroAnimation(e:Event):void 
		{
			var currentDate:Date = new Date();
			hero.y = 100 + (Math.cos(currentDate.getTime() * 0.002) * 25);	// chuyển động!
			playBtn.y = playBtnY + (Math.cos(currentDate.getTime() * 0.002) * 25);
			aboutBtn.y = aboutBtnY + (Math.cos(currentDate.getTime() * 0.002) * 25);
		}		
	}
}