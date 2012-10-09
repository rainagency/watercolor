package watercolor.factories.svg2
{
	import spark.primitives.supportClasses.FilledElement;
	
	import watercolor.elements.Element;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.namespaces.ns_svg;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Child Graphics Factory
	 * This factory is for creating the child graphics for an element such as fills, strokes, and filters
	 */ 
	public class GraphicsFactory
	{
		public function GraphicsFactory()
		{
		}
		
		/**
		 * Create child graphic From SVG node
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
						trace("Cannot create child " + child.localName() + " on " + element.toString());
					}					
				}
			} 
			
			return element;
		}
		
		public static function createSVGFromSpark(workarea:Workarea):XML
		{
			return null;
		}
	}
}