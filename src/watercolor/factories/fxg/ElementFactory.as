package watercolor.factories.fxg
{
	import watercolor.factories.fxg.util.FXGClassFactoryManager;
	import watercolor.factories.fxg.util.URIManager;

	/**
	 * Spark Element Factory
	 */ 
	public class ElementFactory
	{
		/**
		 * Create Spark Element from FXG element
		 * @param object Created object.  Could be anything from a LinearGradient to a Group. 
		 * 	
		 */ 
		public static function createSparkFromFXG(node:XML, uriManager:URIManager):Object
		{
			// Get FXG NodeName i.e. "Path" from <Path />
			// All node name enumerations are lowercase.  i.e. Change Group to group
			var fxgNodeName:String = node.localName().toString();
			fxgNodeName = fxgNodeName.toLowerCase(); 
			
			// Get Spark Factory
			var elementFactory:Class = FXGClassFactoryManager.getClassFactory(fxgNodeName);
			
			// Create Element
			if (elementFactory)
			{
				var element:Object = elementFactory.createSparkFromFXG(node, uriManager);
			}
			
			return element;
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