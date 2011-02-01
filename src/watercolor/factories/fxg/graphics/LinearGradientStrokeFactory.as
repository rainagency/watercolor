package watercolor.factories.fxg.graphics
{
	import mx.graphics.LinearGradientStroke;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics LinearGradientStroke Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/LinearGradientStroke.html
	 */ 
	public class LinearGradientStrokeFactory
	{
		public function LinearGradientStrokeFactory()
		{
		}
		
		/**
		 * Create mx.graphics LinearGradientStroke from FXG LinearGradientStroke element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:LinearGradientStroke = null):LinearGradientStroke
		{
			if (!element)
			{
				element = new LinearGradientStroke();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromFXG(node, uriManager, element);
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG LinearGradientStroke from Spark LinearGradientStroke
		 */ 
		public static function createFXGFromSpark(element:LinearGradientStroke):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}