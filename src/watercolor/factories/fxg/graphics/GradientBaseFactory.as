package watercolor.factories.fxg.graphics
{
	import mx.graphics.GradientBase;
	import mx.graphics.GradientEntry;
	
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * mx.graphics GradientBase Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/GradientBase.html
	 */ 
	public class GradientBaseFactory
	{
		public function GradientBaseFactory()
		{
		}
		
		/**
		 * Create mx.graphics GradientBase from FXG
		 * @node svg xml
		 * @element GradientBase Pass in a LinearGradient, LinearGradientStroke, RadialGradientStroke, and RadialGradient.
		 * 			GradientBase is abstract so we never create an actual GradientBase element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:GradientBase):GradientBase
		{			
			// entries
			var entries:Array = new Array();
			for each (var child:XML in node.children())
			{
				var entry:GradientEntry = GradientEntryFactory.createSparkFromFXG(child, uriManager);
				entries.push(entry);
			}
			element.entries = entries;
			
			return element;
		}
		
		/**
		 * Create abstract Gradient FXG attributes from Spark GradientBase
		 */ 
		public static function createSVGFromSpark(element:GradientBase):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}