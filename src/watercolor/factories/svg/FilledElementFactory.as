package watercolor.factories.svg
{
	import mx.graphics.IFill;
	import mx.graphics.SolidColor;
	
	import spark.primitives.supportClasses.FilledElement;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * FilledElement Factory
	 */ 
	public class FilledElementFactory
	{
		public function FilledElementFactory()
		{
		}
		
		/**
		 * Create WaterColor FilledElement From SVG node
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:FilledElement):FilledElement
		{
			// Get StrokedElement
			StrokedElementFactory.createSparkFromSVG(node, uriManager, element);
			
			// fill
			var fill:IFill;
			
			// fill i.e. "red", "#990000", "#redGradient"
			if(node.@fill.length() > 0) 
			{
				var tempFill:Object = SVGAttributes.parseFill(node.@fill);
				
				if (tempFill is uint)
				{
					fill = new SolidColor();
					SolidColor(fill).color = uint(tempFill);
				}
				// URI found if not "none"
				else if (tempFill is String && tempFill != "none")
				{
					// Handle URL Fills with LinearGradient, RadialGradient, BitmapFill 
					fill = IFill(uriManager.getURElement(String(tempFill)));
				}
			}			
			
			// Fill-opacity -> alpha
			if(node.attribute('fill-opacity').length() > 0)
			{
				if (fill is SolidColor)
				{
					SolidColor(fill).alpha = SVGAttributes.parseLength(node.attribute('fill-opacity'));
				}
				else
				{
					throw new Error("FilledElement's fill-opacity to alpha can only be set on a SolidColor fill.");
				}
			}
			
			// Assign fill
			element.fill = fill;
			
			return element;
		}
		
		public static function createSVGFromSpark(element:FilledElement):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}