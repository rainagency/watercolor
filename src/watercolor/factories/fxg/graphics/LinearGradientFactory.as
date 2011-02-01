package watercolor.factories.fxg.graphics
{
	import mx.graphics.LinearGradient;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics LinearGradient Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/LinearGradient.html
	 */ 
	public class LinearGradientFactory
	{
		public function LinearGradientFactory()
		{
		}
		
		/**
		 * Create mx.graphics LinearGradient from FXG LinearGradient element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:LinearGradient = null):LinearGradient
		{
			if (!element)
			{
				element = new LinearGradient();
			}
			
			// Send through GradientBaseFactory for entries
			GradientBaseFactory.createSparkFromFXG(node, uriManager, element);
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG LinearGradient from Spark LinearGradient
		 */ 
		public static function createFXGFromSpark(element:LinearGradient):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}