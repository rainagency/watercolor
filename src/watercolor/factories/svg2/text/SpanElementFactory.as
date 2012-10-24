package watercolor.factories.svg2.text
{
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	
	import mx.utils.StringUtil;
	
	import watercolor.elements.Text;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.TSpanUtil;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * 
	 */ 
	public class SpanElementFactory
	{
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):SpanElement
		{
			return null;
		}
		
		public static function createSVGFromSpark(xml:XML, span:SpanElement, line:TextFlowLine, start:int, element:Text):Object
		{
			var sBegin:int = span.getElementRelativeStart(line.paragraph);
			var sEnd:int = span.getElementRelativeStart(line.paragraph) + span.textLength;
			var text:String = span.text;
			var txt:String = "";
			
			var lbegin:int = line.absoluteStart - start;
			var lend:int = lbegin + line.textLength;
			var llength:int = line.textLength;
			
			var list:Boolean = false;
			if (element.textInput.textFlow.getChildAt(0) is ListElement) {
				list = true;
			}
			
			if ((sBegin >= lbegin && sBegin <= lend) || (sEnd >= lbegin && sEnd <= lend) || (lbegin >= sBegin && lend <= sEnd)) {
				
				// if line is conatined inside of span
				if (lbegin >= sBegin && lend <= sEnd) {
					
					txt = text.substr(lbegin - sBegin, llength);
					
				}
				
				// if span is contained inside of line
				else if (sBegin >= lbegin && sEnd <= lend) {
					
					txt = text;
					
				}
				
				// if span goes off of line
				else if (sBegin < lend && sEnd > lend) {
					
					txt = text.substr(0, lend - sBegin);
					
				}
				
				// if span comes into line
				else if (sBegin < lbegin && sEnd < lend) {
					
					txt = text.substr(lbegin - sBegin, sEnd - lbegin);
					
				}
				
			}
			
			var tspan:XML = null;
			var listText:String = "";
			
			if (StringUtil.trim(txt).length > 0) {
				
				trace("Span: " + txt);
				
				tspan = new XML("<tspan/>");
				tspan.@["xml:space"] = 'preserve';
				tspan.appendChild(txt);
				
				TSpanUtil.parseTextProperties(span, tspan);
				
				if (sBegin <= lbegin && lbegin >= 0) {
					
					if (list && lbegin == 0) {
						
						tspan.@listItem = true;
						if (tspan.children().length() > 0) {
							listText = tspan.children()[0];
							delete tspan.children()[0];
							tspan.appendChild(new XML(SVGAttributes.BULLET_POINT + "  " + listText));
						}
					}
					
					if ((start == 0 && lbegin > 0) || (start > 0)) {
						
						tspan.@x = 0;
						tspan.@dy = "1.2em";
						
						TSpanUtil.parseTextAlignment(element, span, tspan);
					}
				}
			} 
			
			// TODO: Generate SVG
			return tspan;
		}
	}
}