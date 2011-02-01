package watercolor.factories.fxg
{
	import watercolor.elements.Element;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Element Factory
	 */ 
	public class MaskFactory
	{
		/**
		 * Create a mask from FXG element
		 * @param object Created object.  Could be anything from a LinearGradient to a Group. 
		 * 				 
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager):Object
		{
			var element:Element = ElementFactory.createSparkFromFXG(node.children()[0], uriManager) as Element;
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
		 * Create FXG from Spark Object
		 */ 
		public static function createFXGFromSpark(element:Object):XML
		{
			// TODO: Generate FXG
			return null;
		}
	}
}