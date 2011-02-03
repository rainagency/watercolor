package watercolor.factories.fxg.util
{
	import flash.utils.Dictionary;
	
	import watercolor.factories.fxg.ElementFactory;

	/**
	 * URIManager
	 * 
	 * Elements dictionary is used so that there are not multiple instances 
	 * of the same uri referenced element.
	 */ 
	public class URIManager
	{
		/**
		 * 
		 * @default 
		 */
		protected var _fxg:XML;
		/**
		 * 
		 * @default 
		 */
		protected var _folderLocation:String;

		/**
		 * Root fxg node that contains all nodes in the fxg.
		 */
		public function get fxg():XML
		{
			return _fxg;
		}

		/**
		 * @private
		 */
		public function set fxg(value:XML):void
		{			
			// Add xml namespace for E4X
			var xml_ns:Namespace = new Namespace("xml", "http://www.w3.org/XML/1998/namespace");
			value.addNamespace(xml_ns);
			_fxg = value;
		}
		
		/**
		 * Elements dictionary is used so that there are not multiple instances 
	 	 * of the same uri referenced element. 
		 * Key -> uri
		 * Value -> Object
		 */ 
		protected var elements:Dictionary;
		
		/**
		 * Constructor
		 * @param fxg Root svg node that contains all nodes in the fxg.
		 */ 
		public function URIManager(fxg:XML)
		{
			this.fxg = fxg;
			elements = new Dictionary();
		}
		
		/**
		 * Get URI Element
		 * @param uri node id we are looking for
		 * @return element that has the id of uri
		 */ 
		public function getURElement(uri:String):Object
		{
			// First check the elements dictionary
			if (elements && elements[uri])
			{
				return elements[uri];
			}
			
			// Find fxg node by uri id
			var searchResult:XMLList = fxg.*.(attribute("id") == uri);
			
			if (searchResult.length() == 0)
			{
				trace("Node with uri", uri, "not found");
				return null;
			}
			else
			{
				// Create Element from Factory
				var element:Object = ElementFactory.createSparkFromFXG(searchResult[0], this);
				
				// Add element to elements dictionary
				elements[uri] = element;
				
				return element;
			}
		}
	}
}