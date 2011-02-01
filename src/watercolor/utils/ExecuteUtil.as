package watercolor.utils
{
	import watercolor.execute.IExecute;
	import watercolor.commands.vo.CommandVO;

	/**
	 * A convenient utility that is used to execute and undo commands stored in a CommandVO
	 * 
	 * @see watercolor.commands.vo.CommandVO
	 * @see watercolor.commands.ExecuteClasses.IExecute
	 */
	public class ExecuteUtil
	{
		/**
		 * using the executeClass on a CommandVO executes the command
		 * @param vo
		 * 
		 */
		public static function execute(vo:CommandVO):void
		{
			var executeClass:IExecute = new vo.executeClass();
			executeClass.execute(vo);
		}

		/**
		 * using the executeClass on a CommandVO undoes the command
		 * @param vo
		 * 
		 */
		public static function undo(vo:CommandVO):void
		{
			var executeClass:IExecute = new vo.executeClass();
			executeClass.undo(vo);
		}
	}
}