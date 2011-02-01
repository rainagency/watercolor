package watercolor.factories.svg.graphics
{
	import mx.graphics.GradientEntry;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * mx.graphics GradientEntry Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/pservers.html#GradientStops
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/GradientEntry.html
	 */ 
	public class GradientEntryFactory
	{
		public function GradientEntryFactory()
		{
		}
		
		/**
		 * Create mx.graphics GradientEntry from SVG gradient stop element
		 * Note: uriManager not used but needed in signature for psuedo interface implementation
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:GradientEntry = null):GradientEntry
		{
			if (!element)
			{
				element = new GradientEntry();
			}
			
			// SVG offset -> Spark ratio
			var offset:Number = SVGAttributes.parseLength(node.attribute('offset'));
			element.ratio = offset;
			
			////////////////////////////////////////
			// Color & Opacity
			var color:int;
			var opacity:Number = 1;
			
			if (node.attribute('stop-color').length())
				color = SVGAttributes.parseColor(node.attribute('stop-color'));
			
			if (node.attribute('stop-opacity').length())
				opacity = SVGAttributes.parseLength(node.attribute('stop-opacity'));
			
			// Attributes stop-color & stop-opacity can be found within the 'style" attribute
			if (node.attribute('style').length() > 0)
			{
				var styles:Array = node.attribute('style').split(';');
				
				for each (var style:String in styles)
				{
					var parts:Array = style.split(':');
					if(parts[0] == 'stop-color')
						color = SVGAttributes.parseColor(parts[1]);
					
					if(parts[0] == 'stop-opacity')
						opacity = parts[1];
				}
			}
			
			// Color
			element.color = color;
			
			// SVG opacity -> Spark alpha
			element.alpha = opacity;
			
			return element;
		}
		
		/**
		 * Create SVG Gradient Stop from Spark GradientEntry
		 */ 
		public static function createSVGFromSpark(element:GradientEntry):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}