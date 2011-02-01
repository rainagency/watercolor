package watercolor.factories.svg
{
	import spark.primitives.Rect;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Spark Rect Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/shapes.html#RectElement
	 */ 
	public class RectFactory
	{
		public function RectFactory()
		{
		}
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Rect = null):Rect
		{
			if (!element)
			{
				element = new Rect();
			}
			
			// Decorate through parents
			FilledElementFactory.createSparkFromSVG(node, uriManager, element);
			
			// rx - rounded x
			if(node.@rx.length() > 0)
			{
				element.radiusX = SVGAttributes.parseLength(node.@rx);
			}
			
			// ry - rounded y
			if(node.@ry.length() > 0)
			{
				element.radiusY = SVGAttributes.parseLength(node.@ry);
			}
			
			return element;
		}
		
		public static function createSVGFromSpark(element:Rect):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}