package watercolor.factories.svg
{
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.primitives.Rect;
	
	import watercolor.factories.svg.ElementFactory;
	import watercolor.factories.svg.util.SVGAttributes;
	import watercolor.factories.svg.util.URIManager;

	/**
	 * Spark Group Factory
	 * 
	 * SVG Documentation: http://www.w3.org/TR/SVG/struct.html#Groups
	 */ 
	public class GroupFactory
	{
		public function GroupFactory()
		{
		}
		
		/**
		 * Create Spark Group from SVG G element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Group = null):Group
		{
			if (!element)
			{
				element = new Group();
			}
			
			// id - identity
			// We set id here because groups don't run through another factory
			if (node.@id.length() > 0)
			{
				element.id = node.@id;
			}
			
			// Notice: SVG Groups can have fills and potentially other attributes
			//		   that spark doesn't support
			
			
			/////////////////////////////////////////////////////////
			// Detect Children, send child nodes to appropriate factory, add to group
			var qname:QName = new QName(null, "*");
			for each(var childNode:XML in node[qname])
			{
				var child:Object = ElementFactory.createSparkFromSVG(childNode, uriManager);
				
				// IVisualElements are added to the group via addElement
				if (child && child is IVisualElement)
				{
					element.addElement(IVisualElement(child));
				}
				// TODO: However, nodes like defs should be stored as special properties within Graphic (even though this is Group... figure this out)
//				else if (child && child is Defs?Library?)
//				{
//					
//				}
			}
			
			return element;
		}
		
		/**
		 * Create SVG nodes from Spark element
		 */ 
		public static function createSVGFromSpark(element:Group):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}