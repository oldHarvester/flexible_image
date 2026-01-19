part of '../flexible_image.dart';

class FlexibleVectorImageSettings with EquatableMixin {
  const FlexibleVectorImageSettings({
    this.renderingStrategy = RenderingStrategy.picture,
    this.allowDrawingOutsideViewBox = false,
    this.clipBehavior = Clip.hardEdge,
  });

  final RenderingStrategy renderingStrategy;
  final bool allowDrawingOutsideViewBox;
  final Clip clipBehavior;

  @override
  List<Object?> get props => [
        renderingStrategy,
        allowDrawingOutsideViewBox,
        clipBehavior,
      ];
}
