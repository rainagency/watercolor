package watercolor.factories.fxg.graphics
{
	import mx.graphics.GradientEntry;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics GradientEntry Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/GradientEntry.html
	 */ 
	public class GradientEntryFactory
	{
		public function GradientEntryFactory()
		{
		}
		
		/**
		 * Create mx.graphics GradientEntry from FXG GradientEntry element
		 * Note: uriManager not used but needed in signature for psuedo interface implementation
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:GradientEntry = null):GradientEntry
		{
			if (!element)
			{
				element = new GradientEntry();
			}
			
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create FXG GradientEntry from Spark GradientEntry
		 */ 
		public static function createFXGFromSpark(element:GradientEntry):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}