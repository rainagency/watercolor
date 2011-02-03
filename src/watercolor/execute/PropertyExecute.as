package watercolor.execute
{
	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.PropertyVO;
	import watercolor.elements.Element;

	/**
	 *  The PropertyExecute class contains the execute and undo functions used to execute
	 *  instances of PropertyVO
	 *
	 *  @see watercolor.commands.execUtils.IExecute
	 *  @see watercolor.commands.vo.PropertyVO
	 *
	 */
	public class PropertyExecute implements IExecute
	{
		/**
		 *  The execute method is called to execute a command stored in an PropertyVO
		 *  @param vo the PropertyVO to be executed
		 *
		 */
		public function execute(vo:CommandVO):void
		{
			var propertyVO:PropertyVO = vo as PropertyVO;
			setProperties(propertyVO.element, propertyVO.newProperties);
		}

		/**
		 *  The undo method is called to undo a command stored in a PropertyVO
		 *  @param vo the PropertyVO to be undone
		 *
		 */
		public function undo(vo:CommandVO):void
		{
			var propertyVO:PropertyVO = vo as PropertyVO;			
			setProperties(propertyVO.element, propertyVO.originalProperties);
		}
		
		/**
		 * Function for setting the properties on an element
		 * This is written so that the key can be specified as direct property or
		 * the property of a property.  An example of this would be to pass in 
		 * 'transform.matrix' as the key and an instance of the Matrix class as 
		 * the value.  
		 */ 
		private function setProperties(element:Object, properties:Object):void {
			
			// loop through each property
			for (var i:String in properties)
			{
				// split the property list
				var attribs:Array = i.split(".");
				
				// loop through each level and find the right child object
				if (attribs.length > 1) {
					var obj:Object = null;
					for (var x:int = 0; x < attribs.length - 1; x++) {						
						if (obj) {
							obj = obj[attribs[x]];
						} else {
							obj = element[attribs[x]];
						}
					}
					
					// set the attribute on the child object
					obj[attribs[attribs.length - 1]] = properties[i];					
				} else {
					
					// else the property is on the top level so set it here
					element[i] = properties[i];					
				}
			}
		}
	}
}