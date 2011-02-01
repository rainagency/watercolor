package watercolor.factories.svg
{
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;
	
	import spark.primitives.supportClasses.GraphicElement;
	import spark.primitives.supportClasses.StrokedElement;
	
	import watercolor.elements.Element;
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;
	
	/**
	 * StrokedElement Factory
	 */ 
	public class StrokedElementFactory
	{
		public function StrokedElementFactory()
		{
		}
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:StrokedElement):StrokedElement
		{
			// Get GraphicElement
			GraphicElementFactory.createSparkFromSVG(node, uriManager, element);
			
			// create solid color stroke
			var stroke:SolidColorStroke = new Stroke();
			
			// TODO: GradientStroke from uriManager
			
			// stroke color
			if(node.@stroke.length() > 0)
			{
				stroke.color = SVGAttributes.parseColor(node.@stroke);
			}
			
			// stroke line cap -> caps
			if(node.attribute('stroke-linecap').length() > 0)
			{
				stroke.caps = node.attribute('stroke-linecap');
			}
			
			// stroke linejoin -> joints
			if(node.attribute('stroke-linejoin').length() > 0)
			{
				stroke.joints = node.attribute('stroke-linejoin');
			}
			
			// miter limit
			if(node.attribute('stroke-miterlimit').length() > 0)
			{
				stroke.miterLimit = node.attribute('stroke-miterlimit');
			}
			
			// stroke-width -> weight
			if(node.attribute('stroke-width').length() > 0)
				stroke.weight = SVGAttributes.parseLength(node.attribute('stroke-width'));
			
			// stroke-opacity -> alpha
			if(node.attribute('stroke-opacity').length() > 0)
				stroke.alpha = node.attribute('stroke-opacity');
			
			// TODO: stroke-dasharray
			
			// TODO: stroke-dashoffset
			
			// Assign Stroke
			element.stroke = stroke;
			
			return element;
		}
		
		public static function createSVGFromSpark(element:StrokedElement):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}