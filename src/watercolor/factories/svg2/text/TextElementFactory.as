package watercolor.factories.svg2.text
{
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.LinkElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.tlf_internal;
	
	import mx.core.mx_internal;
	import mx.utils.object_proxy;
	
	import org.flexunit.internals.namespaces.classInternal;
	
	import watercolor.elements.Text;
	import watercolor.factories.svg2.util.SVGClassFactoryManager;
	import watercolor.factories.svg2.util.URIManager;
	

	/**
	 * Spark Text Element Factory
	 */ 
	public class TextElementFactory
	{
		/**
		 * Create Spark Element from SVG element
		 * @param object Created object.  Could be anything from a SpanElement to LinkElement. 
		 * 	
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):Object
		{
			return null;
		}
		
		/**
		 * Create SVG from Spark Object
		 */ 
		public static function createSVGFromSpark(xml:XML, flow:Object, line:TextFlowLine, start:int, element:Text):Object
		{
			var elmName:String = "";
			
			// there has to be a way to get a class name from these classes
			// I want it to be similar to ElementFactory
			if (flow is SpanElement) {
				elmName = "spanelement";
			} else if (flow is LinkElement) {
				elmName = "linkelement";
			}
			
			// Get Spark Factory
			var nodeFactory:Class = SVGClassFactoryManager.getClassFactory(elmName);
			var elm:Object;
			
			// Create Element
			if (nodeFactory)
			{
				elm = nodeFactory.createSVGFromSpark(xml, flow, line, start, element);
			}
			
			return elm;
		}
	}
}