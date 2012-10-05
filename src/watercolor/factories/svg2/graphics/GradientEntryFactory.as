package watercolor.factories.svg2.graphics
{
	import mx.graphics.GradientEntry;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics GradientEntry Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/GradientEntry.html
	 */ 
	public class GradientEntryFactory
	{
		public function GradientEntryFactory()
		{
		}
		
		/**
		 * Create mx.graphics GradientEntry from SVG GradientEntry element
		 * Note: uriManager not used but needed in signature for psuedo interface implementation
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:GradientEntry = null):GradientEntry
		{
			if (!element)
			{
				element = new GradientEntry();
			}
			
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create SVG GradientEntry from Spark GradientEntry
		 */ 
		public static function createSVGFromSpark(element:GradientEntry):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}