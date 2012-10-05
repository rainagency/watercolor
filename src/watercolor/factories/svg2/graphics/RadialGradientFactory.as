package watercolor.factories.svg2.graphics
{
	import mx.graphics.RadialGradient;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics RadialGradient Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/RadialGradient.html
	 */ 
	public class RadialGradientFactory
	{
		public function RadialGradientFactory()
		{
		}
		
		/**
		 * Create mx.graphics RadialGradient from SVG RadialGradient element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:RadialGradient = null):RadialGradient
		{
			if (!element)
			{
				element = new RadialGradient();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromSVG(node, uriManager, element);
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG RadialGradient from Spark RadialGradient
		 */ 
		public static function createSVGFromSpark(element:RadialGradient):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}