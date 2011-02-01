package watercolor.execute
{
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.CreateVO;

	/**
	 *  The CreateExecute class contains the execute and undo functions used to execute
	 *  create commands
	 *
	 *  @see watercolor.commands.execUtils.IExecute
	 *  @see watercolor.commands.vo.CreateVO
	 *
	 */
	public class CreateExecute implements IExecute
	{
		/**
		 *  The execute method is called to execute a command stored in a create command
		 *  @param vo the CreateVO to be executed
		 * 
		 */
		public function execute(vo:CommandVO):void
		{
			var createVO:CreateVO = vo as CreateVO;
			IVisualElementContainer(createVO.position.parent).addElementAt(createVO.element as IVisualElement,
																		   createVO.position.index);
		}

		/**
		 *  The undo method is called to undo a command stored in a create command
		 *  @param vo the CreateVO to be executed
		 * 
		 */
		public function undo(vo:CommandVO):void
		{
			var createVO:CreateVO = vo as CreateVO;
			IVisualElementContainer(createVO.position.parent).removeElement(createVO.element as IVisualElement);
		}
	}
}