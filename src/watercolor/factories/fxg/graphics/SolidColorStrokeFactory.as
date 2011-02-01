package watercolor.factories.fxg.graphics
{
	import mx.graphics.SolidColorStroke;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics SolidColorStroke Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/SolidColorStroke.html
	 */ 
	public class SolidColorStrokeFactory
	{
		public function SolidColorStrokeFactory()
		{
		}
		
		/**
		 * Create mx.graphics SolidColorStroke from FXG SolidColorStroke element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:SolidColorStroke = null):SolidColorStroke
		{
			if (!element)
			{
				element = new SolidColorStroke();
			}
			
			// get attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG SolidColorStroke from Spark SolidColorStroke
		 */ 
		public static function createFXGFromSpark(element:SolidColorStroke):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}