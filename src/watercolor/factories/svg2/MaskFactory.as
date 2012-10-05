package watercolor.factories.svg2
{
	import watercolor.elements.Element;
	import watercolor.elements.components.Workarea;
	import watercolor.factories.svg2.util.URIManager;
	
	/**
	 * Spark Element Factory
	 */ 
	public class MaskFactory
	{
		/**
		 * Create a mask from SVG element
		 * @param object Created object.  Could be anything from a LinearGradient to a Group. 
		 * 				 
		 */ 
		public static function createSparkFromSVG(node:XML, uriManager:URIManager):Object
		{
			var element:Element = ElementFactory.createSparkFromSVG(node.children()[0], uriManager) as Element;
			element.mouseEnabled = false;
			
			checkChildren(element);
			
			return element;
		}
		
		private static function checkChildren(element:Element):void {
			
			for (var x:int = 0; x < element.numChildren; x++) {				
				var child:Element = element.getChildAt(x) as Element;				
				child.mouseEnabled = false;				
				checkChildren(child);				
			}			
		}
		
		/**
		 * Create SVG from Spark Object
		 */ 
		public static function createSVGFromSpark(element:Object, workarea:Workarea):XML
		{
			// TODO: Generate SVG
			return null;
		}
	}
}