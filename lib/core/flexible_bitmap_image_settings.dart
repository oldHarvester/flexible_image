part of '../flexible_image.dart';

class FlexibleBitmapImageSettings with EquatableMixin {
  const FlexibleBitmapImageSettings({
    this.centerSlice,
    this.filterQuality = FilterQuality.medium,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.repeat = ImageRepeat.noRepeat,
    this.opacity,
    required this.frameBuilder,
  });

  final Rect? centerSlice;
  final FilterQuality filterQuality;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final Animation<double>? opacity;
  final ImageRepeat repeat;
  final FlexibleBitmapImageFrameBuilder frameBuilder;

  @override
  List<Object?> get props => [
        centerSlice,
        filterQuality,
        gaplessPlayback,
        isAntiAlias,
        opacity,
        repeat,
        frameBuilder,
      ];
}
