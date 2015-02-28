package objects 
{
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author VịLH
	 */
	public class Item extends Sprite
	{
		private var _foodItemType:int;
		private var itemImage:Image;
		
		public function Item(_foodItemType:int) 
		{
			super();
			this.foodItemType = _foodItemType;
		}
		
		public function get foodItemType():int 
		{
			return _foodItemType;
		}
		
		public function set foodItemType(value:int):void 
		{
			_foodItemType = value;
			
			
			if (itemImage == null)	// create item in the first time
			{
				itemImage = new Image(Assets.getAtlas().getTexture("item" + _foodItemType));	// item1, item2, ...
				itemImage.x = -itemImage.texture.width / 2;
				itemImage.y = -itemImage.texture.height / 2;	// bằng * 0.5 (đặt tại tâm hình item)
							
				this.addChild(itemImage);
			}
			else	// if the item is reused
			{
				itemImage = new Image(Assets.getAtlas().getTexture("item" + _foodItemType));	// item1, item2, ...
				itemImage.x = -itemImage.texture.width / 2;
				itemImage.y = -itemImage.texture.height / 2 ;
			}
		}
		
	}

}