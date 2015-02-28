package 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;	
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author VịLH
	 */
	public class Assets 
	{		
		[Embed(source = "../media/graphics/bgWelcome.jpg")]
		public static const BgWelcome:Class;
		
		[Embed(source = "../media/graphics/bgLayer1.jpg")]
		public static const BgLayer:Class;
		
		
		private static var gameTexture:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source = "../media/graphics/mySpriteSheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source = "../media/graphics/mySpriteSheet.xml", mimeType = "application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		// fonts
		[Embed(source = "../media/fonts/myFont.png")]
		public static const FontTexture:Class;
		
		[Embed(source = "../media/fonts/myFont.fnt", mimeType = "application/octet-stream")]
		public static const FontXML:Class;
		
		public static var myFont:BitmapFont;
		
		public static function getFont():BitmapFont
		{
			var fontTexture:Texture = Texture.fromBitmap(new FontTexture());
			var fontXML:XML = XML(new FontXML());
			
			var font:BitmapFont = new BitmapFont(fontTexture, fontXML);
			
			TextField.registerBitmapFont(font);	// dont forget this step;
			return font;
		}
		
		
		public static function getAtlas():TextureAtlas
		{
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			
			return gameTextureAtlas;
		}
		
		public static function getTexture(name:String):Texture
		{
			if (gameTexture[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTexture[name] =  Texture.fromBitmap(bitmap);
			}
			
			return gameTexture[name];
		}
	}
}