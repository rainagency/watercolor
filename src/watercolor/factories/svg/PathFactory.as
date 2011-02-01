package watercolor.factories.svg
{
	import flash.display.GraphicsPathWinding;
	
	import spark.primitives.Path;
	
	import watercolor.factories.svg.enums.FillRule;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Path Factory
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
			
			// Decorate through parents
			FilledElementFactory.createSparkFromSVG(node, uriManager, element);
			
			// data <path data>: The definition of the outline of a shape. See [Path data].
			if(node.@d.length() > 0){
				element.data =  node.@d;
			}
			
			// pathLength <Number>
			if(node.@pathLength.length() > 0){
				// Spark does not handle svg's pathlength attribute
			}
						
			// fill-rule -> winding  <String> (evenOdd, nonZero): Fill rule for intersecting or overlapping path segments.
			// Notice: svg's fill-rule values are "evenodd" and "nonzero" which need to be converted 
			// 		   to Spark's "evenOdd" and "nonZero"
			// 		   Spark Default: 	evenOdd
			//		   SVG Default: 	nonzero
			if(node.attribute('fill-rule').length() > 0)
			{
				if (node.attribute('fill-rule') == FillRule.EVEN_ODD)
				{
					element.winding	= GraphicsPathWinding.EVEN_ODD;
				}
				else if (node.attribute('fill-rule') == FillRule.NON_ZERO)
				{
					element.winding	= GraphicsPathWinding.NON_ZERO;
				}
			}
			else
			{
				// TODO: Ensure handling of SVG vs Spark default winding values is correct
				//       because SVG's default winding rule is nonzero and Spark's is evenOdd
				element.winding = GraphicsPathWinding.NON_ZERO;
			}
			
			return element;
		}
		
		/**
		 * Create Path SVG XML
		 */ 
		public static function createSVGFromSpark(element:Path):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}