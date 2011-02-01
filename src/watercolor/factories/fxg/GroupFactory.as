package watercolor.factories.fxg
{
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import watercolor.elements.Element;
	import watercolor.elements.Group;
	import watercolor.factories.fxg.enums.ElementType;
	import watercolor.factories.fxg.util.FXGAttributes;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Group Factory
	 * 
	 * FXG Documentation:
	 * Spark Documentation: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/spark/components/Group.html
	 */ 
	public class GroupFactory
	{
		public function GroupFactory()
		{
		}
		
		/**
		 * Create Spark Group from FXG element
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager, element:Group = null):Group
		{
			if (!element)
			{
				element = new Group();
			}
			
			FXGAttributes.parseXMLAttributes(node, element);
			
			/////////////////////////////////////////////////////////
			// Detect Children, send child nodes to appropriate factory, add to group
			var qname:QName = new QName(null, "*");
			for each(var childNode:XML in node[qname])
			{
				var child:Object = ElementFactory.createSparkFromFXG(childNode, uriManager);
				
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
		 * Create FXG nodes from Spark element
		 */ 
		public static function createFXGFromSpark(element:Group):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}