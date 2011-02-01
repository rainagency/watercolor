package watercolor.events
{
	import flash.events.Event;

	import watercolor.managers.HistoryManager;


	public class HistoryManagerEvent extends Event
	{

		/**
		 * The <code>HistoryManagerEvent.REDO</code> constant defines the <code>type</code>
		 * property of the event object for a <code>changing</code> event,
		 * which indicates the commandVO should be executed
		 */
		public static const REDO:String = 'historyManagerEventRedo';


		/**
		 * The <code>HistoryManagerEvent.UNDO</code> constant defines the <code>type</code>
		 * property of the event object for a <code>changing</code> event, which indicates
		 * the commandVO should be undone.
		 */
		public static const UNDO:String = 'historyManagerEventUndo';


		/**
		 * Indicated when the HistoryManager's current index has changed.
		 */
		public static const INDEX_CHANGE:String = 'historyManagerEventIndexChange';


		/**
		 * Indicated when a new CommandVO has been added to the HistoryManager.
		 */
		public static const COMMAND_ADDED:String = 'historyManagerEventCommandAdded';


		/**
		 * Indicated when a new CommandVO has been removed from the HistoryManager.
		 */
		public static const COMMAND_REMOVED:String = 'historyManagerEventCommandRemoved';


		public var historyManager:HistoryManager;


		public function HistoryManagerEvent( type:String, historyManager:HistoryManager )
		{
			this.historyManager = historyManager;
			super( type, false, false );
		}


		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new HistoryManagerEvent( type, historyManager );
		}
	}
}