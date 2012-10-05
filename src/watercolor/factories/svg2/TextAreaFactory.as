package watercolor.factories.svg2
{
	import flash.text.engine.FontWeight;
	
	import flashx.textLayout.formats.TextLayoutFormat;
	
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
	public class TextAreaFactory
	{
		public function TextAreaFactory()
		{
		}
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Text = null):Text
		{
			if (!element)
			{
				element = new Text();
			}
			
			// look for any children such as fills, strokes, or filters
			GraphicsFactory.createSparkFromSVG(node, uriManager, element);	
			
			// set any attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		public static function createSVGFromSpark(element:Text, workarea:Workarea):XML
		{
			var text:XML = new XML("<text/>");
			text.@x = element.x;
			text.@y = element.y;
			
			var input:TextArea = element.textInput;
			
			var fmt:TextLayoutFormat;
			var pfmt:TextLayoutFormat;
			var start:int = 0;
			var differences:Boolean = false;
			
			for (var x:int = 0; x < input.text.length; x++) {
				
				fmt = input.getFormatOfRange(null, x, x);
				
				if (!pfmt) {
					pfmt = fmt;
				}
				
				if (fmt.fontWeight != pfmt.fontWeight || 
					fmt.fontStyle != pfmt.fontStyle || 
					fmt.fontFamily != pfmt.fontFamily ||
					fmt.fontSize != pfmt.fontSize ||
					(differences && x == (input.text.length - 1))) {
					
					differences = true;
					
					var tspan:XML = new XML("<tspan/>");
					parseTextProperties(pfmt, tspan);
					
					tspan.appendChild(new XML("<![CDATA[" + input.text.substring(start, (x == (input.text.length - 1)) ? x + 1 : x - 1) + "]]>"));
					
					text.appendChild(tspan);
					
					start = x - 1;
					
				} 
				
				pfmt = fmt;
			}
			
			if (!differences) {
				
				fmt = input.getFormatOfRange(null, 0, input.text.length);
				parseTextProperties(fmt, text);
				
				text.appendChild(input.text);
			}
			
			return text;
			
		}
		
		protected static function parseTextProperties(fmt:TextLayoutFormat, text:XML):void {
			
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
	}
}