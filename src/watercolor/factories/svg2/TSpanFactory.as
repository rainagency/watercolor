package watercolor.factories.svg2
{
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.text.engine.FontWeight;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.core.mx_internal;
	
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import watercolor.elements.Rect;
	import watercolor.elements.Text;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark Rect Factory
	 * 
	 * SVG Documentation: 
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/primitives/Rect.html
	 */ 
	public class TSpanFactory
	{
		public function TSpanFactory()
		{
		}
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Text, start:int, end:int):void
		{
			var tf:TextLayoutFormat = element.textInput.getFormatOfRange(null, start, end);
			tf.fontFamily = node.@["font-family"].toString();
			tf.fontStyle = node.@["font-style"];
			tf.fontSize = node.@["font-size"];
			tf.fontWeight = node.@["font-weight"];
			
			if (node.@["text-anchor"] && node.@["text-anchor"].toString().length > 0) {
				
				switch (node.@["text-anchor"].toString()) {
					
					case "start":
						tf.textAlign = TextAlign.LEFT;
						break;
					case "middle":
						tf.textAlign = TextAlign.CENTER;
						break;
					case "end":
						tf.textAlign = TextAlign.RIGHT;
						break;
					
				}
			}
			
			tf.color = SVGAttributes.parseColor(node.@fill);
			
			element.textInput.setFormatOfRange(tf, start, end);
		}
		
		public static function createSVGFromSpark(text:XML, element:Text, workarea:Workarea):void
		{
			var input:TextArea = element.textInput;
			
			var fmt:TextLayoutFormat;
			var ffmt:TextLayoutFormat;
			var start:int = 0;
			var differences:Boolean = false;
			var lineBreak:Boolean = false;
			var line:int = 0;
			
			//var manager:TextContainerManager = input.textDisplay.mx_internal::textContainerManager;
			
			for (var x:int = 0; x < input.text.length + 1; x++) {
				
				var s:String = input.text.substr(x, 1);
				
				fmt = input.getFormatOfRange(null, x, x);
				
				if (x < input.text.length) {
					ffmt = input.getFormatOfRange(null, x + 1, x + 1);
				}
				
				if (ffmt && fmt.fontWeight != ffmt.fontWeight || 
					fmt.fontStyle != ffmt.fontStyle || 
					fmt.fontFamily != ffmt.fontFamily ||
					fmt.fontSize != ffmt.fontSize ||
					fmt.color != ffmt.color || 
					s == "\n" ||
					(differences && x == input.text.length)) {
					
					differences = true;
					
					var tspan:XML = new XML("<tspan/>");
					parseTextProperties(fmt, tspan);
					
					if (lineBreak) {
						
						parseTextAlignment(element, fmt, tspan);
						
						tspan.@dy = "1em";
						lineBreak = false;
					}
					
					// if first one then set the x
					if (text.children().length() == 0) {
						parseTextAlignment(element, fmt, tspan);
					}
					
					if (s == "\n") {
						lineBreak = true;
						line++;
					}
					
					tspan.appendChild(new XML("<![CDATA[" + input.text.substring(start, x).replace("\n", "") + "]]>"));
					
					text.appendChild(tspan);
					
					start = x;
				}
			}
			
			if (!differences) {
				
				fmt = input.getFormatOfRange(null, 0, input.text.length);
				parseTextProperties(fmt, text);
				
				text.appendChild(input.text);
			}
		}
		
		protected static function parseTextProperties(fmt:TextLayoutFormat, text:XML):void {
			
			if (fmt.color) {
				text.@fill = SVGAttributes.createColor(fmt.color);
			}
			
			if (fmt.fontWeight) {
				text.@["font-weight"] = fmt.fontWeight;
			}
			
			if (fmt.fontStyle) {
				text.@["font-style"] = fmt.fontStyle;
			}
			
			if (fmt.fontFamily) {
				text.@["font-family"] = fmt.fontFamily;
			}
			
			if (fmt.fontSize) {
				text.@["font-size"] = fmt.fontSize;
			}
		}
		
		protected static function parseTextAlignment(element:Text, fmt:TextLayoutFormat, tspan:XML):void {
			
			if (fmt.textAlign == TextAlign.LEFT) {
				tspan.@x = 0;
				tspan.@["text-anchor"] = "start";
			} else if (fmt.textAlign == TextAlign.CENTER) {
				tspan.@x = element.width / 2;
				tspan.@["text-anchor"] = "middle";
			} else if (fmt.textAlign == TextAlign.RIGHT) {
				tspan.@x = element.width;
				tspan.@["text-anchor"] = "end";
			}
		}
	}
}