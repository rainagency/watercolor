package watercolor.execute
{
	import watercolor.commands.vo.CommandVO;

	/**
	 * The IExecute interface enforces the execute and undo methods used by the ExecuteUtil
	 * to execute and undo commands.
	 *
	 */
	public interface IExecute
	{
		/**
		 * Method used to execute a command
		 * @param vo
		 *
		 */
		function execute(vo:CommandVO):void;

		/**
		 * Method used to undo a command
		 * @param vo
		 *
		 */
		function undo(vo:CommandVO):void;
	}
}