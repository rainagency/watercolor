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
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Object = null):Object
		{
			if (!element) {
				element = new Object();
			}
			
			// make sure there are children nodes
			if (node.children().length() > 0) {
				
				// go through each node and create the child graphic and set it on the element
				for each (var child:XML in node.children()) {					
					try {
						element[child.localName()] = ElementFactory.createSparkFromSVG(child, uriManager);
					} catch (err:Error) {
						trace("Cannot create property " + child.localName() + " on " + element.toString());
					}					
				}
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