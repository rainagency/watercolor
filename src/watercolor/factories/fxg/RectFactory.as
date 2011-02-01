package watercolor.factories.fxg
{
	import watercolor.elements.Rect;
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Rect Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/Rect.html
	 */ 
	public class RectFactory
	{
		public function RectFactory()
		{
		}
		
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:Rect = null):Rect
		{
			if (!element)
			{
				element = new Rect();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromFXG(node, uriManager, element);	
			
			// set any attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		public static function createFXGFromSpark(element:Rect):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}