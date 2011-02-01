package flexUnitTests
{
	import flexUnitTests.commands.execUtils.*;
	import flexUnitTests.factories.fxg.FXGToSparkFactoryTests;
	import flexUnitTests.factories.svg.SVGToSparkFactoryTests;
	import flexUnitTests.managers.HistoryManagerTests;
	import flexUnitTests.utils.TransformUtilTests;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class WatercolorTestSuite
	{

		public var arrangeExecuteTests:ArrangeExecuteTests;

		public var createExecuteTests:CreateExecuteTests;

		public var deleteExecuteTests:DeleteExecuteTests;

		public var historyManagerTests:flexUnitTests.managers.HistoryManagerTests;

		public var propertyExecuteTests:PropertyExecuteTests;

		public var transformExecuteTests:TransformExecuteTests;

		public var groupExecuteTests:GroupExecuteTests;

		public var svgToSparkFactoryTests:SVGToSparkFactoryTests;
		
		public var fxgToSparkFactoryTests:FXGToSparkFactoryTests;

		public var transformUtilTests:TransformUtilTests;
	}
}