package watercolor.events
{
	import flash.events.Event;
	
	import watercolor.elements.Element;

	/**
	 * This is an event that must be used by the class that implements the ITextGroup interface
	 * This event is used to tell the text group element that a letter has been loaded
	 * @author mediarain
	 */
	public class TextGroupEvent extends Event
	{
		
		/**
		 * 
		 * @default 
		 */
		static public const EVENT_LETTER_LOADED:String = "eventLetterLoaded";
		
		/**
		 * 
		 * @default 
		 */
		static public const RENDER:String = "eventRender";
		/**
		 * 
		 * @default 
		 */
		static public const LAYOUT:String = "eventLayout";
		/**
		 * 
		 * @default 
		 */
		static public const CHANGE:String = "eventChange";
		/**
		 * 
		 * @default 
		 */
		static public const REPLACE:String = "eventReplace";
		
		/**
		 * 
		 * @default 
		 */
		public var letter:Element;
		
		/**
		 * 
		 */
		public function TextGroupEvent(type:String, letter:Element = null)
		{
			super(type, false, false);
			this.letter = letter;
		}

		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new TextGroupEvent(type, letter);
		}

	}
}