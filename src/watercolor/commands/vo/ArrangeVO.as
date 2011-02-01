package watercolor.commands.vo
{
	import watercolor.execute.ArrangeExecute;

	/**
	 *  The ArrangeVO class stores the command data used by ArrangeExecute to execute and undo
	 *  an Arrange command.  The ArrangeVO can be stored and used by the HistoryManager.
	 * 
	 *  @see watercolor.managers.HistoryManager
	 *  @see watercolor.commands.execUtils.ArrangeExecute
	 *  
	 */
	public class ArrangeVO extends CommandVO
	{
		/**
		 * Constructor. 
		 * 
		 */
		public function ArrangeVO()
		{
			super();
			executeClass = ArrangeExecute;
		}

		/**
		 * The position the element is moved to.
		 */
		public var newPosition:Position;

		/**
		 * The original position the element was moved from; used to undo an arrange action.
		 */
		public var originalPosition:Position;
	}
}