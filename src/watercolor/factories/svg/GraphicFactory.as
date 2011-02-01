package watercolor.factories.svg
{
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.primitives.Graphic;
	import spark.primitives.Rect;
	
	import watercolor.factories.svg.ElementFactory;
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Spark Graphic Factory
	 * 
	 * <graphic> is the SVG root node.  Thus we are converting an <svg> node to a graphic spark object.
	 * 
	 * Notice: Graphic is different than a GraphicElement.
	 * @see spark.primitives.Graphic
	 * @see spark.primitives.supportClasses.GraphicElement;
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG11/struct.html#SVGElement
	 */ 
	public class GraphicFactory
	{
		public function GraphicFactory()
		{
		}
		
		/**
		 * Create Spark Graphic from SVG element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Graphic = null):Graphic
		{
			if (!element)
			{
				element = new Graphic();
			}
			
			// Send through GroupFactory to create Children 
			GroupFactory.createSparkFromSVG(node, uriManager, element);
			
			// TODO: Viewbox
			
			return element;
		}
		
		public static function createSVGFromSpark(element:Rect):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}