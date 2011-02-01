package watercolor.factories.svg
{
	import flash.geom.Matrix;
	
	import spark.primitives.supportClasses.GraphicElement;
	
	import watercolor.factories.svg.enums.Display;
	import watercolor.factories.svg.enums.Visibility;
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;
	
	/**
	 * GraphicElement Factory
	 */ 
	public class GraphicElementFactory
	{
		public function GraphicElementFactory()
		{
		}
		
		/**
		 * Create WaterColor Element From SVG
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:GraphicElement):GraphicElement
		{
			// id
			if (node.@id.length() > 0)
			{
				element.id = node.@id;
			}
			
			// TODO: In the old SVGLibrary, we never used x and y, only the transform offsets
			//		 We need to make sure that if an object has an x, y set and a transform offset
			//		 that this is accurate in spark.  Right now transform tx, ty override x, y values.
			
			// x
			if(node.@x.length() > 0)
			{
				element.x = SVGAttributes.parseLength(node.@x);
			}
			
			// y
			if(node.@y.length() > 0)
			{
				element.y = SVGAttributes.parseLength(node.@y);
			}
			
			// height
			if(node.@height.length() > 0)
			{
				element.height = SVGAttributes.parseLength(node.@height);
			}
			
			// width
			if(node.@width.length() > 0)
			{
				element.width = SVGAttributes.parseLength(node.@width);
			}
			
			// opacity -> alpha (svg has opacity, flash has alpha)
			if(node.@opacity.length() > 0)
			{
				element.alpha = parseFloat(String(node.@opacity));
			}
			
			// display -> visible 
			if(node.@display.length() > 0)
			{
				if (node.@display == Display.NONE)
				{
					element.visible = false;
				}
			}
			
			// visibility -> visible
			if(node.@visibility.length() > 0)
			{
				if (node.@visibility == Visibility.HIDDEN)
				{
					element.visible = false;
				}
			}
			
			// transform
			if(node.@transform.length() > 0)
			{
				// Fix any rounding point errors that may have cropped up and keep our tx and ty pixel-based.
				var transform:Matrix = SVGAttributes.parseTransform(node.@transform);
					
				// TODO: See if we still need MatrixUtils fixFloatingPointErrors()
				//MatrixUtils.fixFloatingPointErrors(node.@transform, true);
				
				element.transform.matrix = transform;
			}
			
			// TODO: mask
//			if (node.@mask.length() > 0)
//				mask = SVGAttributes.parseURL(node.@mask);
			
			// TODO: clippath
//			if (node["@clip-path"].length() > 0)
//				clipPath = SVGAttributes.parseURL(node["@clip-path"]);
			
			// TODO: filter
//			if (node.@filter.length() > 0)
//				filter = SVGAttributes.parseURL(node.@filter);
			
			
			///////////////////////////////////
			// Custom Rain attributes
						
			// TODO: rain:type
//			if (node.@ns_rain::type.length() > 0)
//			{
//				return node.@ns_rain::type;
//			}
			
			// TODO: persist
//			if (value.@ns_rain::persist.length() > 0)
//				persist = value.@ns_rain::persist;
			
			// TODO: arrangeable
//			if (node.@ns_rain::arrangeable.length() > 0)
//				_arrangeable = node.@ns_rain::arrangeable == 'true';
//			
			// TODO: locked
//			if (node.@ns_rain::locked.length() > 0)
//				_locked = node.@ns_rain::locked == 'true';
//			
			// TODO: resizable
//			if (node.@ns_rain::resizable.length() > 0)
//				_resizable = node.@ns_rain::resizable == 'true';
//			
			// TODO: rotatable
//			if (node.@ns_rain::rotatable.length() > 0)
//				_rotatable = node.@ns_rain::rotatable == 'true';
//			
			// TODO: movable
//			if (node.@ns_rain::movable.length() > 0)
//				_movable = node.@ns_rain::movable == 'true';
//			
			// TODO: deletable
//			if (node.@ns_rain::deletable.length() > 0)
//				_deletable = node.@ns_rain::deletable == 'true';
			
			// TODO: imageWellNonTarget
//			if (node.@ns_rain::imageWellNontarget.length() > 0)
//				imageWellNont
			
			return element;
		}
		
		/**
		 * Create SVG Element From Watercolor
		 */ 
		public static function createSVGFromSpark(element:GraphicElement):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}