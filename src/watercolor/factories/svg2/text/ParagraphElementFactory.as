package watercolor.factories.svg2.text
{
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ParagraphElement;
	
	import mx.collections.XMLListCollection;
	
	import watercolor.elements.Text;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 *
	 */ 
	public class ParagraphElementFactory
	{
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):ParagraphElement
		{
			return null;
		}
		
		public static function createSVGFromSpark(xml:XML, paragraph:ParagraphElement, line:TextFlowLine, start:int, element:Text):Object
		{
			var list:Array = new Array();
			var blankLines:int = 1;
			
			for (var x:int = 0; x < line.paragraph.numChildren; x++) {
				
				var tspan:XML = TextElementFactory.createSVGFromSpark(xml, line.paragraph.getChildAt(x), line, start, element) as XML;
				list.push(tspan);
			}
			
			return list;
		}
	}
}