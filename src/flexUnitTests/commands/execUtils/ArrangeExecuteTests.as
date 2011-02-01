package flexUnitTests.commands.execUtils
{
	import flexunit.framework.Assert;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import watercolor.utils.ExecuteUtil;
	import watercolor.commands.vo.ArrangeVO;
	import watercolor.commands.vo.Position;
	import watercolor.elements.Group;
	import watercolor.elements.Element;
	import watercolor.elements.Rect;

	public class ArrangeExecuteTests
	{
		public var element:Element;

		public var parentOne:IVisualElementContainer;

		public var parentTwo:IVisualElementContainer;

		public var vo:ArrangeVO;
		[Before]
		public function setUp():void
		{
			parentOne = new Group();
			element = new Rect();
			parentOne.addElement(element as IVisualElement);
			parentTwo = new Group();
			
			vo = new ArrangeVO();
			vo.element = element;
			vo.originalPosition = new Position(parentOne, parentOne.getElementIndex(element as IVisualElement));
			vo.newPosition = new Position(parentTwo, 0);
			
		}

		[After]
		public function tearDown():void
		{
		}

		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}

		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		[Test]
		public function testExecute():void{
			ExecuteUtil.execute(vo);
			Assert.assertEquals("Element was not arranged correctly", vo.newPosition.parent.getElementIndex(vo.element as IVisualElement), vo.originalPosition.index);
		}
		[Test]
		public function testUndo():void{
			ExecuteUtil.execute(vo);
			ExecuteUtil.undo(vo);
			Assert.assertEquals("Element arrangement was not undone correctly", vo.originalPosition.parent.getElementIndex(vo.element as IVisualElement), vo.originalPosition.index);
		}
	}
}