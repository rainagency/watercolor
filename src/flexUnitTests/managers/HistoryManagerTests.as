package flexUnitTests.managers
{
    import flexunit.framework.Assert;

    import watercolor.commands.vo.TransformVO;
    import watercolor.elements.Rect;
    import watercolor.managers.HistoryManager;

    public class HistoryManagerTests
    {
        private var historyManager:HistoryManager;

        private var transformVO:TransformVO;

        private var rect:Rect;

        [Before]
        public function setUp():void
        {
            historyManager = new HistoryManager();
            transformVO = new TransformVO();
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
        public function testAddCommand():void
        {
            historyManager.addCommand(transformVO);
            //Assert.assertTrue("Command not added", historyManager._commandVOs[0] == transformVO);
        }

    }
}