package watercolor.events
{
	import flash.events.Event;


	public class ElementSelectionEvent extends Event
	{
		/**
		 * Event to indicate that an element has been selected by the Selection Manager.
		 *
		 * @see com.watercolor.managers.SelectionManager
		 */
		static public const ELEMENT_SELECTED:String = "waterColorElementSelected";


		/**
		 * Event to indicate that an element has been deselected by the Selection Manager.
		 *
		 * @see com.watercolor.managers.SelectionManager
		 */
		static public const ELEMENT_DESELECTED:String = "waterColorElementDeselected";


		/**
		 * Constructor
		 *
		 * @param type Event Type
		 */
		public function ElementSelectionEvent( type:String )
		{
			super( type, false, false );
		}


		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new ElementSelectionEvent( type );
		}
	}
}