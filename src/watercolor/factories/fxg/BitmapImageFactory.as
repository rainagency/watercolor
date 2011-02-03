package watercolor.factories.fxg
{
	import watercolor.elements.BitmapImage;
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark BitmapImage Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/BitmapImage.html
	 */ 
	public class BitmapImageFactory
	{
		public function BitmapImageFactory()
		{
		}
		
		/**
		 * Create Spark BitmapImage from FXG Image
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:BitmapImage = null):BitmapImage
		{
			if (!element)
			{
				element = new BitmapImage();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromFXG(node, uriManager, element);	
			
			// set any attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		public static function createFXGFromSpark(element:BitmapImage):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}