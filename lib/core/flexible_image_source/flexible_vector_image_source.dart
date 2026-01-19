part of 'flexible_image_source.dart';

class FlexibleVectorAssetImageSource extends FlexibleAssetImageSource {
  const FlexibleVectorAssetImageSource({
    required super.source,
    this.colorMapper,
    this.svgTheme,
    super.bundle,
    super.packageName,
  });

  final ColorMapper? colorMapper;
  final SvgTheme? svgTheme;

  @override
  List<Object?> get props => [...super.props, colorMapper, svgTheme];
}

class FlexibleVectorNetworkImageSource extends FlexibleNetworkImageSource {
  const FlexibleVectorNetworkImageSource({
    required super.url,
    this.client,
    this.svgTheme,
    this.colorMapper,
  });

  final ColorMapper? colorMapper;
  final http.Client? client;
  final SvgTheme? svgTheme;

  @override
  List<Object?> get props => [...super.props, colorMapper, client, svgTheme];
}

class FlexibleVectorMemoryImageSource extends FlexibleMemoryImageSource {
  const FlexibleVectorMemoryImageSource({
    required super.bytes,
    this.colorMapper,
    this.svgTheme,
  });

  final ColorMapper? colorMapper;
  final SvgTheme? svgTheme;

  @override
  List<Object?> get props => [...super.props, colorMapper, svgTheme];
}

class FlexibleVectorFileImageSource extends FlexibleFileImageSource {
  const FlexibleVectorFileImageSource({
    required super.file,
    this.colorMapper,
    this.svgTheme,
  });

  final ColorMapper? colorMapper;
  final SvgTheme? svgTheme;

  @override
  List<Object?> get props => [...super.props, colorMapper, svgTheme];
}
