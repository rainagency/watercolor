package watercolor.factories.svg2.graphics
{
	import mx.graphics.GradientBase;
	import mx.graphics.GradientEntry;
	
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * mx.graphics GradientBase Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/GradientBase.html
	 */ 
	public class GradientBaseFactory
	{
		public function GradientBaseFactory()
		{
		}
		
		/**
		 * Create mx.graphics GradientBase from SVG
		 * @node svg xml
		 * @element GradientBase Pass in a LinearGradient, LinearGradientStroke, RadialGradientStroke, and RadialGradient.
		 * 			GradientBase is abstract so we never create an actual GradientBase element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:GradientBase):GradientBase
		{			
			// entries
			var entries:Array = new Array();
			for each (var child:XML in node.children())
			{
				var entry:GradientEntry = GradientEntryFactory.createSparkFromSVG(child, uriManager);
				entries.push(entry);
			}
			element.entries = entries;
			
			return element;
		}
		
		/**
		 * Create abstract Gradient SVG attributes from Spark GradientBase
		 */ 
		public static function createSVGFromSpark(element:GradientBase):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}