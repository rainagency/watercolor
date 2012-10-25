package watercolor.factories.svg2
{
	import spark.primitives.supportClasses.FilledElement;
	
	import watercolor.elements.Element;
	import watercolor.elements.Layer;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.namespaces.ns_svg;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Child Graphics Factory
	 * This factory is for creating the child graphics for an element such as fills, strokes, and filters
	 */ 
	public class WorkareaFactory
	{
		public function WorkareaFactory()
		{
		}
		
		/**
		 * Create child graphic From SVG node
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):Vector.<Element>
		{
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			
			var vec:Vector.<Element> = new Vector.<Element>();
			
			node = node.normalize();
			
			// make sure there are children nodes
			if (node.children().length() > 0) {
				
				// go through each node and create the child graphic and set it on the element
				for each (var child:XML in node.children()) {					
					try {
						vec.push(ElementFactory.createSparkFromSVG(child, uriManager));
					} catch (err:Error) {
						trace("Cannot create element " + child.localName());
					}					
				}
			} 
			
			return vec;
		}
		
		public static function createSVGFromSpark(workarea:Workarea):XML
		{
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			
			var svg:XML = new XML("<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'/>");
			
			svg.@width = workarea.width;
			svg.@height = workarea.height;
			
			// loop through all the layers
			for (var x:int = 0; x < workarea.numElements; x++)
			{
				var elm:Element = workarea.getElementAt(x) as Element;
				
				if (elm is Layer) {
					LayerFactory.createSVGFromSpark(svg, elm, workarea);
				} else {
					svg.appendChild(ElementFactory.createSVGFromSpark(elm, workarea));
				}
				
			}
			
			return svg;
		}
	}
}