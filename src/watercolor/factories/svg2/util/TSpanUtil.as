package watercolor.factories.svg2.util
{
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.formats.TextAlign;
	
	import mx.core.UIComponent;
	
	import watercolor.elements.Text;

	public class TSpanUtil
	{
		public static function lookForTSpanElement(xml:XML):XML {
			
			if (xml.localName() == "tspan") {
				
				return xml;
				
			} else if (xml && xml.children().length() > 0) {
				
				for each (var x:XML in xml.children()) {
					
					lookForTSpanElement(x);
				}
			}
			
			return null;
		}
		
		public static function parseTextProperties(flow:FlowElement, tspan:XML):void {
			
			if (flow.computedFormat.color) {
				tspan.@fill = SVGAttributes.createColor(flow.computedFormat.color);
			}
			
			if (flow.computedFormat.fontWeight) {
				tspan.@["font-weight"] = flow.computedFormat.fontWeight;
			}
			
			if (flow.computedFormat.fontStyle) {
				tspan.@["font-style"] = flow.computedFormat.fontStyle;
			}
			
			if (flow.computedFormat.fontFamily) {
				tspan.@["font-family"] = flow.computedFormat.fontFamily;
			}
			
			if (flow.computedFormat.fontSize) {
				tspan.@["font-size"] = flow.computedFormat.fontSize;
			}
		}
		
		public static function parseTextAlignment(element:Text, flow:FlowElement, tspan:XML):void {
			
			var width:Number = element.textInput.width;
			if (element.textInput.textDisplay is UIComponent) {
				width = UIComponent(element.textInput.textDisplay).width;
			}
			
			if (flow.computedFormat.textAlign == TextAlign.LEFT) {
				tspan.@["text-anchor"] = "start";
			} else if (flow.computedFormat.textAlign == TextAlign.CENTER) {
				tspan.@x = width / 2;
				tspan.@["text-anchor"] = "middle";
			} else if (flow.computedFormat.textAlign == TextAlign.RIGHT) {
				tspan.@x = width;
				tspan.@["text-anchor"] = "end";
			}
		}
	}
}