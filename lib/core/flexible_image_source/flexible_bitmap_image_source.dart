part of 'flexible_image_source.dart';

class FlexibleBitmapAssetImageSource extends FlexibleAssetImageSource {
  const FlexibleBitmapAssetImageSource({
    required super.source,
    super.bundle,
    super.packageName,
  });

  @override
  List<Object?> get props => [
        super.props,
      ];
}

class FlexibleBitmapNetworkImageSource extends FlexibleNetworkImageSource {
  const FlexibleBitmapNetworkImageSource({
    required super.url,
    super.headers,
    this.cacheKey,
    this.scale = 1.0,
    this.cacheManager,
    this.errorListener,
    this.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage,
    this.maxHeight,
    this.maxWidth,
  });

  final double scale;
  final String? cacheKey;
  final BaseCacheManager? cacheManager;
  final void Function(Object error)? errorListener;
  final ImageRenderMethodForWeb imageRenderMethodForWeb;
  final int? maxWidth;
  final int? maxHeight;

  @override
  List<Object?> get props => [
        ...super.props,
        scale,
        cacheKey,
        cacheManager,
        errorListener,
        imageRenderMethodForWeb,
        maxWidth,
        maxHeight,
      ];
}

class FlexibleBitmapMemoryImageSource extends FlexibleMemoryImageSource {
  const FlexibleBitmapMemoryImageSource({
    required super.bytes,
    this.scale = 1.0,
  });

  final double scale;

  @override
  List<Object?> get props => [...super.props, scale];
}

class FlexibleBitmapFileImageSource extends FlexibleFileImageSource {
  const FlexibleBitmapFileImageSource({
    required super.file,
    this.scale = 1.0,
  });

  final double scale;

  @override
  List<Object?> get props => [...super.props, scale];
}
