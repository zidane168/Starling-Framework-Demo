package screens
{
	
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import starling.extensions.PDParticleSystem;
	
	import objects.Item;
	import objects.GameBackground;
	import objects.Hero;
	import objects.Obstacle;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.text.TextField;
	import starling.utils.deg2rad;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import starling.textures.Texture;
	import starling.core.Starling;
	
	
	import events.NavigationEvent; // chuyển screen;
	/**
	 * ...
	 * @author VịLH
	 */
	public class InGame extends Sprite
	{
		
		private var startButton:Button;
		private var playAgainButton:Button;
		private var scoreText:TextField;
		private var pointText:TextField;
		private var lifeText:TextField;
		
		private var hero:Hero;
		private var bg:GameBackground;
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		private const MIN_SPEED:Number = 650; // tốc độ tổi thiểu khi bay: số càng lớn bay càng nhanh và ngược lại
		
		private var score:int;
		private var point:int;
		private var life:int;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		private var obstaclesToAnimate:Vector.<Obstacle>;		
		private var itemToAnimate:Vector.<Item>;
		private var eatParticlesToAnimate:Vector.<Particle>;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var particle:PDParticleSystem;
				
		public function InGame()
		{
			super();			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			trace ("Add_TO_STAGE - InGame.as");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();				// thiết lập các đối tượng trên màn hình (hero)
			initStartButton();		// init Start Button()
			displayScoreGame();		// display Score Game(point, life, score)
		}
		
		public function drawGame():void
		{			
			bg = new GameBackground();			
			this.addChild(bg);

			// custome particle
			particle = new PDParticleSystem(XML(new AssetsParticles.ParticlesXML()), Texture.fromBitmap(new AssetsParticles.ParticleTexture()));		
			Starling.juggler.add(particle);
			particle.x = -100;
			particle.y = -100;
			particle.scaleX = 1.2;
			particle.scaleY = 1.2;
			this.addChild(particle);			
			
			hero = new Hero();
			hero.x = stage.stageWidth / 2;
			hero.y = stage.stageHeight / 2;
			
			this.addChild(hero);
			
			
			
			gameArea = new Rectangle(0, 100, stage.stageWidth, stage.stageHeight - 250);		
		}
		
		public function gameOver():void
		{			
			this.visible = false;	// ẩn screen hiện tại
			
			
			this.removeEventListener(Event.ENTER_FRAME, onGameTick );	// remove hero, buttonplay, buttonabout -> bỏ chớp chớp
			this.removeEventListener(Event.ENTER_FRAME, this_enterFrame);
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			particle.stop();
			this.removeChild(hero);
			this.removeChild(pointText);
			this.removeChild(scoreText);
			this.removeChild(lifeText);
			//for (var i:uint = 0; i < obstaclesToAnimate.length; i++)
			//{
				//obstaclesToAnimate.splice(0, i);
				//obstaclesToAnimate = null;
			//}
				//
			//for (var i:uint = 0; i < itemToAnimate.length; i++)
			//{
				//itemToAnimate.splice(0, i);
				//itemToAnimate  = null;				
			//}
				//
			//for (var i:uint = 0; i < eatParticlesToAnimate.length; i++)
			//{
				//eatParticlesToAnimate.splice(0, i);
				//eatParticlesToAnimate = null;
			//}
			
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id:"gameOver" }, true) );		
		}
	
		
		// nhấn vào button
		// nhấn vào nút start
		private function onStartButtonClicked(e:Event):void
		{
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonClicked);
			startButton.visible = false;
			
			lauchHero();
		}
			
		public function disposeTemporaily():void
		{
			trace ("disposeTemporaily -  InGame.as");
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
			score = 0;
			obstacleGapCount = 0;
			
			playerSpeed = 0;
			hitObstacle = 0;
			
			obstaclesToAnimate = new Vector.<Obstacle>();
			itemToAnimate = new Vector.<Item>();
			eatParticlesToAnimate = new Vector.<Particle>();
			
			// khi người chơi nhấn Start, hero mới bay ra
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClicked);
		}
		
		public function lauchHero():void
		{
			// kích hoạt particle -> phải có mới active hiệu ứng
			particle.start();
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			touch = e.getTouch(stage);
			
			touchX = touch.globalX;
			touchY = touch.globalY;
		}
		
		private function onGameTick(e:Event):void
		{
			particle.x = hero.x + 60;			
			particle.y = hero.y;
			
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
					
					// check collision
					if (hitObstacle <= 0)
					{
						hero.y -= (hero.y - touchY) * 0.1; // nhân vật bay theo vị trí chuột
						
						if (-(hero.y - touchY) < 150 && -(hero.y - touchY) > -150)
							hero.rotation = deg2rad(-(hero.y - touchY) * 0.2); // xoay nhân vật theo con chuột khi di chuyển chuột (nhân 0.2 để nó hơi nhích lên xíu thôi)
						
						if (hero.y < gameArea.top + hero.height * 0.5) // chặn trên
						{
							hero.y = gameArea.top + hero.height * 0.5;
							hero.rotation = deg2rad(0); // quay ngang 
						}
						
						if (hero.y > gameArea.bottom - hero.height * 0.5) // chặn dưới
						{
							hero.y = gameArea.bottom - hero.height * 0.5;
							hero.rotation = deg2rad(0);
						}
					}
					else // hero va chạm vào vật thể lạ
					{
						hitObstacle--;
						cameraShake();
						// hero.rotation = deg2rad(60);
					}
					
					playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
					bg.speed = playerSpeed * elapsed;
					
					score += (playerSpeed * elapsed) * 0.1;
					scoreText.text = "Score: " + score;
										
					intObstacle();
					animateObstacles();
					
					createFoodItems();
					animateItems();
					animateEatParticles();
					
					break;
				
				case "over": 	// ra khỏi màn hình
					break;
					
				case "gameOver":
					gameOver();
					break;
			}
		}
		
		private function animateEatParticles():void 
		{
			for (var i:uint = 0; i < eatParticlesToAnimate.length; i++)
			{
				var eatParticleToTrack:Particle = eatParticlesToAnimate[i];
				
				if (eatParticleToTrack)
				{
					eatParticleToTrack.scaleX -= 0.03;
					eatParticleToTrack.scaleY = eatParticleToTrack.scaleX;
					
					eatParticleToTrack.y -= eatParticleToTrack.speedY;
					eatParticleToTrack.speedY -= eatParticleToTrack.speedY * 0.2;
					
					eatParticleToTrack.x += eatParticleToTrack.speedX;
					eatParticleToTrack.speedX --;
					
					eatParticleToTrack.rotation += deg2rad(eatParticleToTrack.spin);
					eatParticleToTrack.spin *= 1.1;
					
					if (eatParticleToTrack.scaleY <= 0.02)
					{
						eatParticlesToAnimate.splice(i, 1);
						this.removeChild(eatParticleToTrack);
						eatParticleToTrack = null;						
					}
				}				
			}
		}
		
		// hero tương tác với items hay item bay ra khỏi màn hình
		private function animateItems():void
		{
			var itemToTrack:Item;
			for (var i:uint = 0; i < itemToAnimate.length; i++)
			{
				itemToTrack = itemToAnimate[i];
				itemToTrack.x -= playerSpeed * elapsed;
				
				// hero tương tac với item -> item sẽ biến mất
				if (itemToTrack.bounds.intersects(hero.bounds))
				{
					// an item ra khoi
					createEatParticles(itemToTrack);
					
					// remove item khi va cham vào hero
					itemToAnimate.splice(i, 1);
					this.removeChild(itemToTrack);
					
					// thêm 1 điểm khi va chạm với item
					point++;
					pointText.text = "Point: " + point;
				}
				
				// item đi ra khỏi màn hình bên trái -> remove item
				if (itemToTrack.x < -50)
				{
					itemToAnimate.splice(i, 1);
					this.removeChild(itemToTrack);
				}
			}		
		}
		
		private function createEatParticles(itemToTrack:Item):void
		{
			var count:int = 5;
			
			while (count > 0)
			{
				count--;
				
				var eatPracticle:Particle = new Particle();
				this.addChild(eatPracticle);
				eatPracticle.x = itemToTrack.x + Math.random() * 40 - 20;
				eatPracticle.y = itemToTrack.y - Math.random() * 40;
				
				eatPracticle.speedX = Math.random() * 2 + 1;
				eatPracticle.speedY = Math.random() * 5;
				eatPracticle.spin = Math.random() * 15;
				
				eatPracticle.scaleX = eatPracticle.scaleY = Math.random() * 0.3 + 0.3;
				
				eatParticlesToAnimate.push(eatPracticle);
			}
		}
		
		private function createFoodItems():void
		{
			if (Math.random() > 0.95)
			{
				var itemToTrack:Item = new Item(Math.ceil(Math.random() * 5)); // 5 loại item
				itemToTrack.x = stage.stageWidth + 50;
				itemToTrack.y = int(Math.random() * (gameArea.bottom - gameArea.top)) + gameArea.top; // random trong khoảng gameArea, ko thoát ra khoảng này
				this.addChild(itemToTrack);
				
				itemToAnimate.push(itemToTrack);
			}
		}
		
		private function cameraShake():void
		{
			if (hitObstacle > 0)
			{
				this.x = Math.random() * hitObstacle; // va chạm gây tiếng động -> rung màn hình
				this.y = Math.random() * hitObstacle;
			}
			else if (x != 0)
			{
				this.x = 0;
				this.y = 0;
			}
		}
		
		private function animateObstacles():void
		{
			var obstacleToTrack:Obstacle;
			for (var i:uint = 0; i < obstaclesToAnimate.length; i++)
			{
				obstacleToTrack = obstaclesToAnimate[i];
				
				if (life == 0)
					gameState = "gameOver";
			
				// check collision
				if (obstacleToTrack.alreadyHit == false && obstacleToTrack.bounds.intersects(hero.bounds))
				{
					obstacleToTrack.alreadyHit = true;
					obstacleToTrack.rotation = deg2rad(70);
					hitObstacle = 30; 		// độ rung màn hình
					playerSpeed *= 0.5; 	// tốc độ hero khi va chạm
					
					life--;
					lifeText.text = "Life: " + life;
				}
				
				if (obstacleToTrack.distance > 0)
					obstacleToTrack.distance -= playerSpeed * elapsed;
				else
				{
					if (obstacleToTrack.watchOut)
						obstacleToTrack.watchOut = false;
					
					obstacleToTrack.x -= (playerSpeed + obstacleToTrack.speed) * elapsed;
				}
				
				// ra khỏi màn hình
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
				obstacle.y = int(Math.random() * (gameArea.bottom - obstacle.height - gameArea.top)) + gameArea.top;
				obstacle.position = "middle";
			}
			
			obstaclesToAnimate.push(obstacle);
		
		}
		
		// công thức di chuyển cho animations
		private function this_enterFrame(e:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
		
		private function initStartButton():void 
		{
			startButton = new Button(Assets.getAtlas().getTexture("start"));
			startButton.x = stage.stageWidth * 0.5 - startButton.width * 0.5
			startButton.y = stage.stageHeight * 0.5 - startButton.height * 0.5;
			this.addChild(startButton);
		}
		
		public function displayScoreGame():void 
		{
			scoreText = new TextField(300, 100, "Score: 0", Assets.getFont().name, 22, 0xffffff);
			this.addChild(scoreText);
			
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = 20;
			scoreText.y = 20;
			// scoreText.border = true;
			// scoreText.height = scoreText.textBounds.height + 10; // vẽ khung bao quanh
			
			lifeText = new TextField(300, 50, "Life: 1", Assets.getFont().name, 22, 0xffffff);
			this.addChild(lifeText);
			lifeText.hAlign = HAlign.LEFT;
			lifeText.vAlign = VAlign.TOP;
			lifeText.x = 300;
			lifeText.y = 20;			
			
			pointText = new TextField(300, 50, "Point: 0", Assets.getFont().name, 22, 0xffffff);
			this.addChild(pointText);
			pointText.hAlign  = HAlign.LEFT;
			pointText.vAlign = VAlign.TOP;
			pointText.x = 500;
			pointText.y = 20;			
			
			// init point, life
			point = 0;
			life = 1;
		}
	
	}

}