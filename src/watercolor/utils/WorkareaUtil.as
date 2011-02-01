package watercolor.utils {
	
	import watercolor.elements.components.Workarea;

	/**
	 * Utility to help with Workarea(s)
	 * 
	 * @author SeanT23
	 */
	public class WorkareaUtil {
		/**
		 * Helper function to return a element's Workarea (if any)
		 * 
		 * @param element Object to try to find Workarea from
		 * 
		 * @return Workarea found(null if none)
		 */
		public static function getWorkarea(element:*):Workarea {			
			while(element.hasOwnProperty('uid')) {
				if(element is Workarea) {
					return element;
				}
				
				element = element.parent;
			}
			
			return null;
		}
	}
}