package watercolor.events
{
	import flash.events.Event;

	/**
	 * @author mediarain
	 */
	public class TextEvent extends Event
	{
		
		/**
		 * 
		 * @default 
		 */
		static public const EVENT_TEXT_MODIFIED:String = "eventLetterLoaded";
		
		public static const EVENT_TEXT_AREA_CHANGED:String = "eventTextAreaChanged";
		
		public var oldText:String = "";
		
		/**
		 * 
		 */
		public function TextEvent(type:String, oldText:String = "")
		{
			super(type, false, false);
			this.oldText = oldText;
		}

		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new TextEvent(type, oldText);
		}

	}
}