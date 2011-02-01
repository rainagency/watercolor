package watercolor.factories.fxg.graphics
{
	import mx.graphics.RadialGradientStroke;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics RadialGradientStroke Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/RadialGradientStroke.html
	 */ 
	public class RadialGradientStrokeFactory
	{
		public function RadialGradientStrokeFactory()
		{
		}
		
		/**
		 * Create mx.graphics RadialGradientStroke from FXG RadialGradientStroke element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:RadialGradientStroke = null):RadialGradientStroke
		{
			if (!element)
			{
				element = new RadialGradientStroke();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromFXG(node, uriManager, element);
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG RadialGradientStroke from Spark RadialGradientStroke
		 */ 
		public static function createFXGFromSpark(element:RadialGradientStroke):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}