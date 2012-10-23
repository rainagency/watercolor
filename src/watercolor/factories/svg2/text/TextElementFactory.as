package watercolor.factories.svg2.text
{
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.elements.SpanElement;
	
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
			if (flow is SpanElement) {
				elmName = "spanelement";
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