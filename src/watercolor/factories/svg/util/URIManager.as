package watercolor.factories.svg.util
{
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	
	import watercolor.factories.svg.ElementFactory;

	/**
	 * URIManager
	 * 
	 * Passed into Factories so that fills and strokes that use a URI 
	 * can be created successfully.
	 * 
	 * Elements dictionary is used so that there are not multiple instances 
	 * of the same uri referenced element.
	 */ 
	public class URIManager
	{
		protected var _svg:XML;

		/**
		 * Root svg node that contains all nodes in the svg.
		 */
		public function get svg():XML
		{
			return _svg;
		}

		/**
		 * @private
		 */
		public function set svg(value:XML):void
		{			
			// Add xml namespace for E4X
			var xml_ns:Namespace = new Namespace("xml", "http://www.w3.org/XML/1998/namespace");
			value.addNamespace(xml_ns);
			_svg = value;
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
		 * @param svg Root svg node that contains all nodes in the svg.
		 */ 
		public function URIManager(svg:XML)
		{
			this.svg = svg;
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
			
			// Find svg node by uri id
			var searchResult:XMLList = svg.*.(attribute( "id" ) == uri);
			
			if (searchResult.length() == 0)
			{
				trace("Node with uri", uri, "not found");
				return null;
			}
			else
			{
				// Create Element from Factory
				var element:Object = ElementFactory.createSparkFromSVG(searchResult[0], this);
				
				// Add element to elements dictionary
				elements[uri] = element;
				
				return element;
			}
		}
	}
}