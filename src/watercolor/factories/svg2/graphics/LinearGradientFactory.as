package watercolor.factories.svg2.graphics
{
	import mx.graphics.LinearGradient;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics LinearGradient Factory
	 * 
	 * SVG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/LinearGradient.html
	 */ 
	public class LinearGradientFactory
	{
		public function LinearGradientFactory()
		{
		}
		
		/**
		 * Create mx.graphics LinearGradient from SVG LinearGradient element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:LinearGradient = null):LinearGradient
		{
			if (!element)
			{
				element = new LinearGradient();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromSVG(node, uriManager, element);
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG LinearGradient from Spark LinearGradient
		 */ 
		public static function createSVGFromSpark(element:LinearGradient):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}