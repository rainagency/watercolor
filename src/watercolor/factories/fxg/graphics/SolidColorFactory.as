package watercolor.factories.fxg.graphics
{
	import mx.graphics.SolidColor;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics SolidColor Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/SolidColor.html
	 */ 
	public class SolidColorFactory
	{
		public function SolidColorFactory()
		{
		}
		
		/**
		 * Create mx.graphics SolidColor from FXG SolidColor element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:SolidColor = null):SolidColor
		{
			if (!element)
			{
				element = new SolidColor();
			}
			
			// get attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG SolidColor from Spark SolidColor
		 */ 
		public static function createFXGFromSpark(element:SolidColor):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}