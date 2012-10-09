package watercolor.factories.svg2
{
	import flash.text.engine.FontWeight;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import watercolor.elements.Element;
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
			
			var start:int = 0;
			var end:int = 0;
			
			var text:String = "";
			var array:Array = new Array();
			
			for each (var child:XML in node.children()) {					
				
				if (child.localName() == "tspan") {
					
					if (child.children().length() > 0) {
						
						if (child.@dy != null && child.@dy.toString().length > 0) {
							text += "\n";
						}
						
						start = text.length;
						
						text += child.children()[0];
						
						end = text.length;
						
						array.push({start:start, end:end, node:child});
					}
				}			
			}
			
			element.text = text;
			
			element.textInput.callLater(setTSpans, [array, uriManager, element]);
			
			// set any attributes
			SVGAttributes.parseXMLAttributes(node, element);
			
			return element;
		}
		
		protected static function setTSpans(array:Array, uriManager:URIManager, element:Text):void {
			
			for each (var obj:Object in array) {
				
				try {
					
					TSpanFactory.createSparkFromSVG(obj.node, uriManager, element, obj.start, obj.end);
					
				} catch (err:Error) {
					
					trace("Cannot create child " + obj.node.localName() + " on " + element.toString());
				}
				
			}
		}
		
		public static function createSVGFromSpark(element:Text, workarea:Workarea):XML
		{
			var text:XML = new XML("<text/>");
			text.@dy = "0.71em";
			text.@["text-anchor"] = "start";
			text.@transform = SVGAttributes.parseMatrix(element.transform.matrix);
			
			TSpanFactory.createSVGFromSpark(text, element, workarea);
			
			return text;
			
		}
	}
}