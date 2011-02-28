package watercolor.events
{
	import flash.events.Event;

	import watercolor.elements.Element;


	/**
	 *
	 * @author mediarain
	 */
	public class SelectionManagerEvent extends Event
	{

		/**
		 * Event to indicate that an item has been added to the selection manager
		 * @default
		 */
		static public const ELEMENT_ADDED:String = "eventElementAdded";


		/**
		 * Event to indicate that an item has been removed from the selection manager
		 * @default
		 */
		static public const ELEMENT_REMOVED:String = "eventElementRemoved";


		/**
		 * Event to indicate that a group of items have been set in the selection manager
		 * @default
		 */
		static public const ELEMENTS_ADDED:String = "eventElementsAdded";


		/**
		 * Event to indicate that all items from the selection manager have been removed
		 * @default
		 */
		static public const ELEMENTS_REMOVED:String = "eventElementsRemoved";
		
		
		/**
		 * Event to indicate that the selection layer has been update and may have removed some elements
		 * @default
		 */
		static public const ELEMENTS_UPDATE:String = "eventElementsUpdate";


		/**
		 * Event to indicate that the selection layer has been updated and may have removed some elements
		 * @default
		 */
		static public const ELEMENTS_UPDATE_COMPLETE:String = "eventElementsUpdated";


		/**
		 *
		 * @default
		 */
		public var elements:Vector.<Element>;


		/**
		 *
		 * @param type
		 * @param elements
		 */
		public function SelectionManagerEvent( type:String, elements:Vector.<Element> )
		{
			super( type, false, false );
			this.elements = elements;
		}


		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new SelectionManagerEvent( type, elements );
		}

	}
}