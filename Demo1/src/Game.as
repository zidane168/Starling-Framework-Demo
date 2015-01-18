package
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author VịLH
	 */
	public class Game extends Sprite
	{
		
		public function Game()
		{
			var szMassage:String = "Welcome to Starling -> Thanks for watching, Zidane";
			var textField:TextField = new TextField(400, 300, szMassage);
			addChild(textField);
		}
	}
}