package screens
{
	
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import objects.GameBackground;
	import objects.Hero;
	import objects.Obstacle;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author VịLH
	 */
	public class InGame extends Sprite
	{
		private var startButton:Button;
		
		private var hero:Hero;
		private var bg:GameBackground;
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		private const MIN_SPEED:Number = 650; // tốc độ tổi thiểu khi bay: số càng lớn bay càng nhanh và ngược lại
		
		private var scoreDistance:int;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		private var obstaclesToAnimate:Vector.<Obstacle>;
		
		public function InGame()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();
		}
		
		private function drawGame():void
		{
			
			bg = new GameBackground();
			// bg.speed = 10;
			this.addChild(bg);
			
			hero = new Hero();
			hero.x = stage.stageWidth / 2;
			hero.y = stage.stageHeight / 2;
			this.addChild(hero);
			
			startButton = new Button(Assets.getAtlas().getTexture("start"));
			startButton.x = stage.stageWidth * 0.5 - startButton.width * 0.5
			startButton.y = stage.stageHeight * 0.5 - startButton.height * 0.5;
			this.addChild(startButton);
			
			gameArea = new Rectangle(0, 100, stage.stageWidth, stage.stageHeight - 250);
		
		}
		
		public function disposeTemporaily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			this.addEventListener(Event.ENTER_FRAME, this_enterFrame);
			
			hero.x = -stage.stageWidth;
			hero.y = stage.stageHeight * 0.5;
			
			gameState = "idle";
			
			bg.speed = 0; // màn hình đứng yên khi hiện button Start, 
			scoreDistance = 0;
			obstacleGapCount = 0;
			
			playerSpeed = 0;
			hitObstacle = 0;
			
			obstaclesToAnimate = new Vector.<Obstacle>();
			
			// khi người chơi nhấn Start, hero mới bay ra
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClicked);
		}
		
		private function onStartButtonClicked(e:Event):void
		{
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonClicked);
			startButton.visible = false;
			
			laucherHero();
		}
		
		private function laucherHero():void
		{
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onGameTick(e:Event):void
		{
			switch (gameState)
			{
				case "idle": // trạng thái ban đầu, hero chưa vào màn hình screen
					// Take off
					if (hero.x < stage.stageWidth * 0.5 * 0.5)
					{
						hero.x += ((stage.stageWidth * 0.5 * 0.5 + 10) - hero.x) * 0.05;
						hero.y = stage.stageHeight * 0.5;
						
						playerSpeed += (MIN_SPEED - playerSpeed) * 0.05;
						bg.speed = playerSpeed * elapsed; // màn hình chạy cùng lúc với hero bay ra
					}
					else
					{
						gameState = "flying";
					}
					
					break;
				
				case "flying": 
					playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
					bg.speed = playerSpeed * elapsed;
					
					scoreDistance += (playerSpeed * elapsed) * 0.1;
					// trace (scoreDistance);
					
					intObstacle();
					animateObstacles();
					
					break;
				
				case "over": 
					break;
			}
		}
		
		private function animateObstacles():void 
		{
			var obstacleToTrack:Obstacle;
			for (var i:uint = 0; i < obstaclesToAnimate.length; i++)
			{
				obstacleToTrack = obstaclesToAnimate[i];
				
				if (obstacleToTrack.distance > 0)
					obstacleToTrack.distance -= playerSpeed * elapsed;					
				else
				{
					if (obstacleToTrack.watchOut)
						obstacleToTrack.watchOut = false;
					
					obstacleToTrack.x -= (playerSpeed + obstacleToTrack.speed) * elapsed;
				}
				
				if (obstacleToTrack.x < -obstacleToTrack.width || gameState == "over")
				{
					obstaclesToAnimate.splice(i, 1);
					this.removeChild(obstacleToTrack);
				}
			}
			
		}
		
		private function intObstacle():void
		{
			if (obstacleGapCount < 1200)
			{
				obstacleGapCount += playerSpeed * elapsed;
			}
			else if (obstacleGapCount != 0)
			{
				obstacleGapCount = 0;
				createObstacle(Math.ceil(Math.random() * 4), Math.random() * 1000 + 1000);
			}
		}
		
		private function createObstacle(type:Number, distance:Number):void
		{
			var obstacle:Obstacle = new Obstacle(type, distance, true, 300);
			obstacle.x = stage.stageWidth;
			this.addChild(obstacle);
			
			if (type <= 3)
			{
				if (Math.random() > 0.5)
				{
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}
				else
				{
					obstacle.y = gameArea.bottom - obstacle.height;
					obstacle.position = "bottom";
					
				}
			}
			else
			{
				obstacle.y = int(Math.random() *  (gameArea.bottom - obstacle.height - gameArea.top)) + gameArea.top;
				obstacle.position = "middle";
			}
			
			obstaclesToAnimate.push(obstacle);
			
		}
		
		private function this_enterFrame(e:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
	
	}

}