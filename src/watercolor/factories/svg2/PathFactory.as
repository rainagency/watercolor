package watercolor.factories.svg2
{
	import mx.graphics.SolidColorStroke;
	
	import watercolor.elements.Path;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
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
		 * Create Spark Path from SVG
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Path = null):Path
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
					var fillNodes:XMLList = fill[0].children();
					fill = fillNodes[0];
				}
			}
			
			if(fill && fill.@bg != "")
			{
				element.backgroundColor = SVGAttributes.parseColor(fill.@bg.toXMLString());
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromSVG(node, uriManager, element);	
			
			// set any attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		/**
		 * Create Path SVG XML
		 */ 
		public static function createSVGFromSpark(element:Path, workarea:Workarea):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}