package watercolor.commands.vo
{
	import watercolor.execute.PropertyExecute;
	
	/**
	 *  The PropertyVO class stores the command data used by PropertyExecute to execute and undo
	 *  a property change command.  The PropertyVO can be stored and used by the HistoryManager.
	 *
	 *  @see watercolor.managers.HistoryManager
	 *  @see watercolor.commands.execUtils.PropertyExecute
	 *
	 */
	public class PropertyVO extends CommandVO
	{
		/**
		 * Constructor.
		 *
		 */
		public function PropertyVO()
		{
			super();
			executeClass = PropertyExecute;
		}

		/**
		 * an object containing the key/value pairs of the properties on the element that will
		 * be changed
		 */
		public var newProperties:Object;

		/**
		 * an object containing the original key/value pairs of the properties on the element that
		 * were originally changed
		 */
		public var originalProperties:Object;
	}
}