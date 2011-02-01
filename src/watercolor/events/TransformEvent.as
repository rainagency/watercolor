package watercolor.events
{
	import flash.events.Event;


	public class TransformEvent extends Event
	{
		public static const TRANSFORMATION_COMPLETE:String = "transformationComplete";


		public function TransformEvent( type:String )
		{
			super( type, false, false );
		}


		override public function clone():Event
		{
			return new TransformEvent( type );
		}
	}
}