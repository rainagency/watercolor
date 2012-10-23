package watercolor.factories.svg2
{
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowGroupElement;
	import flashx.textLayout.elements.ListElement;
	import flashx.textLayout.elements.ListItemElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.ListMarkerFormat;
	import flashx.textLayout.formats.ListStylePosition;
	import flashx.textLayout.formats.ListStyleType;
	import flashx.textLayout.formats.TextAlign;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	
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
		
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Text = null):Text
		{
			if (!element) {
				
				element = new Text();
				element.textFlow = new TextFlow();
			}
			
			var listElm:ListElement;
			var par:ParagraphElement;
			var blank:SpanElement;
			var parent:FlowGroupElement;
			var first:ListItemElement;
			
			var list:Boolean = false;
			if (node.@islist && node.@islist.toString().toLowerCase() == "true") {
				
				list = true;
				
				listElm = new ListElement();
				listElm.listStyleType = ListStyleType.DISC;
				listElm.listStylePosition = ListStylePosition.INSIDE;
				listElm.listAutoPadding = 0;
				listElm.textIndent = 0;
				
				var format:ListMarkerFormat = new ListMarkerFormat();
				format.afterContent = "  ";
				
				listElm.listMarkerFormat = format;
				
				element.textFlow.addChild(listElm);
				
			} 
			
			for each (var child:XML in node.children()) {	
				
				if (listElm && child.@listItem && child.@listItem.toString().length > 0) {
					
					first = new ListItemElement();
					listElm.addChild(first);
					
					parent = first;
					
				} else if (!list) {
					
					parent = element.textFlow;
				}
				
				// take care of blank lines
				if (child.@dy && child.@dy.toString().length > 0 && child.@x && child.@x.toString().length > 0) {
					
					try {
						
						var dy:String = child.@dy.toString();
						for (var b:int = 1; b < (Number(dy.substr(0, dy.length - 2)) / 1.2); b++) {
							
							par = new ParagraphElement();
							blank = new SpanElement();
							par.addChild(blank);
							parent.addChild(par);
						}
						
						par = new ParagraphElement();
						parent.addChild(par);
						
					} catch (err:Error) {
						// don't do anything
					}
				}
				
				var elm:Object = ElementFactory.createSparkFromSVG(child, uriManager);
				
				if (elm is FlowElement) {
					
					if (!par) {
						par = new ParagraphElement();
						parent.addChild(par);
					}
					
					// set the alignment on the line
					if (child.@["text-anchor"] && child.@["text-anchor"].toString().length > 0) {
						
						switch (child.@["text-anchor"].toString()) {
							
							case "start":
								par.textAlign = TextAlign.LEFT;
								break;
							case "middle":
								par.textAlign = TextAlign.CENTER;
								break;
							case "end":
								par.textAlign = TextAlign.RIGHT;
								break;
							
						}
					}
					
					par.addChild(FlowElement(elm));
				}
				
			}
			
			element.textInput.callLater(parseAttributes, [element, node]);
			
			return element;
		}
		
		protected static function parseAttributes(element:Text, node:XML):void {
			SVGAttributes.parseXMLAttributes(node, element);
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