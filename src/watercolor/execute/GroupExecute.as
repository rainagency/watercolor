package watercolor.execute
{
	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.GroupCommandVO;
	import watercolor.utils.ExecuteUtil;

	/**
	 *  The GroupExecute class contains the execute and undo functions used to execute
	 *  GroupCommandVOs
	 * 
	 *  @see watercolor.commands.execUtils.IExecute
	 *  @see watercolor.commands.vo.GroupCommandVO
	 *  
	 */
	public class GroupExecute implements IExecute
	{

		/**
		 *  The execute method is called to execute all the commands stored in an GroupCommandVO 
		 *  @param vo the GroupCommandVO to be executed
		 * 
		 */
		public function execute(vo:CommandVO):void
		{
			var groupVO:GroupCommandVO = vo as GroupCommandVO;
			for each (var commandVO:CommandVO in groupVO.commands)
			{
				ExecuteUtil.execute(commandVO);
			}
		}

		/**
		 *  The undo method is called to undo a command stored in an GroupCommandVO 
		 *  @param vo the GroupCommandVO to be undone
		 * 
		 */
		public function undo(vo:CommandVO):void
		{
			var groupVO:GroupCommandVO = vo as GroupCommandVO;
			for (var i:int = groupVO.commands.length - 1; i >= 0; i--)
			{
				var element:CommandVO = groupVO.commands[i] as CommandVO;
				ExecuteUtil.undo(element);
			}
		}
	}
}