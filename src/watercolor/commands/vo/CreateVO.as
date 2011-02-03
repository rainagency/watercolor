package watercolor.commands.vo
{
	import watercolor.execute.CreateExecute;
	
	import watercolor.elements.Element;

	/**
	 *  The CreateVO class stores the command data used by CreateExecute to execute and undo
	 *  a create command.  The CreateVO can be stored and used by the HistoryManager.
	 *
	 *  @see watercolor.managers.HistoryManager
	 *  @see watercolor.commands.execUtils.CreateExecute
	 *
	 */
	public class CreateVO extends CommandVO
	{
		/**
		 * Constructor.
		 * 
		 * @param Element element to add to position
		 * @param Position position to add element to
		 */
		public function CreateVO(element:Element=null, position:Position=null)
		{
			super();
			executeClass = CreateExecute;
			
			this.element = element;
			this.position = position;
		}

		/**
		 * The position at which the created element is added.
		 */
		public var position:Position;
	}
}