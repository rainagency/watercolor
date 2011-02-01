package watercolor.factories.svg.graphics
{
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.graphics.GradientBase;
	import mx.graphics.GradientEntry;
	import mx.graphics.GradientStroke;
	
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * mx.graphics GradientBase Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/pservers.html#Gradients
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/graphics/GradientBase.html
	 */ 
	public class GradientBaseFactory
	{
		public function GradientBaseFactory()
		{
		}
		
		/**
		 * Create mx.graphics GradientBase from SVG 
		 * @node svg xml
		 * @element GradientBase Pass in a LinearGradient, LinearGradientStroke, and RadialGradient.
		 * 			GradientBase is abstract so we never create an actual GradientBase element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:GradientBase):GradientBase
		{
			// TODO: GradientBases don't have an id, if we need to find this gradientBase by id, figure it how we will do that.
			// id - identity
//			if (node.@id.length() > 0)
//			{
//				element.id = node.@id;
//			}
			
			// entries
			var entries:Array = new Array();
			for each (var stop:XML in node[new QName(node.namespace(), "stop")])
			{
				var entry:GradientEntry = GradientEntryFactory.createSparkFromSVG(stop, uriManager);
				entries.push(entry);
			}
			element.entries = entries;
			
			// transform matrix
			if(node.@gradientTransform.length() > 0)
			{
				// Fix any rounding point errors that may have cropped up and keep our tx and ty pixel-based.
				var transform:Matrix = SVGAttributes.parseTransform(node.@gradientTransform);
				
				// TODO: See if we still need MatrixUtils fixFloatingPointErrors()
				//MatrixUtils.fixFloatingPointErrors(node.@transform, true);
				
				element.matrix = transform;
			}
			
			// spreadMethod "pad | reflect | repeat"
			if(node.@spreadMethod.length() > 0)
			{
				element.spreadMethod = node.@spreadMethod;
			}
			
			// TODO: Support xlink:href = "<uri>" using uriManager
			
			// TODO: Handle gradientUnits from SVG
			
			return element;
		}
		
		/**
		 * Create abstract Gradient SVG attributes from Spark GradientBase
		 * GradientBase does not exist in SVG, but RadialGradient and LinearGradient
		 * share similar attributes.  Here we will add those attributes to the xml node.
		 */ 
		public static function createSVGFromSpark(element:GradientBase):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}