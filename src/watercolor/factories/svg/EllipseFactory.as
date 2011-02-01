package watercolor.factories.svg
{
	import spark.primitives.Ellipse;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Spark Ellipse Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/shapes.html#EllipseElement
	 */ 
	public class EllipseFactory
	{
		/**
		 * Circle - svg node name
		 */ 
		public static const CIRCLE:String = "circle";
		
		/**
		 * Ellipse - svg node name
		 */ 
		public static const ELLIPSE:String = "ellipse";

		public function EllipseFactory()
		{
		}
		
		/**
		 * Create Spark Ellipse from Circle or Ellipse svg element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Ellipse = null):Ellipse
		{
			if (!element)
			{
				element = new Ellipse();
			}
			
			// cx - center x - only used in calculations
			var cx:Number = 0;
			if(node.@cx.length() > 0)
			{
				cx = SVGAttributes.parseLength(node.@cx);
			}
			
			// cy - center y - only used in calculations
			var cy:Number = 0;
			if(node.@cy.length() > 0)
			{
				cy = SVGAttributes.parseLength(node.@cy);
			}
			
			// Get either 'circle' or 'ellipse' svg node name
			var svgClass:String = node.localName().toString().toLowerCase();
			
			// Circle -> Spark Ellipse
			if (svgClass == CIRCLE)
			{
				// r - radius - only used in calculations
				var radius:Number;
				if(node.@r.length() > 0)
				{
					radius = SVGAttributes.parseLength(node.@r);
				}
				
				// Calculate width
				element.width = 2 * radius;
				
				// Calculate height
				element.height = 2 * radius;
				
				// Calculate x
				element.x = cx - radius;
				
				// Calculate y
				element.y = cy - radius;
			}
			// Ellipse -> Spark Ellipse
			else if (svgClass == ELLIPSE)
			{
				// rx - radiusX - only used in calculations
				if(node.@rx.length() > 0)
				{
					var radiusX:Number = SVGAttributes.parseLength(node.@rx);
				}
				else
				{
					throw new Error("SVG Ellipse requires rx attribute");
				}
				
				// ry - radiusY - only used in calculations
				if(node.@ry.length() > 0)
				{
					var radiusY:Number = SVGAttributes.parseLength(node.@ry);
				}
				else
				{
					throw new Error("SVG Ellipse requires ry attribute");
				}
				
				// Calculate width
				element.width = 2 * radiusX;
				
				// Calculate height
				element.height = 2 * radiusY;
				
				// Calculate x
				element.x = cx - radiusX;
				
				// Calculate y
				element.y = cy - radiusY;
			}
			
			// Decorate through parent factories
			// Notice: Normally this happens before parsing custom attributes, 
			// 		   however x, y, width, and height are calculated based off of
			//		   cx, cy, r, rx, ry values.  Transforming with tx, ty would 
			// 		   be off if we do not send to parent factories after.
			FilledElementFactory.createSparkFromSVG(node, uriManager, element);
			
			return element;
		}
		
		/**
		 * Create SVG Ellipse/Circle from Spark Ellipse
		 */ 
		public static function createSVGFromSpark(element:Ellipse):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}