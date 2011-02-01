package watercolor.utils
{
	import flash.geom.Point;

	import mx.core.FlexGlobals;

	import spark.primitives.Path;

	import watercolor.math.CubicBezierCurve;
	import watercolor.math.EuclideanLine;
	import watercolor.math.IntersectionPoint;
	import watercolor.math.StraightLine;
	import watercolor.math.interfaces.IBezierCurve;
	import watercolor.pathData.PathData;
	import watercolor.pathData.PathDataCommand;
	import watercolor.pathData.PathDataContour;
	import watercolor.pathData.PathDataCubicBezierCommand;
	import watercolor.pathData.PathDataHorizontialLineCommand;
	import watercolor.pathData.PathDataLineCommand;
	import watercolor.pathData.PathDataQuadraticBezierCommand;
	import watercolor.pathData.PathDataSmoothQuadraticBezierCommand;
	import watercolor.pathData.PathDataVerticalLineCommand;
	import watercolor.pathData.interfaces.IPathDataVisualCommand;


	public class PathDataUtil
	{
		public static function mergeAndClip( pathA:PathData, pathB:PathData ):PathData
		{

			var isClipping:Boolean = false;
			var newPath:PathData = new PathData();

			for( var contourAIndex:uint = 0; contourAIndex < pathA.pathCountours.length; contourAIndex++ )
			{
				var contourA:PathDataContour = PathDataContour( pathA.pathCountours[ contourAIndex ]);
				var contourAVisualCommands:Vector.<IPathDataVisualCommand> = contourA.visualCommands;
				var newContour:PathDataContour = new PathDataContour( newPath, contourA.startPoint.clone());

				for( var contourBIndex:uint = 0; contourBIndex < pathB.pathCountours.length; contourBIndex++ )
				{
					var contourB:PathDataContour = PathDataContour( pathB.pathCountours[ contourBIndex ]);
					var contourBVisualCommands:Vector.<IPathDataVisualCommand> = contourB.visualCommands;

					for( var i:uint = 0; i < contourAVisualCommands.length; i++ )
					{
						var commandA:IPathDataVisualCommand = contourAVisualCommands[ i ];
						var lineA:EuclideanLine = commandA.euclideanLine;

						for( var ii:uint = 0; ii < contourBVisualCommands.length; ii++ )
						{
							var commandB:IPathDataVisualCommand = contourBVisualCommands[ ii ];
							var lineB:EuclideanLine = contourBVisualCommands[ ii ].euclideanLine;

							var ips:Vector.<IntersectionPoint> = IntersectionUtil.getIntersectionPoints( lineA, lineB );

							if( ips )
							{
								isClipping = !isClipping;
									//FlexGlobals.topLevelApplication.markPoint( ips[ 0 ], 0x00FF00, true );
							}

							if( isClipping )
							{
								commandB.clone( newContour );
								i++;
							}
						}

						commandA.clone( newContour );

					}
				}
			}

			return newPath;
		}


		public static function connectCommandTo( lineA:EuclideanLine, lineB:EuclideanLine, pathDataContour:PathDataContour ):PathDataCommand
		{
			trace( "A: " + lineA + " B: " + lineB );
			var intersectionPoints:Vector.<IntersectionPoint> = IntersectionUtil.getIntersectionPoints( lineA, lineB );


			if( intersectionPoints )
			{
				//Clip
				var intersectionPoint:IntersectionPoint = intersectionPoints[ 0 ];

				if( !intersectionPoint.x || !intersectionPoint.y )
					throw( "Invalid Clipping Point" );

				trace( "	Clipped: " + intersectionPoint.toString());

				if( lineA is IBezierCurve )
					IBezierCurve( lineA ).clipPointBTo( intersectionPoint.lineAIntersectionTime, intersectionPoint );
				else
					lineA.pointB = intersectionPoint;

				if( lineB is IBezierCurve )
					IBezierCurve( lineB ).clipPointATo( intersectionPoint.lineBIntersectionTime, intersectionPoint );
				else
					lineB.pointA = intersectionPoint;

				return null;

			}
			else
			{
				var curveCommand:PathDataQuadraticBezierCommand = new PathDataQuadraticBezierCommand( pathDataContour, new Point, lineB.pointA );
				var controlPoint:Point;

				if( lineA is StraightLine && lineB is StraightLine )
					curveCommand.controlPoint = IntersectionUtil.getStraightLinesIntersectionPoints( StraightLine( lineA ), StraightLine( lineB ), false )[ 0 ];
				else if( lineA is StraightLine && lineB is IBezierCurve )
					curveCommand.controlPoint = IntersectionUtil.getStraightLinesIntersectionPoints( StraightLine( lineA ), new StraightLine( IBezierCurve( lineB ).getPoint( .00001 ), lineB.pointA ), false )[ 0 ];
				else if( lineA is IBezierCurve && lineB is StraightLine )
					curveCommand.controlPoint = IntersectionUtil.getStraightLinesIntersectionPoints( new StraightLine( IBezierCurve( lineA ).getPoint( .99999 ), lineA.pointB ), StraightLine( lineB ), false )[ 0 ];
				else
					curveCommand.controlPoint = IntersectionUtil.getStraightLinesIntersectionPoints( new StraightLine( IBezierCurve( lineA ).getPoint( .99999 ), lineA.pointB ), new StraightLine( IBezierCurve( lineB ).getPoint( .00001 ), lineB.pointA ), false )[ 0 ];

				trace( "	Curved: " + curveCommand.controlPoint.toString());

				return curveCommand;
			}
		}
	}
}
import watercolor.pathData.interfaces.IPathDataVisualCommand;


class PathDataClipSection
{
	public var pathDataAStartCommand:IPathDataVisualCommand;
}