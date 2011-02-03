package watercolor.factories.fxg
{
	import mx.graphics.SolidColorStroke;
	
	import watercolor.elements.Path;
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Path Factory
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/Path.html
	 */ 
	public class PathFactory
	{
		public function PathFactory()
		{
		}
		
		/**
		 * Create Spark Path from FXG
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:Path = null):Path
		{
			if (!element)
			{
				element = new Path();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromFXG(node, uriManager, element);	
			
			// set any attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create Path FXG XML
		 */ 
		public static function createFXGFromSpark(element:Path):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}