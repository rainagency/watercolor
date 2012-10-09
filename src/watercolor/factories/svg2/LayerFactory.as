package watercolor.factories.svg2
{
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import watercolor.elements.Element;
	import watercolor.elements.Group;
	import watercolor.elements.Layer;
	import watercolor.elements.Text;
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
	public class LayerFactory
	{
		public function LayerFactory()
		{
		}
		
		/**
		 * Create Spark Group from SVG element
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager, element:Layer = null):Layer
		{
			return null;
		}
		
		/**
		 * Create SVG nodes from Spark element
		 */ 
		public static function createSVGFromSpark(node:XML, element:Element, workarea:Workarea):void
		{
			// loop through all the layers
			for (var x:int = 0; x < element.numElements; x++)
			{
				var elm:Element = element.getElementAt(x) as Element;
				node.appendChild(ElementFactory.createSVGFromSpark(elm, workarea));
			}
		}
	}
}