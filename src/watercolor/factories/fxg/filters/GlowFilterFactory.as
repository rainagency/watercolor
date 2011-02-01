package watercolor.factories.fxg.filters
{
	import mx.graphics.GradientBase;
	
	import spark.filters.GlowFilter;
	
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics GlowFilter Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/filters/GlowFilter.html
	 */ 
	public class GlowFilterFactory
	{
		public function GlowFilterFactory()
		{
		}
		
		/**
		 * Create mx.graphics GlowFilter from FXG
		 * @node fxg xml
		 * @element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:GlowFilter = null):GlowFilter
		{
			if (!element)
			{
				element = new GlowFilter();
			}
			
			// get attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create abstract GlowFilter FXG attributes from Spark GlowFilter
		 */ 
		public static function createSVGFromSpark(element:GradientBase):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}