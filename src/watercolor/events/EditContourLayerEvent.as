package watercolor.events
{
	import flash.events.Event;
	
	import watercolor.commands.vo.CommandVO;


	/**
	 *
	 * @author mediarain
	 */
	public class EditContourLayerEvent extends Event
	{
		/**
		 *
		 *
		 */
		static public const CONTOUR_HIDDEN:String = "eventContourHidden";


		static public const CONTOUR_UNHIDDEN:String = "eventContourUnHidden";


		public var commandVO:CommandVO;


		/**
		 *
		 */
		public function EditContourLayerEvent( type:String, commandVO:CommandVO )
		{
			super( type, false, false );
			this.commandVO = commandVO;
		}


		/**
		 * Overriden <code>clone()</code> method used to clone event; commonly used in bubbling.
		 */
		override public function clone():Event
		{
			return new EditContourLayerEvent( type, commandVO );
		}

	}
}