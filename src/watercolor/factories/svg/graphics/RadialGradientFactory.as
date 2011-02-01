package watercolor.factories.svg.graphics
{
	import flash.geom.Matrix;
	
	import mx.graphics.RadialGradient;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * mx.graphics RadialGradient Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/pservers.html#RadialGradients
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/RadialGradient.html
	 */ 
	public class RadialGradientFactory
	{
		public function RadialGradientFactory()
		{
		}
		
		/**
		 * Create mx.graphics LinearGradient from SVG LinearGradient element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:RadialGradient = null):RadialGradient
		{
			if (!element)
			{
				element = new RadialGradient();
			}
			
			// Send through GradientBaseFactory for entries, spreadMethod, gradientTransform
			GradientBaseFactory.createSparkFromSVG(node, uriManager, element);
			
			////////////////////////////////////
			// Radial Gradient Positions
			
			// TODO: SVG gradientUnits are not taken into account right now.
			// 		 Positions could be relative to the parent object or to the svg document.
			//		 Right now we assume they are always relative to parent (objectBoundingBox)
			
			// Center x
			var cx:Number;
			
			// Center y
			var cy:Number;
			
			// Radius
			var r:Number;
			
			// Focal x
			var fx:Number;
			
			// Focal y
			var fy:Number;
			
			if (node.@cx.length())
				cx = node.@cx;
			
			if (node.@cy.length())
				cy = node.@cy;
			
			if (node.@r.length())
				r = node.@r;
			
			if (node.@fx.length())
				fx = node.@fx;
			
			if (node.@fy.length())
				fy = node.@fy;
			
			
			////////////////////////////////////////
			// Calculate Gradient Fill
			
			// TODO: This area needs a lot of work, this is a copy & paste from old library
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(r * 2, r * 2, 0, cx - r, cy - r);
			
			// TODO: Ensure this is working correctly, concatenating matrix with element.matrix
			// 		 may be incorrect.  I just ported this over from the old SVG library.
			if (element.matrix)
			{
				matrix.concat(element.matrix);
			}
//			
			return element;
		}
		
		/**
		 * Create SVG RadialGradient from Spark RadialGradient
		 */ 
		public static function createSVGFromSpark(element:RadialGradient):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}