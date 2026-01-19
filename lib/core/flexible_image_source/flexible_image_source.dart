import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';

part 'flexible_vector_image_source.dart';
part 'flexible_bitmap_image_source.dart';

sealed class FlexibleImageSource with EquatableMixin {
  const FlexibleImageSource();

  bool get isSupported => this is! FlexibleUnsupportedImageSource;

  bool get isNotSupported => !isSupported;

  bool get isVector => fileFormat.isVectorImage;

  bool get isBitmap => fileFormat.isRasterImage;

  FileFormat get fileFormat {
    final source = this;
    return switch (source) {
      FlexibleUnsupportedImageSource _ => source._fileFormat,
      FlexibleAssetImageSource _ => FileFormat.fromFilename(source.source),
      FlexibleNetworkImageSource _ => FileFormat.fromFilename(source.url),
      FlexibleMemoryImageSource _ => FileFormat.fromBytes(source.bytes),
      FlexibleFileImageSource _ => FileFormat.fromFilename(source.file.path),
    };
  }

  SvgLoader? get vectorProvider {
    final source = this;
    return switch (source) {
      FlexibleUnsupportedImageSource _ => null,
      FlexibleBitmapAssetImageSource _ => null,
      FlexibleBitmapNetworkImageSource _ => null,
      FlexibleBitmapMemoryImageSource _ => null,
      FlexibleBitmapFileImageSource _ => null,
      FlexibleVectorAssetImageSource _ => SvgAssetLoader(
          source.source,
          assetBundle: source.bundle,
          colorMapper: source.colorMapper,
          packageName: source.packageName,
          theme: source.svgTheme,
        ) as SvgLoader,
      FlexibleVectorMemoryImageSource _ => SvgBytesLoader(
          source.bytes,
          colorMapper: source.colorMapper,
          theme: source.svgTheme,
        ),
      FlexibleVectorNetworkImageSource _ => SvgNetworkLoader(
          source.url,
          colorMapper: source.colorMapper,
          headers: source.headers,
          httpClient: source.client,
          theme: source.svgTheme,
        ),
      FlexibleVectorFileImageSource _ => SvgFileLoader(
          source.file,
          colorMapper: source.colorMapper,
          theme: source.svgTheme,
        ),
    };
  }

  ImageProvider<Object>? get bitmapProvider {
    final source = this;
    return switch (source) {
      FlexibleUnsupportedImageSource _ => null,
      FlexibleVectorFileImageSource _ => null,
      FlexibleVectorAssetImageSource _ => null,
      FlexibleVectorMemoryImageSource _ => null,
      FlexibleVectorNetworkImageSource _ => null,
      FlexibleBitmapAssetImageSource _ => AssetImage(
          source.source,
          bundle: source.bundle,
          package: source.packageName,
        ) as ImageProvider,
      FlexibleBitmapNetworkImageSource _ => CachedNetworkImageProvider(
          source.url,
          headers: source.headers,
          scale: source.scale,
          cacheKey: source.cacheKey,
          cacheManager: source.cacheManager,
          errorListener: source.errorListener,
          imageRenderMethodForWeb: source.imageRenderMethodForWeb,
          maxHeight: source.maxHeight,
          maxWidth: source.maxWidth,
        ),
      FlexibleBitmapMemoryImageSource _ => MemoryImage(
          source.bytes,
          scale: source.scale,
        ),
      FlexibleBitmapFileImageSource _ => FileImage(
          source.file,
          scale: source.scale,
        ),
    };
  }

  factory FlexibleImageSource.fromNullableSource(String? source) {
    if (source == null) {
      return FlexibleUnsupportedImageSource(
        fileFormat: FileFormat.emptyUnknown(),
        source: source,
      );
    }
    return FlexibleImageSource.fromSource(source);
  }

  factory FlexibleImageSource.fromSource(String source) {
    final base64Bytes = source.tryBase64Decode;

    FlexibleUnsupportedImageSource? checkSupport(FileFormat fileFormat) {
      if (!fileFormat.isImage) {
        return FlexibleUnsupportedImageSource(
          fileFormat: fileFormat,
          source: source,
        );
      }
      return null;
    }

    if (base64Bytes != null) {
      final fileFormat = base64Bytes.fileFormat;
      return checkSupport(fileFormat) ??
          (fileFormat.isVectorImage
              ? FlexibleVectorMemoryImageSource(bytes: base64Bytes)
              : FlexibleBitmapMemoryImageSource(
                  bytes: base64Bytes,
                ));
    } else if (source.isWebUrl) {
      final fileFormat = FileFormat.fromFilename(source);
      return checkSupport(fileFormat) ??
          (fileFormat.isVectorImage
              ? FlexibleVectorNetworkImageSource(
                  url: source,
                )
              : FlexibleBitmapNetworkImageSource(
                  url: source,
                ));
    } else {
      final fileFormat = FileFormat.fromFilename(source);
      return checkSupport(fileFormat) ??
          (fileFormat.isVectorImage
              ? FlexibleVectorAssetImageSource(
                  source: source,
                )
              : FlexibleBitmapAssetImageSource(
                  source: source,
                ));
    }
  }
}

class FlexibleUnsupportedImageSource extends FlexibleImageSource {
  const FlexibleUnsupportedImageSource({
    required this.source,
    required FileFormat fileFormat,
  }) : _fileFormat = fileFormat;

  final String? source;
  final FileFormat _fileFormat;

  @override
  List<Object?> get props => [source, _fileFormat];
}

sealed class FlexibleAssetImageSource extends FlexibleImageSource {
  const FlexibleAssetImageSource({
    required this.source,
    this.bundle,
    this.packageName,
  });

  final String source;
  final AssetBundle? bundle;
  final String? packageName;

  @override
  List<Object?> get props => [source, bundle, packageName];
}

sealed class FlexibleNetworkImageSource extends FlexibleImageSource {
  const FlexibleNetworkImageSource({
    required this.url,
    this.headers,
  });

  final String url;
  final Map<String, String>? headers;

  @override
  List<Object?> get props => [url, DeepCollectionEquality().hash(headers)];
}

sealed class FlexibleMemoryImageSource extends FlexibleImageSource {
  const FlexibleMemoryImageSource({
    required this.bytes,
  });

  final Uint8List bytes;

  @override
  List<Object?> get props => [DeepCollectionEquality().hash(bytes)];
}

sealed class FlexibleFileImageSource extends FlexibleImageSource {
  const FlexibleFileImageSource({
    required this.file,
  });

  final File file;

  @override
  List<Object?> get props => [file];
}
