package watercolor.factories.fxg
{
	import spark.primitives.supportClasses.FilledElement;
	
	import watercolor.factories.fxg.util.URIManager;

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
		 * Create child graphic From FXG node
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:Object = null):Object
		{
			if (!element) {
				element = new Object();
			}
			
			// make sure there are children nodes
			if (node.children().length() > 0) {
				
				// go through each node and create the child graphic and set it on the element
				for each (var child:XML in node.children()) {					
					try {
						element[child.localName()] = ElementFactory.createSparkFromFXG(child, uriManager);
					} catch (err:Error) {
						trace("Cannot create property " + child.localName() + " on " + element.toString());
					}					
				}
			} 
			
			return element;
		}
		
		public static function createFXGFromSpark(element:FilledElement):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}