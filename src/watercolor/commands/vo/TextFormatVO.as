package watercolor.commands.vo
{
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import watercolor.execute.ArrangeExecute;
	import watercolor.execute.TextFormatExecute;

	/**
	 *  The TextFormatVO class stores the command data used by TextFormatExecute to execute and undo
	 *  an TextFormat command.  The TextFormatVO can be stored and used by the HistoryManager.
	 * 
	 *  @see watercolor.managers.HistoryManager
	 *  @see watercolor.commands.execUtils.ArrangeExecute
	 *  
	 */
	public class TextFormatVO extends CommandVO
	{
		/**
		 * Constructor. 
		 * 
		 */
		public function TextFormatVO()
		{
			super();
			executeClass = TextFormatExecute;
		}

		/**
		 * 
		 * @default 
		 */
		public var newFmt:TextLayoutFormat;
		
		/**
		 * 
		 * @default 
		 */
		public var oldFmt:TextLayoutFormat;
		
		/**
		 * 
		 * @default 
		 */
		public var start:int;
		
		/**
		 * 
		 * @default 
		 */
		public var end:int;
	}
}