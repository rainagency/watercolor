package watercolor.events
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import watercolor.commands.vo.CommandVO;
	import watercolor.elements.Element;


	/**
	 * Isolation Layer Events
	 *
	 * @see watercolor.elements.components.IsolationLayer
	 *
	 * @author mediarain
	 */
	public class IsolationLayerEvent extends LayerTransformEvent
	{
		/**
		 * Dispatched when a composite glyph is separated while in isolation mode
		 * @default 
		 */
		static public const GLYPH_SEPERATED:String = "eventGlyphSeperated";


		/**
		 * Dispatch when a composite glyph is combined while in isolation mode
		 * @default 
		 */
		static public const GLYPH_COMBINED:String = "eventGlyphCombined";


		/**
		 * Dispatched when entering isolation mode
		 * @default 
		 */
		static public const ENTER_ISOLATION_MODE:String = "enterIsolationMode";


		/**
		 * Dispatch when exiting a level in isolation mode
		 * @default 
		 */
		static public const EXIT_ISOLATION_MODE_LEVEL:String = "exitIsolationModeLevel";


		/**
		 * Dispatched when entering edit contour mode
		 * @default 
		 */
		static public const ENTER_EDIT_CONTOUR_MODE:String = "enterEditContourMode";


		/**
		 * Dispatched when exiting a level from edit contour mode
		 * @default 
		 */
		static public const EXIT_EDIT_CONTOUR_MODE_LEVEL:String = "exitEditContourModeLevel";
		
		
		/**
		 * Dispatched when completely exiting out of isolation mode
		 * @default 
		 */
		static public const EXIT_ISOLATION_MODE:String = "exitIsolationMode";


		/**
		 *
		 */
		public function IsolationLayerEvent( type:String, transformations:Dictionary = null, elements:Vector.<Element> = null )
		{
			super(type, transformations, elements);
		}


		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new IsolationLayerEvent( type, transformations, elements );
		}

	}
}