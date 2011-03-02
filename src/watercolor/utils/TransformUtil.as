package watercolor.utils
{
	import fl.motion.MatrixTransformer;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	import watercolor.commands.vo.CommandVO;
	import watercolor.commands.vo.GroupCommandVO;
	import watercolor.commands.vo.TransformVO;
	import watercolor.elements.Element;
	import watercolor.elements.Ellipse;
	import watercolor.elements.Group;
	import watercolor.elements.Layer;
	import watercolor.elements.Line;
	import watercolor.elements.Path;
	import watercolor.elements.Rect;
	import watercolor.elements.components.IsolationLayer;


	/**
	 * Transformation utility that alters the transformation matrix, applies it to elements
	 * and the returns a CommandVO that can be used in the HistoryManager.
	 * @author garthdb
	 *
	 */
	//TODO: Fix naming scheme. Skew() => skew()
	public class TransformUtil
	{
		/**
		 * Horizontal axis; used for align, distribute, and flip
		 */
		public static const HORIZONTAL:String = 'horizontal';


		/**
		 * Vertical axis; used for align, distribute, and flip
		 */
		public static const VERTICAL:String = 'vertical';


		/**
		 * Both axii; used for align, distribute, and flip. Perform the action across both axii.
		 */
		public static const BOTH:String = 'both';


		/**
		 * Baseline min; align to the minimum position based on the axis.
		 */

		public static const MIN:String = 'min';


		/**
		 * Baseline max; align to the maximum position based on the axis.
		 */

		public static const MAX:String = 'max';


		/**
		 * Baseline center; align to the center position based on the axis.
		 */

		public static const CENTER:String = 'center';


		/**
		 *Perform a flip transformation on the passed in elements.
		 * @param elements Vector containing the Elements to flip.
		 * @param axis The axis to flip along (HORIZONTAL, VERTICAL, or BOTH).
		 * @return A commandVO containing the transform matrix. May be a GroupCommandVO if
		 * multiple elements were passed in.
		 *
		 */
		public static function flip( elements:Vector.<Element>, axis:String ):CommandVO
		{
			var result:CommandVO;
			var bounds:Rectangle = allElementBounds( elements );
			var rectCenter:Point = new Point( bounds.x + bounds.width / 2, bounds.y + bounds.height / 2 );

			var multipleElements:Boolean = false;
			if( elements.length > 1 )
			{
				multipleElements = true;
				result = new GroupCommandVO();
			}

			for each( var element:Element in elements )
			{
				var transformVO:TransformVO = new TransformVO();

				var scaledM:Matrix = new Matrix();

				if( axis == "horizontal" )
				{
					scaledM.scale( -1, 1 );
				}
				else if( axis == "vertical" )
				{
					scaledM.scale( 1, -1 );
				}
				else if( axis == "both" )
				{
					scaledM.scale( -1, 1 );
					scaledM.scale( 1, -1 );
				}

				var newMatrix:Matrix = element.transform.matrix.clone();
				newMatrix.translate( -rectCenter.x, -rectCenter.y );
				newMatrix.concat( scaledM );
				newMatrix.translate( rectCenter.x, rectCenter.y );

				transformVO.element = element;
				transformVO.newMatrix = newMatrix;
				transformVO.originalMatrix = element.transform.matrix;

				if( multipleElements )
				{
					( result as GroupCommandVO ).addCommand( transformVO );
				}
				else
				{
					result = transformVO;
				}
			}
			return result;
		}


		/**
		 *Peform an alignment transformation on the passed in Elements.
		 * @param elements Vector containing the Elements to align.
		 * @param axis The axis to align along (HORIZONTAL, VERTICAL, or BOTH).
		 * @param anchor The anchor element for the alignment.
		 * @param baseline The baseline of the anchor element on which to align
		 * 	(MIN, MAX, or CENTER).
		 * @return A commandVO containing the transform matrix. May be a GroupCommandVO if
		 * multiple elements were passed in.
		 *
		 */
		public static function align( elements:Vector.<Element>, axis:String, anchor:Element = null, baseline:String = null ):CommandVO
		{
			var result:CommandVO;

			var multipleElements:Boolean = false;
			if( elements.length > 1 )
			{
				multipleElements = true;
				result = new GroupCommandVO();
			}

			var newPoint:Point = new Point();

			if( anchor == null )
			{
				var maxPoint:Point = new Point();
				maxPoint.x = Number.NEGATIVE_INFINITY;
				maxPoint.y = Number.NEGATIVE_INFINITY;
				var minPoint:Point = new Point();
				minPoint.x = Number.POSITIVE_INFINITY;
				minPoint.y = Number.POSITIVE_INFINITY;
				for each( var element:Element in elements )
				{
					var uBounds:Rectangle = new Rectangle( element.getLayoutBoundsX( false ), element.getLayoutBoundsY( false ), element.getLayoutBoundsWidth( false ), element.getLayoutBoundsHeight( false ));
					var elementCenter:Point = new Point();
					elementCenter.x = uBounds.width / 2;
					elementCenter.y = uBounds.height / 2;
					var centerInParentCoordinates:Point = CoordinateUtils.localToLocal( element, element.parent, elementCenter );
					minPoint.x = Math.min( minPoint.x, centerInParentCoordinates.x );
					minPoint.y = Math.min( minPoint.y, centerInParentCoordinates.y );
					maxPoint.x = Math.max( maxPoint.x, centerInParentCoordinates.x );
					maxPoint.y = Math.max( maxPoint.y, centerInParentCoordinates.y );

				}
				newPoint.x = minPoint.x + ( maxPoint.x - minPoint.x ) / 2;
				newPoint.y = minPoint.y + ( maxPoint.y - minPoint.y ) / 2;
			}
			else
			{
				if( axis == VERTICAL )
				{
					if( baseline == MIN )
					{
						newPoint.x = anchor.getLayoutBoundsX();
					}
					else if( baseline == MAX )
					{
						newPoint.x = anchor.getLayoutBoundsX() + anchor.getLayoutBoundsWidth( false );
					}
					else if( baseline == CENTER )
					{
						newPoint.x = anchor.getLayoutBoundsX() + ( anchor.getLayoutBoundsWidth( false ) / 2 );
					}
				}
				else if( axis == HORIZONTAL )
				{
					if( baseline == MIN )
					{
						newPoint.y = anchor.getLayoutBoundsY();
					}
					else if( baseline == MAX )
					{
						newPoint.y = anchor.getLayoutBoundsY() + anchor.getLayoutBoundsHeight( false );
					}
					else if( baseline == CENTER )
					{
						newPoint.y = anchor.getLayoutBoundsY() + ( anchor.getLayoutBoundsHeight( false ) / 2 );
					}
				}
				else if( axis == BOTH )
				{
					if( baseline == MIN )
					{
						newPoint.x = anchor.getLayoutBoundsX();
						newPoint.y = anchor.getLayoutBoundsY();
					}
					else if( baseline == MAX )
					{
						newPoint.x = anchor.getLayoutBoundsX() + anchor.getLayoutBoundsWidth( false );
						newPoint.y = anchor.getLayoutBoundsY() + anchor.getLayoutBoundsHeight( false );
					}
					else if( baseline == CENTER )
					{
						newPoint.x = anchor.getLayoutBoundsX() + ( anchor.getLayoutBoundsWidth( false ) / 2 );
						newPoint.y = anchor.getLayoutBoundsY() + ( anchor.getLayoutBoundsHeight( false ) / 2 );
					}
				}
			}
			for each( element in elements )
			{
				uBounds = new Rectangle( element.getLayoutBoundsX(), element.getLayoutBoundsY( false ), element.getLayoutBoundsWidth( false ), element.getLayoutBoundsHeight( false ));

				elementCenter = new Point();

				var elementMin:Point = new Point( uBounds.x, uBounds.y );
				var elementMax:Point = new Point( uBounds.width, uBounds.height );
				elementCenter.x = uBounds.width / 2;
				elementCenter.y = uBounds.height / 2;

				var newElementCenter:Point = CoordinateUtils.localToLocal( element, element.parent, elementCenter );
				var newElementMax:Point = CoordinateUtils.localToLocal( element, element.parent, elementMax );
				var newElementMin:Point = CoordinateUtils.localToLocal( element, element.parent, elementMin );

				var transformVO:TransformVO = new TransformVO();
				var newMatrix:Matrix = element.transform.matrix.clone();
				switch( axis )
				{
					case "horizontal":
						switch( baseline )
						{
							case "min":
								newMatrix.translate( 0, newPoint.y - newElementMin.y );
								break;
							case "max":
								newMatrix.translate( 0, newPoint.y - newElementMax.y );
								break;
							case "center":
								newMatrix.translate( 0, newPoint.y - newElementCenter.y );
								break;
						}
						break;
					case "vertical":
						switch( baseline )
						{
							case "min":
								newMatrix.translate( newPoint.x - newElementMin.x, 0 );
								break;
							case "max":
								newMatrix.translate( newPoint.x - newElementMax.x, 0 );
								break;
							case "center":
								newMatrix.translate( newPoint.x - newElementCenter.x, 0 );
								break;
						}
						break;
					case "both":
						switch( baseline )
						{
							case "min":
								newMatrix.translate( newPoint.x - newElementMin.x, newPoint.y - newElementMin.y );
								break;
							case "max":
								newMatrix.translate( newPoint.x - newElementMax.x, newPoint.y - newElementMax.y );
								break;
							case "center":
								newMatrix.translate( newPoint.x - newElementCenter.x, newPoint.y - newElementCenter.y );
								break;
						}
						break;
				}

				transformVO.element = element;
				transformVO.newMatrix = newMatrix;
				transformVO.originalMatrix = element.transform.matrix;

				if( multipleElements )
				{
					( result as GroupCommandVO ).addCommand( transformVO );
				}
				else
				{
					result = transformVO;
				}
			}
			return result;
		}


		/**
		 *Evenly distributes the passed in elements along an axis and an anchor element.
		 * @param elements Vector containing the Elements to distribute.
		 * @param axis The axis to distribute along (HORIZONTAL, VERTICAL, or BOTH).
		 * @return A commandVO containing the transform matrix. May be a GroupCommandVO if
		 * multiple elements were passed in.
		 *
		 */
		public static function distribute( elements:Vector.<Element>, axis:String ):CommandVO
		{
			var result:CommandVO;

			if( elements.length > 2 )
			{
				result = new GroupCommandVO();

				var maxPoint:Point = new Point();
				maxPoint.x = Number.NEGATIVE_INFINITY;
				maxPoint.y = Number.NEGATIVE_INFINITY;
				var minPoint:Point = new Point();
				minPoint.x = Number.POSITIVE_INFINITY;
				minPoint.y = Number.POSITIVE_INFINITY;
				var xIncrement:Number;
				var yIncrement:Number;
				var elementsX:Vector.<Element> = elements.slice();
				var elementsY:Vector.<Element> = elements.slice();

				//loop through the elements and find the min x and y as well as the max x and y values
				//in essence we are finding what the element locations that are in the extremes, top, left, bottom and right
				//we'll use these to know where to distribute
				for each( var element:Element in elements )
				{
					var uBounds:Rectangle = new Rectangle( element.getLayoutBoundsX( false ), element.getLayoutBoundsY( false ), element.getLayoutBoundsWidth( false ), element.getLayoutBoundsHeight( false ));

					var elementCenter:Point = new Point();
					elementCenter.x = uBounds.width / 2;
					elementCenter.y = uBounds.height / 2;

					var workareaCenter:Point = CoordinateUtils.localToLocal( element, element.parent, elementCenter );

					minPoint.x = Math.min( minPoint.x, workareaCenter.x );
					minPoint.y = Math.min( minPoint.y, workareaCenter.y );
					maxPoint.x = Math.max( maxPoint.x, workareaCenter.x );
					maxPoint.y = Math.max( maxPoint.y, workareaCenter.y );
				}

				//find the amount to move the elements
				xIncrement = ( minPoint.x - maxPoint.x ) / ( elements.length - 1 );
				yIncrement = ( minPoint.y - maxPoint.y ) / ( elements.length - 1 );

				var sortedArray:Vector.<Element>;
				switch( axis )
				{
					case "horizontal":
						sortedArray = elementsX.sort( sortX );
						break;
					case "vertical":
						sortedArray = elementsY.sort( sortY );
						break;
				}

				for( var i:uint = 1; i < ( sortedArray.length - 1 ); i++ )
				{
					element = sortedArray[ i ];
					var newPoint:Point = new Point();
					newPoint.x = minPoint.x - i * xIncrement;
					newPoint.y = minPoint.y - i * yIncrement;

					uBounds = new Rectangle( element.getLayoutBoundsX( true ), element.getLayoutBoundsY( true ), element.getLayoutBoundsWidth( true ), element.getLayoutBoundsHeight( true ));
					elementCenter = new Point();
					elementCenter.x = uBounds.x + uBounds.width / 2;
					elementCenter.y = uBounds.y + uBounds.height / 2;

					var newMatrix:Matrix = element.transform.matrix.clone();
					switch( axis )
					{
						case "horizontal":
							newMatrix.translate( newPoint.x - elementCenter.x, 0 );
							break;
						case "vertical":
							newMatrix.translate( 0, newPoint.y - elementCenter.y );
							break;
					}

					var transformVO:TransformVO = new TransformVO();
					transformVO.element = element;
					transformVO.newMatrix = newMatrix;
					transformVO.originalMatrix = element.transform.matrix;

					( result as GroupCommandVO ).addCommand( transformVO );
				}
			}
			return result;
		}


		/**
		 *Rotates the passed in elements around a point or the center point of the group of elements.
		 * @param elements Vector containing the Elements to rotate.
		 * @param angle Angle in degrees to rotate.
		 * @param point Point to rotate around. If null, the center point is calculated and used.
		 * @return A commandVO containing the transform matrix. May be a GroupCommandVO if
		 * multiple elements were passed in.
		 *
		 */
		public static function rotate( elements:Vector.<Element>, angle:Number, point:Point = null ):CommandVO
		{
			var result:CommandVO;
			var newMatrix:Matrix;
			if( elements.length > 1 )
			{
				result = new GroupCommandVO();

				//find center point
				var bounds:Rectangle = allElementBounds( elements );
				var centerPoint:Point = new Point();
				centerPoint.x = bounds.x + bounds.width / 2;
				centerPoint.y = bounds.y + bounds.height / 2;

				//then have all elements rotate around that point
				for each( var element:Element in elements )
				{
					newMatrix = element.transform.matrix.clone();
					MatrixTransformer.rotateAroundExternalPoint( newMatrix, centerPoint.x, centerPoint.y, angle );
					var transformVO:TransformVO = new TransformVO();
					transformVO.element = element;
					transformVO.newMatrix = newMatrix;
					transformVO.originalMatrix = element.transform.matrix;

					( result as GroupCommandVO ).addCommand( transformVO );
				}
			}
			else if( elements.length == 1 )
			{
				result = new TransformVO();
				result.element = elements[ 0 ];
				newMatrix = TransformVO( result ).originalMatrix.clone();
				MatrixTransformer.rotateAroundInternalPoint( newMatrix, result.element.width / 2, result.element.height / 2, angle );
				TransformVO( result ).newMatrix = newMatrix;
				TransformVO( result ).originalMatrix = elements[ 0 ].transform.matrix;
			}
			return result;
		}


		/**
		 *Moves each of the passed in elements the amount specified.
		 * @param elements Vector containing the Elements to move.
		 * @param x The number of horizontal pixels to move each element.
		 * @param y The number of vertical pixels to move each element.
		 * @return A commandVO containing the transform matrix. May be a GroupCommandVO if
		 * multiple elements were passed in.
		 *
		 */
		public static function move( elements:Vector.<Element>, x:Number = 0, y:Number = 0 ):CommandVO
		{
			var result:CommandVO;

			var multipleElements:Boolean = false;
			if( elements.length > 1 )
			{
				multipleElements = true;
				result = new GroupCommandVO();
			}

			for each( var element:Element in elements )
			{
				var transformVO:TransformVO = new TransformVO();
				var newMatrix:Matrix = element.transform.matrix.clone();
				newMatrix.translate( x, y );

				transformVO.element = element;
				transformVO.newMatrix = newMatrix;
				transformVO.originalMatrix = element.transform.matrix;

				if( multipleElements )
				{
					( result as GroupCommandVO ).addCommand( transformVO );
				}
				else
				{
					result = transformVO;
				}
			}
			return result;
		}


		/**
		 *Skews the passed in elements by the x and y amounts specified.
		 * @param elements
		 * @param x The horizontal amount to skew.
		 * @param y The vertical amount to skew.
		 * @return A commandVO containing the transform matrix. May be a GroupCommandVO if
		 * multiple elements were passed in.
		 *
		 */
		public static function skew( elements:Vector.<Element>, x:Number = 0, y:Number = 0 ):CommandVO
		{
			var result:CommandVO;

			var multipleElements:Boolean = false;
			if( elements.length > 1 )
			{
				multipleElements = true;
				result = new GroupCommandVO();
			}

			for each( var element:Element in elements )
			{
				var transformVO:TransformVO = new TransformVO();
				var newMatrix:Matrix = element.transform.matrix.clone();
				newMatrix.c += x;
				newMatrix.b += y;

				transformVO.element = element;
				transformVO.newMatrix = newMatrix;
				transformVO.originalMatrix = element.transform.matrix;

				if( multipleElements )
				{
					( result as GroupCommandVO ).addCommand( transformVO );
				}
				else
				{
					result = transformVO;
				}
			}

			return result;
		}


		/**
		 *Scales the passed in elements by the x and y amounts specified.
		 * @param elements
		 * @param x The horizontal amount to scale.
		 * @param y The vertical amount to scale.
		 * @return A commandVO containing the transform matrix. May be a GroupCommandVO if
		 * multiple elements were passed in.
		 *
		 */
		public static function scale( elements:Vector.<Element>, x:Number = 0, y:Number = 0, scaleInner:Boolean = false ):CommandVO
		{
			var result:CommandVO;

			var multipleElements:Boolean = false;
			if( elements.length > 1 )
			{
				multipleElements = true;
				result = new GroupCommandVO();
			}

			for each( var element:Element in elements )
			{
				var transformVO:TransformVO = new TransformVO();
				var newMatrix:Matrix = element.transform.matrix.clone();

				if( scaleInner )
				{
					var identity:Matrix = new Matrix();
					identity.scale( x, y );
					identity.concat( newMatrix );
					newMatrix = identity;
				}
				else
				{
					newMatrix.scale( x, y );
				}

				transformVO.element = element;
				transformVO.newMatrix = newMatrix;
				transformVO.originalMatrix = element.transform.matrix;

				if( multipleElements )
				{
					( result as GroupCommandVO ).addCommand( transformVO );
				}
				else
				{
					result = transformVO;
				}
			}

			return result;
		}


		/**
		 *Takes a graphic element (rect, ellipse, path, etc.), converts it to a path
		 * and applies a set of matrices to the path.
		 * @param element Graphic element to convert and apply matrices to.
		 * @param matrices Vector containing the matrices to apply.
		 * @return The new, transformed path.
		 *
		 */
		public static function applyMatrix( element:Element, matrices:Vector.<Matrix> = null ):Path
		{
			var results:Path = new Path();
			var svgData:String = "";
			var path:Path;

			var completeMatrices:Matrix = new Matrix();

			completeMatrices.concat( element.transform.matrix );

			var vec:Vector.<Matrix> = new Vector.<Matrix>();
			vec.push( completeMatrices );

			for each( var matrix:Matrix in matrices )
			{
				completeMatrices.concat( matrix );
			}

			if( element is Ellipse )
			{
				var ellipse:Ellipse = element as Ellipse;

				svgData = ellipseToBezier( ellipse );
			}
			else if( element is Line )
			{
				var line:Line = element as Line;
				svgData = "M " + line.xFrom.toString() + " " + line.yFrom.toString() + "l " + ( line.xTo - line.xFrom ).toString() + " " + ( line.yTo - line.yFrom ).toString() + " " + "z";
			}
			else if( element is Rect )
			{
				var rect:Rect = element as Rect;
				svgData = "M " + rect.x.toString() + " " + rect.y.toString() + "l " + rect.width.toString() + " 0 " + "l " + "0 " + rect.height.toString() + " " + "l " + ( rect.width * -1 ).toString() + " 0 " + "z";
			}
			else if( element is Path )
			{
				path = element as Path;
				svgData = path.data;
			}
			else if( element is Group )
			{
				var group:Group = element as Group;

				for( var i:int = 0; i < group.numElements; i++ )
				{
					var el:Element = group.getElementAt( i ) as Element;
					path = applyMatrix( el, vec );
					svgData = svgData + " " + path.data;
				}
				results.data = svgData;
				return results;
			}
			else if( element is Layer )
			{
				var layer:Layer = element as Layer;

				for( var j:int = 0; j < layer.numElements; j++ )
				{
					var ele:Element = layer.getElementAt( j ) as Element;
					path = applyMatrix( ele, vec );
					svgData = svgData + " " + path.data;
				}
				results.data = svgData;
				return results;
			}
			results.data = getTransformedPath( svgData, completeMatrices );
			return results;
		}


		/**
		 *converts an ellipse to a bezier SVG path string.
		 * @param ellipse The ellipse to convert.
		 * @return The SVG string describing the beziers that make up the ellipse.
		 *
		 */
		public static function ellipseToBezier( ellipse:Ellipse ):String
		{
			var retVal:String;

			// MAGICAL CONSTANT to map ellipse to beziers
			//  			2/3*(sqrt(2)-1)

			var magic:Number = 2 / 3 * ( Math.SQRT2 - 1 ); //0.2761423749154;

			var offset:Point = new Point(( ellipse.width * magic ), ( ellipse.height * magic ));
			var center:Point = new Point( ellipse.x + ( ellipse.width / 2 ), ellipse.y + ( ellipse.height / 2 ));

			var start:Point = new Point( ellipse.x, center.y );
			var saveStart:Point = new Point( start.x, start.y );
			var q1Ctrl1:Point = new Point( ellipse.x, center.y - offset.y );
			var q1Ctrl2:Point = new Point( center.x - offset.x, ellipse.y );
			var q1End:Point = new Point( center.x, ellipse.y );

			var q2Ctrl1:Point = new Point( center.x + offset.x, ellipse.y );
			var q2Ctrl2:Point = new Point( ellipse.x + ellipse.width, center.y - offset.y );
			var q2End:Point = new Point( ellipse.x + ellipse.width, center.y );

			var q3Ctrl1:Point = new Point( ellipse.x + ellipse.width, center.y + offset.y );
			var q3Ctrl2:Point = new Point( center.x + offset.x, ellipse.y + ellipse.height );
			var q3End:Point = new Point( center.x, ellipse.y + ellipse.height );

			var q4Ctrl1:Point = new Point( center.x - offset.x, ellipse.y + ellipse.height );
			var q4Ctrl2:Point = new Point( ellipse.x, center.y + offset.y );
			var q4End:Point = new Point( ellipse.x, center.y );

			// make the points relative.

			q1Ctrl1.x -= start.x;
			q1Ctrl1.y -= start.y;
			q1Ctrl2.x -= start.x;
			q1Ctrl2.y -= start.y;
			q1End.x -= start.x;
			q1End.y -= start.y;

			start.x += q1End.x;
			start.y += q1End.y;

			q2Ctrl1.x -= start.x;
			q2Ctrl1.y -= start.y;
			q2Ctrl2.x -= start.x;
			q2Ctrl2.y -= start.y;
			q2End.x -= start.x;
			q2End.y -= start.y;

			start.x += q2End.x;
			start.y += q2End.y;

			q3Ctrl1.x -= start.x;
			q3Ctrl1.y -= start.y;
			q3Ctrl2.x -= start.x;
			q3Ctrl2.y -= start.y;
			q3End.x -= start.x;
			q3End.y -= start.y;

			start.x += q3End.x;
			start.y += q3End.y;

			q4Ctrl1.x -= start.x;
			q4Ctrl1.y -= start.y;
			q4Ctrl2.x -= start.x;
			q4Ctrl2.y -= start.y;
			q4End.x -= start.x;
			q4End.y -= start.y;

			start.x += q4End.x;
			start.y += q4End.y;

			retVal = "M " + saveStart.x.toString() + " " + saveStart.y.toString() + " " + "c " + q1Ctrl1.x.toString() + " " + q1Ctrl1.y.toString() + " " + q1Ctrl2.x.toString() + " " + q1Ctrl2.y.toString() + " " + q1End.x.toString() + " " + q1End.y.toString() + " " + "c " + q2Ctrl1.x.toString() + " " + q2Ctrl1.y.toString() + " " + q2Ctrl2.x.toString() + " " + q2Ctrl2.y.toString() + " " + q2End.x.toString() + " " + q2End.y.toString() + " " + "c " + q3Ctrl1.x.toString() + " " + q3Ctrl1.y.toString() + " " + q3Ctrl2.x.toString() + " " + q3Ctrl2.y.toString() + " " + q3End.x.toString() + " " + q3End.y.toString() + " " + "c " + q4Ctrl1.x.toString() + " " + q4Ctrl1.y.toString() + " " + q4Ctrl2.x.toString() + " " + q4Ctrl2.y.toString() + " " + q4End.x.toString() + " " + q4End.y.toString() + " " + "z";


			return retVal;
		}


		/**
		 *Applies a matrix to an SVG path string and converts all paths to absolute.
		 * @param svgData SVG path string to transform.
		 * @param matrices Combined matrices to apply.
		 * @return Transformed SVG path string.
		 *
		 */
		public static function getTransformedPath( svgData:String, matrices:Matrix ):String
		{
			var tx:Number = matrices.tx;
			var ty:Number = matrices.ty;
			var a:Number = matrices.a;
			var b:Number = matrices.b;
			var c:Number = matrices.c;
			var d:Number = matrices.d;
			var currentX:Number;
			var currentY:Number;
			var lastCmd:String = "";

			var transformedPath:String = new String();

			var svgParser:SVGParser = new SVGParser(svgData);
			while( svgParser.hasMore() )
			{
				var cmd:String = svgParser.getCommand();
				if( cmd == "" )
				{
					cmd = lastCmd;
				}
				lastCmd = cmd;

				var addx:Number = 0;
				var addy:Number = 0;
				var x:Number;
				var y:Number;
				var x1:Number;
				var y1:Number;
				var x2:Number;
				var y2:Number;
				var point:Point;

				var i:int = 0;
				switch( cmd )
				{
					case 'm':
						addx = currentX;
						addy = currentY;
					case 'M':
						transformedPath += "M ";

						point = svgParser.getPoint();
						point.x += addx;
						point.y += addy;
						
						x = ( a * point.x ) + ( c * point.y ) + tx;
						y = ( b * point.x ) + ( d * point.y ) + ty;

						transformedPath += x.toString() + " " + y.toString() + " ";

						currentX = point.x;
						currentY = point.y;
						break;
					case 'c':
						addx = currentX;
						addy = currentY;
					case 'C':
						transformedPath += "C ";

						point = svgParser.getPoint();
						point.x += addx;
						point.y += addy;
						x1 = ( a * point.x ) + ( c * point.y ) + tx;
						y1 = ( b * point.x ) + ( d * point.y ) + ty;

						point = svgParser.getPoint();
						point.x += addx;
						point.y += addy;
						x2 = ( a * point.x ) + ( c * point.y ) + tx;
						y2 = ( b * point.x ) + ( d * point.y ) + ty;

						point = svgParser.getPoint();
						point.x += addx;
						point.y += addy;
						x = ( a * point.x ) + ( c * point.y ) + tx;
						y = ( b * point.x ) + ( d * point.y ) + ty;

						transformedPath += x1.toString() + " " + y1.toString() + " " + x2.toString() + " " + y2.toString() + " " + x.toString() + " " + y.toString() + " ";

						currentX = point.x;
						currentY = point.y;
						break;
					case 'h':
						addx = currentX;
					case 'H':

						// Convert to a line to
						transformedPath += "L ";

						point = new Point();
						point.x = svgParser.getNumber() + addx;
						point.y = currentY;
						
						x = ( a * point.x ) + ( c * point.y ) + tx;
						y = ( b * point.x ) + ( d * point.y ) + ty;

						transformedPath += x.toString() + " " + y.toString() + " ";
						currentX = point.x;
						break;
					case 'v':
						addy = currentY;
					case 'V':
						transformedPath += "L ";

						point = new Point();
						point.y = svgParser.getNumber() + addy;
						point.x = currentX;
						
						x = ( a * point.x ) + ( c * point.y ) + tx;
						y = ( b * point.x ) + ( d * point.y ) + ty;
						
						transformedPath += x.toString() + " " + y.toString() + " ";
						currentY = point.y;
						break;
					case 'l':
						addx = currentX;
						addy = currentY;
					case 'L':
						transformedPath += "L ";

						point = svgParser.getPoint();
						point.x += addx;
						point.y += addy;
						x = ( a * point.x ) + ( c * point.y ) + tx;
						y = ( b * point.x ) + ( d * point.y ) + ty;

						transformedPath += x.toString() + " " + y.toString() + " ";

						currentX = point.x;
						currentY = point.y;
						break;
					case 'Z':
					case 'z':
						transformedPath += "Z";
						currentX = 0;
						currentY = 0;
						break;
					default:
						trace( 'unsupported command "' + cmd + '" attempted' );
						break;
				}
			}

			return transformedPath;
		}

		static private function allElementBounds( elements:Vector.<Element> ):Rectangle
		{
			var bounds:Rectangle = new Rectangle();

			for each( var element:Element in elements )
			{
				var uBounds:Rectangle = new Rectangle( element.getLayoutBoundsX(), element.getLayoutBoundsY(), element.getLayoutBoundsWidth(), element.getLayoutBoundsHeight());
				bounds = bounds.union( uBounds );
			}

			return bounds;
		}


		static private function sortX( a:Element, b:Element ):Number
		{
			var aBounds:Rectangle = new Rectangle( a.getLayoutBoundsX( true ), a.getLayoutBoundsY( true ), a.getLayoutBoundsWidth( true ), a.getLayoutBoundsHeight( true ));
			var bBounds:Rectangle = new Rectangle( b.getLayoutBoundsX( true ), b.getLayoutBoundsY( true ), b.getLayoutBoundsWidth( true ), b.getLayoutBoundsHeight( true ));
			if( aBounds.x < bBounds.x )
			{
				return -1;
			}
			else if( aBounds.x > bBounds.x )
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}


		static private function sortY( a:Element, b:Element ):Number
		{
			var aBounds:Rectangle = new Rectangle( a.getLayoutBoundsX( true ), a.getLayoutBoundsY( true ), a.getLayoutBoundsWidth( true ), a.getLayoutBoundsHeight( true ));
			var bBounds:Rectangle = new Rectangle( b.getLayoutBoundsX( true ), b.getLayoutBoundsY( true ), b.getLayoutBoundsWidth( true ), b.getLayoutBoundsHeight( true ));
			if( aBounds.y < bBounds.y )
			{
				return -1;
			}
			else if( aBounds.y > bBounds.y )
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

		static public function getAdjustedMatrix( parentMatrix:Matrix, childMatrix:Matrix ):Matrix
		{

			// copy the concatenated matrix for the child and for the element (old parent)
			var elmConcat:Matrix = parentMatrix.clone();
			var childConcat:Matrix = childMatrix.clone();

			// invert the old parent's concatenated matrix
			elmConcat.invert();

			// concat the inverted matrix to remove it from the child matrix
			childConcat.concat( elmConcat );

			// move the child back to the old parent
			return childConcat;
		}


		static public function convertPathToAbsolute( svgData:String ):String
		{
			var currentX:Number;
			var currentY:Number;
			var lastCmd:String = "";

			var convertedPath:String = new String();

			var svgParser:SVGParser = new SVGParser(svgData);

			while( svgParser.hasMore() )
			{
				var cmd:String = svgParser.getCommand();
				if( cmd == "" )
				{
					cmd = lastCmd;
				}
				lastCmd = cmd;

				var x:Number;
				var y:Number;
				var x1:Number;
				var y1:Number;
				var x2:Number;
				var y2:Number;
				var point:Point;

				var i:int = 0;
				switch( cmd )
				{
					case 'M':
						convertedPath += cmd + " ";

						point = svgParser.getPoint();
						convertedPath += point.x.toString() + " " + point.y.toString() + " ";

						currentX = point.x;
						currentY = point.y;
						break;
					case 'm':
						convertedPath += "M" + " ";

						point = svgParser.getPoint();
						x = point.x + currentX;
						y = point.y + currentY;

						if( isNaN( x ) || isNaN( y ))
						{
							x = 0;
							y = 0;
						}

						convertedPath += x.toString() + " " + y.toString() + " ";

						currentX += point.x;
						currentY += point.y;
						break;
					case 'C':
						convertedPath += cmd + " ";

						point = svgParser.getPoint();
						x1 = point.x;
						y1 = point.y;

						point = svgParser.getPoint();
						x2 = point.x;
						y2 = point.y;

						point = svgParser.getPoint();
						x = point.x;
						y = point.y;

						convertedPath += x1.toString() + " " + y1.toString() + " " + x2.toString() + " " + y2.toString() + " " + x.toString() + " " + y.toString() + " ";

						currentX = point.x;
						currentY = point.y;
						break;
					case 'c':
						convertedPath += "C" + " ";

						point = svgParser.getPoint();
						x1 = point.x + currentX;
						y1 = point.y + currentY;

						point = svgParser.getPoint();
						x2 = point.x + currentX;
						y2 = point.y + currentY;

						point = svgParser.getPoint();
						x = point.x + currentX;
						y = point.y + currentY;

						convertedPath += x1.toString() + " " + y1.toString() + " " + x2.toString() + " " + y2.toString() + " " + x.toString() + " " + y.toString() + " ";

						currentX += point.x;
						currentY += point.y;
						break;
					case 'S':
						convertedPath += cmd + " ";

						point = svgParser.getPoint();
						x2 = point.x;
						y2 = point.y;

						point = svgParser.getPoint();
						x = point.x;
						y = point.y;

						convertedPath += x2.toString() + " " + y2.toString() + " " + x.toString() + " " + y.toString() + " ";

						currentX = point.x;
						currentY = point.y;
						break;
					case 's':
						convertedPath += "S" + " ";

						point = svgParser.getPoint();
						x2 = point.x + currentX;
						y2 = point.y + currentY;

						point = svgParser.getPoint();
						x = point.x + currentX;
						y = point.y + currentY;

						convertedPath += x2.toString() + " " + y2.toString() + " " + x.toString() + " " + y.toString() + " ";

						currentX += point.x;
						currentY += point.y;
						break;
					case 'H':
						convertedPath += cmd + " ";

						point = new Point();
						point.x = svgParser.getNumber();
						x = point.x;
						convertedPath += x.toString() + " ";

						currentX = point.x;
						break;
					case 'h':
						convertedPath += "H" + " ";

						point = new Point();
						point.x = svgParser.getNumber();
						x = point.x + currentX;

						convertedPath += x.toString() + " ";

						currentX += point.x;
						break;
					case 'V':
						convertedPath += cmd + " ";

						point = new Point();
						point.y = svgParser.getNumber();
						y = point.y;
						convertedPath += y.toString() + " ";

						currentY = point.y;
						break;
					case 'v':
						convertedPath += "V" + " ";

						point = new Point();
						point.y = svgParser.getNumber();
						y = point.y + currentY;

						convertedPath += y.toString() + " ";

						currentY += point.y;
						break;
					case 'L':
						convertedPath += cmd + " ";

						point = svgParser.getPoint();
						x = point.x;
						y = point.y;

						convertedPath += x.toString() + " " + y.toString() + " ";

						currentX = point.x;
						currentY = point.y;
						break;
					case 'l':
						convertedPath += "L" + " ";

						point = svgParser.getPoint();
						x = point.x + currentX;
						y = point.y + currentY;

						convertedPath += x.toString() + " " + y.toString() + " ";

						currentX += point.x;
						currentY += point.y;
						break;
					case 'Z':
					case 'z':
						convertedPath += "Z" + " ";
						currentX = 0;
						currentY = 0;
						break;
					default:
						trace( 'unsupported command "' + cmd + '" attempted' );
						break;
				}
			}

			return convertedPath;
		}


		/**
		 * This function parses through the path and creates an array of contours
		 */
		static public function parsePathData( pathData:String ):Array
		{

			var list:Array = new Array();
			var lastCmd:String = "";
			var point:Point;
			var current:String = "";
			var x:int;

			var svgParser:SVGParser = new SVGParser(StringUtil.trim( pathData ));

			// while there is still data to parse through
			while( svgParser.hasMore() )
			{
				var cmd:String = svgParser.getCommand();
				if( cmd == "" )
				{
					cmd = lastCmd;
				}
				lastCmd = cmd;

				switch( cmd )
				{
					case 'M':
						if( current.length > 0 )
						{
							list.push({ contour:StringUtil.trim( current ), show:true });
						}
						current = "M ";
						getPath();
						break;

					case 'C':
						current += "C ";
						for( x = 0; x < 3; x++ )
						{
							getPath();
						}
						break;

					case 'Q':
						current += "Q ";
						for( x = 0; x < 2; x++ )
						{
							getPath();
						}
						break;

					case 'H':
						current += "H ";
						getLine();
						break;

					case 'V':
						current += "V ";
						getLine();
						break;

					case 'L':
						current += "L ";
						getPath();
						break;

					case 'z':
					case 'Z':
						current += "Z";
						break;
					default:
						trace( 'unsupported command "' + cmd + '" attempted' );
						break;
				}
			}

			// function to get the x,y for the next point in the path
			function getPath():void
			{
				point = svgParser.getPoint();
				current += point.x + " " + point.y + " ";
			}

			function getLine():void
			{
				current += svgParser.getNumber() + " ";
			}

			function sortList( a:Object, b:Object ):Number
			{
				if( a.contour.length > b.contour.length )
				{
					return -1;
				}
				else
				{
					return 1;
				}
			}

			if( current.length > 0 )
			{
				list.push({ contour:StringUtil.trim( current ), show:true });
			}

			return list.sort( sortList );
		}
		
		public static function adjustForIsolationMode(command:TransformVO, isolationLayer:IsolationLayer):void
		{
			// copy the concatenated matrix for the child and for the element (old parent)
			var elmConcat:Matrix = isolationLayer.lastIsolatedElement.transform.concatenatedMatrix.clone();
			var childConcat:Matrix = command.element.transform.concatenatedMatrix.clone();
			var origConcat:Matrix = TransformVO(command).originalMatrix;
			
			// invert the old parent's concatenated matrix
			elmConcat.invert();
			
			// find the right x,y position for the element
			var np:Point = CoordinateUtils.localToLocal(isolationLayer.contentGroup, isolationLayer.lastIsolatedElement, new Point(command.element.x, command.element.y));
			var op:Point = CoordinateUtils.localToLocal(isolationLayer.contentGroup, isolationLayer.lastIsolatedElement, new Point(origConcat.tx, origConcat.ty));
			
			// concat the inverted matrix to remove it from the child matrix
			childConcat.concat( elmConcat );
			origConcat.concat( elmConcat );
			
			origConcat.scale( isolationLayer.contentGroupScaleX, isolationLayer.contentGroupScaleY );
			
			childConcat.tx = np.x;
			childConcat.ty = np.y;
			
			origConcat.tx = op.x;
			origConcat.ty = op.y;
			
			if (TransformVO(command).useChildMatrix)
			{
				TransformVO(command).newMatrix = command.element.childMatrix;
			}
			else
			{
				TransformVO(command).newMatrix = childConcat;
			}
			
			TransformVO(command).originalMatrix = origConcat;
		}
	}
}
