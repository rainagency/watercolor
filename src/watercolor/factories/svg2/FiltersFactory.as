package watercolor.factories.svg2
{
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark Element Factory
	 */ 
	public class FiltersFactory
	{
		/**
		 * Create Spark filters from SVG filters
		 * @param object Create Array containing all filters
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):Array
		{
			// create a new array and insert all created filters
			var filters:Array = new Array();			
			for each (var child:XML in node.children()) {
				filters.push(ElementFactory.createSparkFromSVG(child, uriManager));
			}
			
			return filters;
		}
		
		/**
		 * Create SVG from Spark Object
		 */ 
		public static function createSVGFromSpark(element:Object, workarea:Workarea):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}