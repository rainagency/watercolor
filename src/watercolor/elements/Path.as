package watercolor.elements
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.Stroke;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import org.osmf.display.ScaleMode;
	
	import spark.components.supportClasses.Skin;
	import spark.primitives.Path;
	
	import watercolor.elements.interfaces.IElementGraphic;
	import watercolor.pathData.PathData;
	import watercolor.utils.TransformUtil;


	/**
	 * Watercolor's Path element encapsulates a Flex-based Path, a filled
	 * graphic element that draws a series of path segments.
	 *
	 * @see spark.primitives.Path
	 */
	public class Path extends Element implements IElementGraphic
	{
		/**
		 * The Flex-based primitive wrapped by this Element.
		 */
		protected var path:spark.primitives.Path;


		/**
		 * The container for all PathDataContours/PathDataCommands
		 */
		private var _pathData:PathData;


		/**
		 *
		 */
		public function Path()
		{
			path = new spark.primitives.Path();
		}


		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			addElement( path );
		}


		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#width;
		 */
		override public function get width():Number
		{
			return path.width;
		}


		override public function set width( value:Number ):void
		{
			super.width = value;
			path.width = value;
		}


		/**
		 * @copy spark.primitives.supportClasses.GraphicElement#height;
		 */
		override public function get height():Number
		{
			return path.height;
		}


		override public function set height( value:Number ):void
		{
			super.height = value;
			path.height = value;
		}


		// :: Path Properties :: //

		public function get pathData():PathData
		{
			return _pathData;
		}


		public function set pathData( pathData:PathData ):void
		{
			_pathData = pathData;
			path.data = _pathData.data;
		}


		/**
		 * @copy spark.primitives.Path#data;
		 */
		public function get data():String
		{
			return (pathData) ? pathData.data : null;
		}


		/**
		 *
		 * @param value
		 */
		public function set data( value:* ):void
		{

			if( value is PathData )
			{
				_pathData = value;
			}
			else if( value is String )
			{
				_pathData = new PathData( value );
			}
			else if (value)
			{
				_pathData = new PathData( value.toString());
			}

			if (_pathData)
			{
				_pathData.offsetNegativePoints();
				reloadPathData();
			}
		}


		/**
		 * This function will move the path into the top left corner.
		 */
		public function rebuildPath():void
		{
			_pathData.rebuildPoints();
			reloadPathData();
		}


		/**
		 * Updates the Path after with changes that have been made
		 * to the PathData object
		 */
		public function reloadPathData():void
		{
			path.data = pathData.data;
		}


		/**
		 * @copy spark.primitives.Path#winding;
		 */
		public function get winding():String
		{
			return path.winding;
		}


		/**
		 *
		 * @param value
		 */
		public function set winding( value:String ):void
		{
			path.winding = value;
		}


		// :: Fill and Stroke Properties :: //

		/**
		 * @copy spark.primitives.supportClasses.FilledElement#fill;
		 */
		public function get fill():IFill
		{
			return path.fill;
		}


		/**
		 *
		 * @param value
		 */
		public function set fill( value:IFill ):void
		{
			path.fill = value;
		}


		/**
		 * @copy spark.primitives.supportClasses.StrokedElement#stroke;
		 */
		public function get stroke():IStroke
		{
			return path.stroke;
		}


		/**
		 *
		 * @param value
		 */
		public function set stroke( value:IStroke ):void
		{
			path.stroke = value;
		}
	}
}