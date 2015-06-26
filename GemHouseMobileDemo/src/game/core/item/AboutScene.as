package game.core.item 
{
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author zidane
	 */
	public class AboutScene extends Sprite
	{
		
		public function AboutScene() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , added);		
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , added );
			
			var containers:Sprite = new Sprite();
			addChild(containers);
			
			var txtAuthor:TextField;
			txtAuthor = new TextField( stage.stageWidth, stage.stageHeight / 2, "huuvi168@gmail.com", "huuvi168@gmail.com", 64, 0xffffff);
			txtAuthor.vAlign = VAlign.CENTER;
			txtAuthor.hAlign = HAlign.CENTER ;
			txtAuthor.touchable = false ;
			txtAuthor.x = stage.stageWidth-txtAuthor.width-10;
			txtAuthor.y = 10;
			containers.addChild(txtAuthor);
			
			
			var btnBack:Button;
			btnAbout = new Button( Assets.instance.getUITexture("BtnAbout") );
			btnAbout.pivotX = btnAbout.width>>1;
			btnAbout.pivotY = btnAbout.height>>1;
			btnAbout.scaleX = btnAbout.scaleY = 0;
			btnAbout.x = stage.stageWidth>>1;
			btnAbout.y = 740 ;
			
		}		
	}

}