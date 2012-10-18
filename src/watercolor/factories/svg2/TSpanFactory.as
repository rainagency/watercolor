package watercolor.factories.svg2
{
	import flash.text.engine.TextLine;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.utils.StringUtil;
	
	import spark.components.RichEditableText;
	import spark.components.TextArea;
	
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
		
		public static function createSVGFromSpark(text:XML, element:Text, workarea:Workarea, list:Boolean = false):void
		{
			var input:TextArea = element.textInput;
			
			var fmt:TextLayoutFormat;
			var ffmt:TextLayoutFormat;
			var start:int = 0;
			var cindex:int = 0;
			var prefix:String = "";
			
			var lineSpaces:int = 1;
			
			var manualLineBreak:Boolean = false;
			var beginAlign:Boolean = false;
			
			var manager:TextContainerManager = element.textInput.textDisplay.mx_internal::textContainerManager;
			var txt:String = element.textInput.text;
			
			for (var l:int = 0; l < manager.numLines; l++) {
				
				var textline:TextLine = manager.getLineAt(l);
				var s:String = txt.substr(start, textline.rawTextLength);
				
				cindex = 0;
				
				for (var x:int = 0; x < textline.rawTextLength + 1; x++) {
					
					var index:int = start + x;
					
					if (index <= txt.length) {
					
						fmt = input.getFormatOfRange(null, index, index);
						
						try
						{
							ffmt = input.getFormatOfRange(null, index + 1, index + 1);
						} 
						catch (err:Error) 
						{
							ffmt = null;
						}
						
						if ((x == textline.rawTextLength || !ffmt) || 
							(ffmt && fmt.fontWeight != ffmt.fontWeight || 
							 fmt.textAlign != ffmt.textAlign ||
							 fmt.fontStyle != ffmt.fontStyle || 
							 fmt.fontFamily != ffmt.fontFamily ||
							 fmt.fontSize != ffmt.fontSize ||
							 fmt.color != ffmt.color)) {
							
							var formattedText:String = s.substring(cindex, x);
							if (formattedText.length > 0 && formattedText != "\n") {
								
								var tspan:XML = new XML("<tspan/>");
								tspan.@["xml:space"] = 'preserve';
								
								parseTextProperties(fmt, tspan);
								
								if (cindex == 0 && l != 0) {
									tspan.@x = 0;
									tspan.@dy = (1.2 * ((list) ? 1 : lineSpaces)) + "em";
								}
								
								if (cindex == 0 || (ffmt && (fmt.textAlign != ffmt.textAlign))) {
									
									if (!beginAlign || cindex == 0) {
										parseTextAlignment(element, fmt, tspan);
										beginAlign = true;
									} else {
										beginAlign = false;
									}
									
								}
								
								if (list && (manualLineBreak || (start == 0 && cindex ==0))) {
									prefix = "&#8226;  ";
									manualLineBreak = false;
								} else {
									prefix = "";
								}
								
								tspan.appendChild(new XML(prefix + formattedText.replace(/\n/g, "")));
								text.appendChild(tspan);
								
								lineSpaces = 1;
							} 
							
							if (l != 0 && StringUtil.trim(formattedText).length == 0 && formattedText.indexOf("\n") != -1) {
								lineSpaces++;
							} else {
								lineSpaces = 1;
							}
							
							if (formattedText.lastIndexOf("\n") == formattedText.length - 1) {
								manualLineBreak = true;
							}
							
							cindex = x;
						}
					}
				}
				
				start += textline.rawTextLength;
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
			
			var width:Number = element.textInput.width;
			if (element.textInput.textDisplay is UIComponent) {
				width = UIComponent(element.textInput.textDisplay).width;
			}
			
			if (fmt.textAlign == TextAlign.LEFT) {
				tspan.@["text-anchor"] = "start";
			} else if (fmt.textAlign == TextAlign.CENTER) {
				tspan.@x = width / 2;
				tspan.@["text-anchor"] = "middle";
			} else if (fmt.textAlign == TextAlign.RIGHT) {
				tspan.@x = width;
				tspan.@["text-anchor"] = "end";
			}
		}
	}
}