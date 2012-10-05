package watercolor.factories.svg2
{
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.URIManager;

	/**
	 * Spark Element Factory
	 */ 
	public class ChildFactory
	{
		/**
		 * Create any graphics such as fills, strokes, or filters from SVG element
		 * @param object Created object.  Could be anything from a LinearGradient to a Group. 
		 * 				 
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):Object
		{
			return ElementFactory.createSparkFromSVG(node.children()[0], uriManager);
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