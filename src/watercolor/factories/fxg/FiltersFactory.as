package watercolor.factories.fxg
{
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Element Factory
	 */ 
	public class FiltersFactory
	{
		/**
		 * Create Spark filters from FXG filters
		 * @param object Create Array containing all filters
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager):Array
		{
			// create a new array and insert all created filters
			var filters:Array = new Array();			
			for each (var child:XML in node.children()) {
				filters.push(ElementFactory.createSparkFromFXG(child, uriManager));
			}
			
			return filters;
		}
		
		/**
		 * Create FXG from Spark Object
		 */ 
		public static function createFXGFromSpark(element:Object):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}