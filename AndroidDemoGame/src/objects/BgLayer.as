package objects 
{
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author VịLH
	 */
	public class BgLayer extends Sprite
	{
		private var _image1:Image;
		private var _image2:Image;
		
		private var _layer:int;
		private var _parallax:Number;
		
		public function BgLayer(layer:int) 
		{
			super();
			this._layer = layer;
			this.addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function this_addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			
			trace (_layer);
			
			if (_layer == 1)
			{	
				//[Embed(source = "../media/graphics/bgLayer1.jpg")]
				//public static const BgLayer:Class;
				
				_image1 = new Image(Assets.getTexture("BgLayer"));	// lấy BgLayer from const	
				_image2 = new Image(Assets.getTexture("BgLayer"));
			}
			else
			{
				_image1 = new Image(Assets.getAtlas().getTexture("bgLayer" + _layer));				
				_image2 = new Image(Assets.getAtlas().getTexture("bgLayer" + _layer));
			}
			
			
			// tự xử lý
			_image1.x = 0;
			
			if (_layer == 4)
				_image1.y = stage.stageHeight - _image1.height + 100;
			else
				_image1.y = stage.stageHeight - _image1.height;
				
			// nối hai hình với nhau
			_image2.x = _image2.width;
			_image2.y = _image1.y;
			
			
			this.addChild(_image1);
			this.addChild(_image2);
			
		}
		
		public function get parallax():Number 
		{
			return _parallax;
		}
		
		public function set parallax(value:Number):void 
		{
			_parallax = value;
		}
		
	}

}