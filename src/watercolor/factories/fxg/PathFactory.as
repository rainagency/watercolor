package watercolor.factories.fxg
{
	import mx.graphics.SolidColorStroke;
	
	import watercolor.elements.Path;
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Path Factory
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/Path.html
	 */ 
	public class PathFactory
	{
		public function PathFactory()
		{
		}
		
		/**
		 * Create Spark Path from FXG
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:Path = null):Path
		{
			if (!element)
			{
				element = new Path();
			}

			// get the fill element
			var fill:XML;
			if( node.fill[0] && node.fill[0].Fill[0] )
			{
				var nodes:XMLList = node.fill[0].children();
				fill = nodes[0];
			}
			
			// look for a child fill exlement.
			
			if (fill == null)
			{
				fill = node.children()[0];
				if (fill)
				{
					var nodes:XMLList = fill[0].children();
					fill = nodes[0];
				}
			}
			
			if(fill && fill.@bg != "")
			{
				element.backgroundColor = FXGAttributes.parseColor(fill.@bg.toXMLString());
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromFXG(node, uriManager, element);	
			
			// set any attributes
			FXGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create Path FXG XML
		 */ 
		public static function createFXGFromSpark(element:Path):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}