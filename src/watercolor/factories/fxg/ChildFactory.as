package watercolor.factories.fxg
{
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Element Factory
	 */ 
	public class ChildFactory
	{
		/**
		 * Create any graphics such as fills, strokes, or filters from FXG element
		 * @param object Created object.  Could be anything from a LinearGradient to a Group. 
		 * 				 
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager):Object
		{
			return ElementFactory.createSparkFromFXG(node.children()[0], uriManager);
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