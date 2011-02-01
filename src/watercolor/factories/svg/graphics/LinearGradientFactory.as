package watercolor.factories.svg.graphics
{
	import flash.geom.Matrix;
	
	import mx.graphics.LinearGradient;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * mx.graphics LinearGradient Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/pservers.html#LinearGradients
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/LinearGradient.html
	 */ 
	public class LinearGradientFactory
	{
		public function LinearGradientFactory()
		{
		}
		
		/**
		 * Create mx.graphics LinearGradient from SVG LinearGradient element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:LinearGradient = null):LinearGradient
		{
			if (!element)
			{
				element = new LinearGradient();
			}
			
			// Send through GradientBaseFactory for entries, spreadMethod, gradientTransform
			GradientBaseFactory.createSparkFromSVG(node, uriManager, element);
			
			////////////////////////////////////
			// Linear Gradient Positions
			
			// TODO: SVG gradientUnits are not taken into account right now.
			// 		 Positions could be relative to the parent object or to the svg document.
			//		 Right now we assume they are always relative to parent (objectBoundingBox)
			
			var x1:Number;
			var y1:Number;
			var x2:Number;
			var y2:Number;
			
			// TODO: SVGAttributes.parseLength doesn't support %'s
			if (node.@x1.length())
				x1 = SVGAttributes.parseLength(node.@x1);
			
			if (node.@x2.length())
				x2 = SVGAttributes.parseLength(node.@x2);
			
			if (node.@y1.length())
				y1 = SVGAttributes.parseLength(node.@y1);
			
			if (node.@y2.length())
				y2 = SVGAttributes.parseLength(node.@y2);
			
			
			////////////////////////////////////////
			// Calculate Gradient Fill
			
			// TODO: This area needs a lot of work, this is a copy & paste from old library
			
			var width:Number = Math.abs(x1 - x2) || 1;
			var height:Number = Math.abs(y1 - y2) || 1;
			
			var tx:Number = Math.min(x1, x2);
			var ty:Number = Math.min(y1, y2);
			
			var xLength:Number = x2 - x1;
			var yLength:Number = y2 - y1;
			
			var slope:Number = yLength/xLength;
			var rotation:Number = Math.atan(slope);
			if (xLength < 0 && yLength < 0)
				rotation += Math.PI;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height, rotation, tx, ty);
			
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
		 * Create SVG LinearGradient from Spark LinearGradient
		 */ 
		public static function createSVGFromSpark(element:LinearGradient):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}