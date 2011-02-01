package watercolor.factories.fxg
{
	import watercolor.elements.Ellipse;
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Ellipse Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/Ellipse.html
	 */ 
	public class EllipseFactory
	{
		public function EllipseFactory()
		{
		}
		
		/**
		 * Create Spark Ellipse from Ellipse fxg element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:Ellipse = null):Ellipse
		{
			if (!element)
			{
				element = new Ellipse();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromFXG(node, uriManager, element);	
			
			// set any attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG Ellipse from Spark Ellipse
		 */ 
		public static function createFXGFromSpark(element:Ellipse):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}