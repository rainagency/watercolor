package watercolor.factories.svg2.graphics
{
	import mx.graphics.LinearGradientStroke;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics LinearGradientStroke Factory
	 * 
	 * SVG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/LinearGradientStroke.html
	 */ 
	public class LinearGradientStrokeFactory
	{
		public function LinearGradientStrokeFactory()
		{
		}
		
		/**
		 * Create mx.graphics LinearGradientStroke from SVG LinearGradientStroke element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:LinearGradientStroke = null):LinearGradientStroke
		{
			if (!element)
			{
				element = new LinearGradientStroke();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromSVG(node, uriManager, element);
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG LinearGradientStroke from Spark LinearGradientStroke
		 */ 
		public static function createSVGFromSpark(element:LinearGradientStroke):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}