package watercolor.factories.fxg.graphics
{
	import mx.graphics.RadialGradient;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics RadialGradient Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/RadialGradient.html
	 */ 
	public class RadialGradientFactory
	{
		public function RadialGradientFactory()
		{
		}
		
		/**
		 * Create mx.graphics RadialGradient from FXG RadialGradient element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:RadialGradient = null):RadialGradient
		{
			if (!element)
			{
				element = new RadialGradient();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromFXG(node, uriManager, element);
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG RadialGradient from Spark RadialGradient
		 */ 
		public static function createFXGFromSpark(element:RadialGradient):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}