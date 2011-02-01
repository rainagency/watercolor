package watercolor.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import watercolor.elements.Element;
	import watercolor.elements.interfaces.IElementContainer;


	/**
	 *
	 * @author mediarain
	 * @author Sean Thayne
	 */
	public class MatrixInfo
	{
		/**
		 *
		 * @default
		 */
		public var unscaledWidth:Number = 0;


		/**
		 *
		 * @default
		 */
		public var unscaledHeight:Number = 0;


		private var _scaleX:Number = 1;


		private var _scaleY:Number = 1;


		private var _skewX:Number = 0;


		private var _skewY:Number = 0;


		private var _matrix:Matrix;


		private var _display:DisplayObject;


		/**
		 *
		 * @param source
		 */
		public function MatrixInfo( source:* = null ):void
		{
			if( source is DisplayObject )
				display = DisplayObject( source );
			else if( source is Matrix )
				matrix = Matrix( source );
			else
				matrix = new Matrix();
		}


		/**
		 *
		 * @return
		 */
		public function get x():Number
		{
			return matrix.tx;
		}


		/**
		 *
		 * @param value
		 */
		public function set x( value:Number ):void
		{
			matrix.tx = value;
		}


		/**
		 *
		 * @return
		 */
		public function get y():Number
		{
			return matrix.ty;
		}


		/**
		 *
		 * @param value
		 */
		public function set y( value:Number ):void
		{
			matrix.ty = value;
		}


		/**
		 *
		 * @return
		 */
		public function get width():Number
		{
			return scaleX * unscaledWidth;
		}


		/**
		 *
		 * @param value
		 */
		public function set width( value:Number ):void
		{
			scaleX = value / unscaledWidth;
		}


		/**
		 *
		 * @return
		 */
		public function get height():Number
		{
			return scaleY * unscaledHeight;
		}


		/**
		 *
		 * @param value
		 */
		public function set height( value:Number ):void
		{
			scaleY = value / unscaledHeight;
		}


		/**
		 *
		 * @return
		 */
		public function get scaleX():Number
		{
			return _scaleX;
		}


		/**
		 *
		 * @param value
		 */
		public function set scaleX( value:Number ):void
		{
			matrix.a = value * Math.cos( skewY );
			matrix.b = value * Math.sin( skewY );
			_scaleX = Math.sqrt( Math.pow( matrix.a, 2 ) + Math.pow( matrix.b, 2 ));
			if( value < 0 )
				_scaleX *= -1;
		}


		/**
		 *
		 * @return
		 */
		public function get scaleY():Number
		{
			return _scaleY;
		}


		/**
		 *
		 * @param value
		 */
		public function set scaleY( value:Number ):void
		{
			matrix.c = value * -Math.sin( skewX );
			matrix.d = value * Math.cos( skewX );
			_scaleY = Math.sqrt( Math.pow( matrix.c, 2 ) + Math.pow( matrix.d, 2 ));
			if( value < 0 )
				_scaleY *= -1;
		}


		/**
		 *
		 * @return
		 */
		public function get skewX():Number
		{
			return _skewX;
		}


		/**
		 *
		 * @param value
		 */
		public function set skewX( value:Number ):void
		{
			matrix.c = scaleY * -Math.sin( value );
			matrix.d = scaleY * Math.cos( value );

			_skewX = Math.acos( matrix.d / scaleY );
			if( Math.asin( -matrix.c / scaleY ) < 0 )
				_skewX *= -1;
		}


		/**
		 *
		 * @return
		 */
		public function get skewY():Number
		{
			return _skewY;
		}


		/**
		 *
		 * @param value
		 */
		public function set skewY( value:Number ):void
		{
			matrix.a = scaleX * Math.cos( value );
			matrix.b = scaleX * Math.sin( value );

			_skewY = Math.acos( matrix.a / scaleX );
			if( Math.asin( matrix.b / scaleX ) < 0 )
				_skewY *= -1;
		}


		/**
		 *
		 * @return
		 */
		public function get rotation():Number
		{
			return skewY;
		}


		/**
		 *
		 * @param value
		 */
		public function set rotation( value:Number ):void
		{
			skewX = value;
			skewY = value;
		}


		public function get flipH():Boolean
		{
			return ( matrix.a < 0 );
		}


		public function set flipH( value:Boolean ):void
		{
			if( flipH != value )
				matrix.scale( -1, 1 );
		}


		public function get flipV():Boolean
		{
			return ( matrix.d < 0 );
		}


		public function set flipV( value:Boolean ):void
		{
			if( flipV != value )
				matrix.scale( 1, -1 );
		}


		/**
		 *
		 * @return
		 */
		public function get matrix():Matrix
		{
			return _matrix;
		}


		/**
		 *
		 * @param value
		 */
		public function set matrix( value:Matrix ):void
		{
			_matrix = value.clone();
			update();
		}


		/**
		 *
		 * @return
		 */
		public function get display():DisplayObject
		{
			return _display;
		}


		/**
		 *
		 * @param value
		 */
		public function set display( value:DisplayObject ):void
		{
			_display = value;

			if( _display == null )
			{
				matrix = new Matrix();
				return;
			}

			matrix = _display.transform.matrix;
			var rect:Rectangle = _display.getRect( _display );
			unscaledWidth = rect.width;
			unscaledHeight = rect.height;
		}


		/**
		 *
		 * @return
		 */
		public function clone():MatrixInfo
		{
			var newInfo:MatrixInfo = new MatrixInfo( matrix );
			newInfo.unscaledWidth = unscaledWidth;
			newInfo.unscaledHeight = unscaledHeight;
			return newInfo;
		}


		/**
		 *
		 * @param compare
		 * @return
		 */
		public function equals( compare:MatrixInfo ):Boolean
		{
			if( compare.x != this.x )
				return false;
			if( compare.y != this.y )
				return false;
			if( compare.width != this.width )
				return false;
			if( compare.height != this.height )
				return false;
			if( compare.scaleX != this.scaleX )
				return false;
			if( compare.scaleY != this.scaleY )
				return false;
			if( compare.skewX != this.skewX )
				return false;
			if( compare.skewY != this.skewY )
				return false;
			if( compare.rotation != this.rotation )
				return false;

			return true;
		}


		// My new favorite undocumented function.
		/**
		 *
		 */
		public function update():void
		{
			_scaleX = Math.sqrt( Math.pow( _matrix.a, 2 ) + Math.pow( _matrix.b, 2 ));
			_scaleY = Math.sqrt( Math.pow( _matrix.c, 2 ) + Math.pow( _matrix.d, 2 ));
			_skewX = Math.acos( _matrix.d / scaleY );
			if( Math.asin( -_matrix.c / scaleY ) < 0 )
				_skewX *= -1;
			_skewY = Math.acos( _matrix.a / scaleX );
			if( Math.asin( _matrix.b / scaleX ) < 0 )
				_skewY *= -1;
		}
	}
}