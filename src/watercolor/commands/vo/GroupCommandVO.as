package watercolor.commands.vo
{
	import watercolor.execute.GroupExecute;

	/**
	 *  The GroupCommandVO class stores multiple CommandVOs. It is used to combine multiple
	 *  commands on a single element or multiple elements that can be executed and undone
	 *  together. The GroupCommandVO can be stored and used by the HistoryManager.
	 *
	 *  @see watercolor.managers.HistoryManager
	 *  @see watercolor.commands.execUtils.GroupExecute
	 *
	 */
	public class GroupCommandVO extends CommandVO
	{

		/**
		 * Constructor.
		 * 
		 */
		public function GroupCommandVO()
		{
			super();
			executeClass = GroupExecute;
		}

		/**
		 * The commands property stores the grouped commands that are executed and undo together.
		 * Commands are executed in ascending order and undone in descending order.
		 */
		public var commands:Vector.<CommandVO> = new Vector.<CommandVO>;

		/**
		 * A function to more easily add commands to the commands vector.
		 * @param command
		 * 
		 */
		public function addCommand(command:CommandVO):void
		{
			commands.push(command);
		}
	}
}