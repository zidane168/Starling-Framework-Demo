package objects
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author VịLH
	 */
	public class GameBackground extends Sprite
	{
		private var _bgLayer1:BgLayer;
		private var _bgLayer2:BgLayer;
		private var _bgLayer3:BgLayer;
		private var _bgLayer4:BgLayer;
		
		private var _speed:Number = 0;
		
		public function GameBackground()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			
			_bgLayer1 = new BgLayer(1);
			_bgLayer1.parallax = 0.02;
			this.addChild(_bgLayer1);
			
			_bgLayer2 = new BgLayer(2);
			_bgLayer2.parallax = 0.2;
			this.addChild(_bgLayer2);
			
			_bgLayer3 = new BgLayer(3);
			_bgLayer3.parallax = 0.5;
			this.addChild(_bgLayer3);
			
			_bgLayer4 = new BgLayer(4);
			_bgLayer4.parallax = 1;
			this.addChild(_bgLayer4);
			
			this.addEventListener(Event.ENTER_FRAME, this_enterFrame);
		}
		
		private function this_enterFrame(e:Event):void
		{
			_bgLayer1.x -= Math.ceil(_speed * _bgLayer1.parallax);	// hình chạy từ phải sang trái (mine)
			if (_bgLayer1.x < -stage.stageWidth)
				_bgLayer1.x = 0;
			
			_bgLayer2.x -= Math.ceil(_speed * _bgLayer2.parallax);
			if (_bgLayer2.x < -stage.stageWidth)
				_bgLayer2.x = 0;
			
			_bgLayer3.x -= Math.ceil(_speed * _bgLayer3.parallax);
			if (_bgLayer3.x < -stage.stageWidth)
				_bgLayer3.x = 0;
			
			_bgLayer4.x -= Math.ceil(_speed * _bgLayer4.parallax);
			if (_bgLayer4.x < -stage.stageWidth)
				_bgLayer4.x = 0;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}
	
	}

}