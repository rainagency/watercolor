package watercolor.factories.svg2
{
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import watercolor.elements.Element;
	import watercolor.elements.Group;
	import watercolor.elements.Layer;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.enums.ElementType;
	import watercolor.factories.svg2.util.SVGAttributes;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark Group Factory
	 * 
	 * SVG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/components/Group.html
	 */ 
	public class GroupFactory
	{
		public function GroupFactory()
		{
		}
		
		/**
		 * Create Spark Group from SVG element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Group = null):Group
		{
			if (!element)
			{
				element = new Group();
			}
			
			SVGAttributes.parseXMLAttributes(node, element);
			
			/////////////////////////////////////////////////////////
			// Detect Children, send child nodes to appropriate factory, add to group
			var qname:QName = new QName(null, "*");
			for each(var childNode:XML in node[qname])
			{
				var child:Object = ElementFactory.createSparkFromSVG(childNode, uriManager);
				
				// if the child isn't null
				if (child) {
					
					// if the child was a mask
					if (childNode.localName() == ElementType.MASK) 
					{
						element.mask = child as DisplayObject;
						element.addElement(IVisualElement(child));
					}
					
					// if the child was a group of filters
					else if (childNode.localName() == ElementType.FILTERS)
					{
						element.filters = child as Array;							
					}
					
					// IVisualElements are added to the group via addElement
					else if (child is Element)
					{
						element.addElement(IVisualElement(child));
						Element(child).childMatrix = child.transform.matrix;
					} 					
				}
			}
			
			element.mouseChildren = false;
			
			return element;
		}
		
		/**
		 * Create SVG nodes from Spark element
		 */ 
		public static function createSVGFromSpark(element:Element, workarea:Workarea):XML
		{
			var g:XML = new XML("<g/>");
			
			for (var x:int = 0; x < element.numElements; x++)
			{
				var elm:Element = element.getElementAt(x) as Element;
				g.appendChild(ElementFactory.createSVGFromSpark(elm, workarea));
			}
			
			return g;
		}
	}
}