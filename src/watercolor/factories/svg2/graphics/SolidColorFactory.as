package watercolor.factories.svg2.graphics
{
	import mx.graphics.SolidColor;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics SolidColor Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/SolidColor.html
	 */ 
	public class SolidColorFactory
	{
		public function SolidColorFactory()
		{
		}
		
		/**
		 * Create mx.graphics SolidColor from SVG SolidColor element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:SolidColor = null):SolidColor
		{
			if (!element)
			{
				element = new SolidColor();
			}
			
			// get attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG SolidColor from Spark SolidColor
		 */ 
		public static function createSVGFromSpark(element:SolidColor):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}