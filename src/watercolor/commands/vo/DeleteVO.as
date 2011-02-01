package watercolor.commands.vo
{
	import watercolor.execute.DeleteExecute;

	import watercolor.elements.Element;


	/**
	 *  The DeleteVO class stores the command data used by DeleteExecute to execute and undo
	 *  a delete command.  The DeleteVO can be stored and used by the HistoryManager.
	 *
	 *  @see watercolor.managers.HistoryManager
	 *  @see watercolor.commands.execUtils.DeleteExecute
	 *
	 */
	public class DeleteVO extends CommandVO
	{
		/**
		 * Constructor.
		 *
		 * @param element Element to delete
		 * @param position Position to delete element from.
		 */
		public function DeleteVO( element:Element = null, position:Position = null )
		{
			super();
			this.element = element;
			this.position = position;

			executeClass = DeleteExecute;
		}


		/**
		 * The original position of the element before it is deleted
		 */
		public var position:Position;
	}
}