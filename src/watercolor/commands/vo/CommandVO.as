package watercolor.commands.vo
{
	import watercolor.elements.Element;


	/**
	 *  The CommandVO class stores the command data used by a command to execute and undo
	 *  a command.  CommandVOs can be stored and used by the HistoryManager.
	 *
	 *  @see watercolor.managers.HistoryManager
	 *
	 */
	public class CommandVO
	{
		protected var _element:Element;


		//TODO: Find a way to enforce the IExecute Interface.
		/**
		 * The class, that implements IExecute, containing the execute and undo actions used
		 * by a command to execute the VO.
		 */
		public var executeClass:Class;


		/**
		 * The element which is the target of the action.
		 */
		public function get element():Element
		{
			return _element;
		}


		/**
		 * @private
		 */
		public function set element( value:Element ):void
		{
			_element = value;
		}

	}
}