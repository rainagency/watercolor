package watercolor.factories.svg
{
	import spark.primitives.Line;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Spark Line Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/shapes.html#LineElement
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
			
			// Decorate through parent factories
			StrokedElementFactory.createSparkFromSVG(node, uriManager, element);
			
			// x1 = x from
			if(node.@x1.length() > 0)
			{
				element.xFrom = SVGAttributes.parseLength(node.@x1);
			}
			
			// y1 = y from
			if(node.@y1.length() > 0)
			{
				element.yFrom = SVGAttributes.parseLength(node.@y1);
			}
			
			// x2 = x to
			if(node.@x2.length() > 0)
			{
				element.xTo = SVGAttributes.parseLength(node.@x2);
			}
			
			// y2 = y to
			if(node.@y2.length() > 0)
			{
				element.yTo = SVGAttributes.parseLength(node.@y2);
			}
			
			return element;
		}
		
		/**
		 * Create SVG Line from Spark Line
		 */ 
		public static function createSVGFromSpark(element:Line):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}