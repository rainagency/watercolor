package watercolor.factories.svg2.filters
{
	import mx.graphics.GradientBase;
	
	import spark.filters.BlurFilter;
	
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics BlurFilter Factory
	 * 
	 * FXG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/filters/BlurFilter.html
	 */ 
	public class BlurFilterFactory
	{
		public function BlurFilterFactory()
		{
		}
		
		/**
		 * Create mx.graphics BlurFilter from FXG
		 * @node fxg xml
		 * @element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:BlurFilter = null):BlurFilter
		{
			if (!element)
			{
				element = new BlurFilter();
			}
			
			// get attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create abstract BlurFilter FXG attributes from Spark BlurFilter
		 */ 
		public static function createSVGFromSpark(element:GradientBase):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}