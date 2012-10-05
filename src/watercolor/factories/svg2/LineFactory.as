package watercolor.factories.svg2
{
	import spark.primitives.Line;
	
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark Line Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/spark/primitives/Line.html
	 */ 
	public class LineFactory
	{
		public function LineFactory()
		{
		}
		
		/**
		 * Create Spark Line from SVG Line element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Line = null):Line
		{
			if (!element)
			{
				element = new Line();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromSVG(node, uriManager, element);	
			
			// set any attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG Line from Spark Line
		 */ 
		public static function createSVGFromSpark(element:Line, workarea:Workarea):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}