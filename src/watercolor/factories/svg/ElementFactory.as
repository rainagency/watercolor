package watercolor.factories.svg
{
	import flash.utils.Dictionary;
	
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.primitives.Rect;
	
	import watercolor.factories.svg.namespaces.ns_rain;
	import watercolor.factories.svg.namespaces.ns_svg;
	import watercolor.factories.svg.namespaces.ns_xlink;
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.SVGClassFactoryManager;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Spark Element Factory
	 */ 
	public class ElementFactory
	{
		/**
		 * Create Spark Group from SVG G element
		 * @param object Created object.  Could be anything from a LinearGradient to a Group. 
		 * 				 The only similar superclass is Object, not even IVisualElement.
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):Object
		{
			// Add Namespaces
			node.addNamespace(ns_rain);
			node.addNamespace(ns_svg);
			node.addNamespace(ns_xlink);
			
			// Get SVG NodeName i.e. "path" from <path />
			var svgNodeName:String = node.@ns_rain::type.toString() || node.localName().toString();
			svgNodeName = svgNodeName.toLowerCase(); // All node name enumerations are lowercase.  i.e. Change SVG to svg
			
			// Get Spark Factory
			var elementFactory:Class = SVGClassFactoryManager.getClassFactory(svgNodeName);
			
			// Create Element
			if (elementFactory)
			{
				var element:Object = elementFactory.createSparkFromSVG(node, uriManager);
			}
			
			return element;
		}
		
		/**
		 * Create SVG from Spark Object
		 */ 
		public static function createSVGFromSpark(element:Object):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}