package watercolor.elements.interfaces
{
	import flash.geom.Transform;

	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;


	/**
	 * Interface for all WaterColor Element containers.
	 *
	 * @author Sean Thayne.
	 */
	public interface IElementContainer extends IVisualElementContainer, IVisualElement
	{
		function get transform():flash.geom.Transform;
	}
}