package watercolor.factories.fxg
{
	import spark.primitives.Line;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Line Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/spark/primitives/Line.html
	 */ 
	public class LineFactory
	{
		public function LineFactory()
		{
		}
		
		/**
		 * Create Spark Line from FXG Line element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:Line = null):Line
		{
			if (!element)
			{
				element = new Line();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromFXG(node, uriManager, element);	
			
			// set any attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG Line from Spark Line
		 */ 
		public static function createFXGFromSpark(element:Line):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}