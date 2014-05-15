package watercolor.factories.svg2
{
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	
	import spark.components.TextArea;
	
	import watercolor.elements.Text;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.text.ParagraphElementFactory;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.TSpanUtil;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark Rect Factory
	 * 
	 * SVG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/Rect.html
	 */ 
	public class TSpanFactory
	{
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):FlowElement
		{
			if (node.children().length() == 1) {
				
				var span:SpanElement = new SpanElement();
				
				span.text = (node.@listItem && node.@listItem.toString().length > 0) ? node.children()[0].toString().substring(3, node.children()[0].toString().length) : node.children()[0];
				
				if (node.@["font-family"] && node.@["font-family"].toString().length > 0) {
					span.fontFamily = node.@["font-family"].toString();
				}
				
				if (node.@["font-style"] && node.@["font-style"].toString().length > 0) {
					span.fontStyle = node.@["font-style"];
				}
				
				if (node.@["font-size"] && node.@["font-size"].toString().length > 0) {
					span.fontSize = node.@["font-size"];
				}
				
				if (node.@["font-weight"] && node.@["font-weight"].toString().length > 0) {
					span.fontWeight = node.@["font-weight"];
				}
				
				if (node.@["text-decoration"] && node.@["text-decoration"].toString().length > 0) {
					span.textDecoration = node.@["text-decoration"];
				}
				
				span.color = SVGAttributes.parseColor(node.@fill);
				
				return span;
			}
			
			
			return new SpanElement();
		}
		
		public static function createSVGFromSpark(text:XML, element:Text, workarea:Workarea, list:Boolean = false):void
		{
			var input:TextArea = element.textInput;
			var lines:int = input.textFlow.flowComposer.numLines;
			var line:TextFlowLine;
			var start:int = 0;
			var cparagraph:ParagraphElement;
			var xlist:Array = new Array();
			var newParagraph:Boolean = false;
			
			for (var x:int = 0; x < lines; x++) {
				
				line = input.textFlow.flowComposer.getLineAt(x);
				
				if (cparagraph && cparagraph != line.paragraph) {
					start += cparagraph.textLength;
					newParagraph = true;
				} else {
					newParagraph = false;
				}
				
				xlist.push(ParagraphElementFactory.createSVGFromSpark(text, line.paragraph, line, start, element, newParagraph));
				
				cparagraph = line.paragraph;
			}
			
			// Now look for blank lines and adjust the dy property
			var blankLines:int = 1;
			
			for (var w:int = 0; w < xlist.length; w++) {
				
				var xml:Array = xlist[w] as Array;
				for (var y:int = 0; y < xml.length; y++) {
				
					var flow:XML = xml[y] as XML;
					if (flow) {
						
						var tspan:XML = TSpanUtil.lookForTSpanElement(flow);
						text.appendChild(flow);
						
						if (tspan && w > 0 && tspan.@dy && tspan.@dy.toString().length > 0) {
							
							tspan.@dy = (blankLines * 1.2) + "em";
							blankLines = 1;
						}
						
					} else if (xml.length == 1) {
						
						blankLines++;
					}
				}
			}
			
		}
	}
}