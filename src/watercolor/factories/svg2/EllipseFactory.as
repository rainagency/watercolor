package watercolor.factories.svg2
{
	import watercolor.elements.Ellipse;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark Ellipse Factory
	 * 
	 * SVG Documentation: 
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
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Ellipse = null):Ellipse
		{
			if (!element)
			{
				element = new Ellipse();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromSVG(node, uriManager, element);	
			
			// set any attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG Ellipse from Spark Ellipse
		 */ 
		public static function createSVGFromSpark(element:Ellipse, workarea:Workarea):XML
		{
			var ellipse:XML = new XML("<ellipse/>");
			
			SVGAttributes.parseMXMLAttributes(element, ellipse);
			
			return ellipse;
		}
	}
}