package watercolor.factories.svg2
{
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ListItemElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.ListMarkerFormat;
	import flashx.textLayout.formats.ListStylePosition;
	import flashx.textLayout.formats.ListStyleType;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
	import spark.components.RichEditableText;
	
	import watercolor.elements.Text;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Text Factory
	 * 
	 * SVG Documentation: 
	 * Spark Documentation: 
	 */ 
	public class TextAreaFactory
	{
		/**
		 * 
		 */
		public function TextAreaFactory()
		{
		}
		
		/**
		 * 
		 * @param node
		 * @param uriManager
		 * @param element
		 * @return 
		 */
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Text = null):Text
		{
			if (!element)
			{
				element = new Text();
			}
			
			var start:int = 0;
			var end:int = 0;
			
			var text:String = "";
			var txt:String = "";
			var array:Array = new Array();
			
			var listItem:Boolean = false;
			var list:Boolean = false;
			if (node.@islist && node.@islist.toString().toLowerCase() == "true") {
				list = true;
			}
			
			for each (var child:XML in node.children()) {					
				
				if (child.localName() == "tspan") {
					
					listItem = (child.@listItem && child.@listItem.toString().toLowerCase() == "true") ? true : false;
					
					if (child.children().length() > 0) {
						
						txt = "";
						
						if (text.length > 0 && child.@dy != null && child.@dy.toString().length > 0) {
							
							try {
								
								var dy:String = child.@dy.toString();
								for (var b:int = 0; b < (Number(dy.substr(0, dy.length - 2)) / 1.2); b++) {
									text += ((list && !listItem) ? "" : SVGAttributes.LINE_BREAK);
								}
								
							} catch (err:Error) {
								// don't do anything
							}
						}
						
						start = text.length;
						
						txt += child.children()[0].toString();
						txt = (list && listItem) ? txt.substring(3, txt.length) : txt;
						
						text += txt;
						
						end = text.length;
						
						array.push({start:start, end:end, node:child, text:txt, listItem:listItem});
					}
				}			
			}
			
			if (!list) {
				element.text = text;
				element.textInput.callLater(setTSpans, [array, uriManager, element, node]);
			} else {
				element.text = "";
				element.textInput.callLater(setListTSpans, [array, uriManager, element, node]);
			}
			
			return element;
		}
		
		/**
		 * 
		 * @param array
		 * @param uriManager
		 * @param element
		 * @param node
		 */
		protected static function setListTSpans(array:Array, uriManager:URIManager, element:Text, node:XML):void {
			
			var check:TextFlow = RichEditableText(element.textInput.textDisplay).textFlow;
			check.removeChildAt(0);
			
			var listElm:ListElement = new ListElement();
			listElm.listStyleType = ListStyleType.DISC;
			listElm.listStylePosition = ListStylePosition.INSIDE;
			listElm.listAutoPadding = 0;
			listElm.textIndent = 0;
			
			var format:ListMarkerFormat = new ListMarkerFormat();
			format.afterContent = "  ";
			
			listElm.listMarkerFormat = format;
			
			check.addChild(listElm);
			
			var txt:String = "";
			var first:ListItemElement;
			var p:ParagraphElement;
			var s:SpanElement;
			var obj:Object;
			var objNext:Object;
			
			var next:Boolean = false;
			
			for (var x:int = 0; x < array.length; x++) {
				
				obj = array[x];
			
				if (obj.listItem) {
					txt = obj.text;
				} else {
					txt += obj.text;
				}
				
				if (x < (array.length - 1)) {
					
					objNext = array[x + 1];
					
					if (objNext.listItem) {
						next = true;
					} else {
						next = false;
					}
					
				} else {
					next = false;
				}
				
				if (next || x == (array.length - 1)) {
					
					if (check.getChildAt(0) is ListElement) {
						
						first = new ListItemElement();
						p = new ParagraphElement();
						s = new SpanElement();
						
						s.text = txt;
						p.addChild(s);
						first.addChild(p);
						
						ListElement(check.getChildAt(0)).addChild(first);
						
						txt = "";
					}
				}
			}
			
			element.textInput.callLater(setTSpans, [array, uriManager, element, node]);
		}
		
		/**
		 * 
		 * @param array
		 * @param uriManager
		 * @param element
		 * @param node
		 */
		protected static function setTSpans(array:Array, uriManager:URIManager, element:Text, node:XML):void {
			
			for each (var obj:Object in array) {
				
				try {
					
					TSpanFactory.createSparkFromSVG(obj.node, uriManager, element, obj.start, obj.end);
					
					// set any attributes
					SVGAttributes.parseXMLAttributes(node, element);
					
				} catch (err:Error) {
					
					trace("Cannot create child " + obj.node.localName() + " on " + element.toString());
				}
				
			}
		}
		
		/**
		 * 
		 * @param element
		 * @param workarea
		 * @return 
		 */
		public static function createSVGFromSpark(element:Text, workarea:Workarea):XML
		{
			var text:XML = new XML("<text/>");
			text.@["text-anchor"] = "start";
			
			var manager:TextContainerManager = element.textInput.textDisplay.mx_internal::textContainerManager;
			var extraHeight:int = 0;
			if (manager.numLines > 0) {
				extraHeight = manager.getLineAt(0).height;
			}
			
			with (element.transform) {
				text.@transform = "matrix(" + matrix.a + " " + matrix.b + " " + matrix.c + " " + matrix.d + " " + matrix.tx + " " + (matrix.ty + extraHeight) + ")";
				text.@as3transform = SVGAttributes.parseMatrix(matrix);
			}
			
			var list:Boolean = false;
			if (element.textInput.textFlow.getChildAt(0) is ListElement) {
				list = true;
			}
			
			text.@islist = list;
			
			TSpanFactory.createSVGFromSpark(text, element, workarea, list);
			
			var width:Number = element.textInput.explicitWidth;
			if (element.textInput.textDisplay is UIComponent) {
				width = UIComponent(element.textInput.textDisplay).explicitWidth
			}
			
			if (!(isNaN(width))) {
				text.@textWidth = width;
			}
			
			return text;
			
		}
	}
}