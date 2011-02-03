package watercolor.elements.components
{
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import watercolor.elements.Element;
	import watercolor.elements.Layer;
	import watercolor.transform.TransformLayer;

	public class SelectionLayer extends SkinnableContainer
	{

		[SkinPart(required="true")]
		public var transformLayer:TransformLayer;
		
		private var _selectedElements:Vector.<Element> = new Vector.<Element>;

		public function SelectionLayer()
		{
			super();
		}

		public function get selectedElements():Vector.<Element>
		{
			return _selectedElements;
		}

		public function set selectedElements(value:Vector.<Element>):void
		{
			_selectedElements = value;
		}

		public function get selectionEmpty():Boolean
		{
			return !(_selectedElements.length > 0);
		}

		protected function selectionChangedHandler():void
		{

		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			switch (instance)
			{
				case transformLayer:
					break;
				default:
					break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch(instance)
			{
				case transformLayer:
					break;
				default:
					break;
			}
			super.partRemoved(partName, instance);
		}
	}
}