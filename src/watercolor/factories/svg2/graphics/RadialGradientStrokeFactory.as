package watercolor.factories.svg2.graphics
{
	import mx.graphics.RadialGradientStroke;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics RadialGradientStroke Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/RadialGradientStroke.html
	 */ 
	public class RadialGradientStrokeFactory
	{
		public function RadialGradientStrokeFactory()
		{
		}
		
		/**
		 * Create mx.graphics RadialGradientStroke from SVG RadialGradientStroke element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:RadialGradientStroke = null):RadialGradientStroke
		{
			if (!element)
			{
				element = new RadialGradientStroke();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromSVG(node, uriManager, element);
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG RadialGradientStroke from Spark RadialGradientStroke
		 */ 
		public static function createSVGFromSpark(element:RadialGradientStroke):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}