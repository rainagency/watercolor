package watercolor.factories.svg2.graphics
{
	import mx.graphics.SolidColorStroke;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics SolidColorStroke Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/SolidColorStroke.html
	 */ 
	public class SolidColorStrokeFactory
	{
		public function SolidColorStrokeFactory()
		{
		}
		
		/**
		 * Create mx.graphics SolidColorStroke from SVG SolidColorStroke element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:SolidColorStroke = null):SolidColorStroke
		{
			if (!element)
			{
				element = new SolidColorStroke();
			}
			
			// get attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG SolidColorStroke from Spark SolidColorStroke
		 */ 
		public static function createSVGFromSpark(element:SolidColorStroke):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}