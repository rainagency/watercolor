package watercolor.factories.svg2
{
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGClassFactoryManager;
	import watercolor.factories.svg2.util.URIManager;
	

	/**
	 * Spark Element Factory
	 */ 
	public class ElementFactory
	{
		/**
		 * Create Spark Element from SVG element
		 * @param object Created object.  Could be anything from a LinearGradient to a Group. 
		 * 	
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):Object
		{
			// Get SVG NodeName i.e. "Path" from <Path />
			// All node name enumerations are lowercase.  i.e. Change Group to group
			var fxgNodeName:String = node.localName().toString();
			fxgNodeName = fxgNodeName.toLowerCase(); 
			
			// Get Spark Factory
			var elementFactory:Class = SVGClassFactoryManager.getClassFactory(fxgNodeName);
			
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
		public static function createSVGFromSpark(element:Object, workarea:Workarea):XML
		{
			var elmName:String = element.className.toLowerCase();
			
			// Get Spark Factory
			var nodeFactory:Class = SVGClassFactoryManager.getClassFactory(elmName);
			var elm:XML;
			
			// Create Element
			if (nodeFactory)
			{
				elm = nodeFactory.createSVGFromSpark(element, workarea);
			}
			
			return elm;
		}
	}
}