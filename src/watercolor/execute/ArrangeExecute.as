package watercolor.execute
{
	import mx.core.IVisualElement;
	
	import watercolor.commands.vo.ArrangeVO;
	import watercolor.commands.vo.CommandVO;

	/**
	 *  The ArrangeExecute class contains the execute and undo functions used to execute
	 *  ArrangeCommands
	 * 
	 *  @see watercolor.commands.execUtils.IExecute
	 *  @see watercolor.commands.vo.ArrangeVO
	 *  
	 */
	public class ArrangeExecute implements IExecute
	{
		/**
		 *  The execute method is called to execute a command stored in an ArrangeCommand 
		 *  @param vo the ArrangeVO to be executed
		 */
		public function execute(vo:CommandVO):void
		{			
			var arrangeVO:ArrangeVO = vo as ArrangeVO;
			arrangeVO.originalPosition.parent.removeElement(arrangeVO.element as IVisualElement);
			arrangeVO.newPosition.parent.addElementAt(arrangeVO.element as IVisualElement, arrangeVO.
													  newPosition.index);
		}

		/**
		 *  The undo method is called to undo a command stored in an ArrangeCommand 
		 *  @param vo the ArrangeVO to be undone
		 */
		public function undo(vo:CommandVO):void
		{			
			var arrangeVO:ArrangeVO = vo as ArrangeVO;
			arrangeVO.newPosition.parent.removeElement(arrangeVO.element as IVisualElement);
			arrangeVO.originalPosition.parent.addElementAt(arrangeVO.element as IVisualElement, arrangeVO.
														   originalPosition.index);
		}
	}
}