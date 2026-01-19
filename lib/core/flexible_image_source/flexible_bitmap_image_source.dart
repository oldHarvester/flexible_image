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
    this.scale = 1.0,
    this.webHtmlElementStrategy = WebHtmlElementStrategy.never,
  });

  final double scale;
  final WebHtmlElementStrategy webHtmlElementStrategy;

  @override
  List<Object?> get props => [...super.props, scale, webHtmlElementStrategy];
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
