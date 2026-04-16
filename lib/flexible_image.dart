import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import 'core/flexible_image_source/flexible_image_source.dart';

export 'package:vector_graphics/vector_graphics.dart';
export 'core/flexible_image_source/flexible_image_source.dart';

part 'core/flexible_image_theme.dart';
part 'core/flexible_vector_image_settings.dart';
part 'core/flexible_bitmap_image_settings.dart';

class FlexibleAsyncImage extends StatelessWidget {
  const FlexibleAsyncImage({
    super.key,
    required this.source,
    this.alignment,
    this.bitmapSettings,
    this.blendMode,
    this.color,
    this.errorBuilder,
    this.excludeFromSemantics = false,
    this.fit,
    this.height,
    this.matchTextDirection,
    this.placeholderBuilder,
    this.semanticsLabel,
    this.unsupportedBuilder,
    this.vectorSettings,
    this.width,
  });

  FlexibleAsyncImage.fromBytes({
    super.key,
    required Future<Uint8List> bytes,
    this.alignment,
    this.bitmapSettings,
    this.blendMode,
    this.color,
    this.errorBuilder,
    this.excludeFromSemantics = false,
    this.fit,
    this.height,
    this.matchTextDirection,
    this.placeholderBuilder,
    this.semanticsLabel,
    this.unsupportedBuilder,
    this.vectorSettings,
    this.width,
  }) : source = bytes.then(
          (value) {
            return FlexibleImageSource.fromBytes(value);
          },
        );

  final Future<FlexibleImageSource> source;
  final FlexibleVectorImageSettings? vectorSettings;
  final FlexibleBitmapImageSettings? bitmapSettings;
  final Alignment? alignment;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? blendMode;
  final BoxFit? fit;
  final FlexibleImageErrorBuilder? errorBuilder;
  final FlexibleImagePlaceholderBuilder? placeholderBuilder;
  final FlexibleImageUnsupportedBuilder? unsupportedBuilder;
  final String? semanticsLabel;
  final bool? matchTextDirection;
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final theme = FlexibleImageTheme.of(context);
    final errorBuilder = this.errorBuilder ?? theme.errorBuilder;
    final placeholderBuilder =
        this.placeholderBuilder ?? theme.placeholderBuilder;

    return SizedBox(
      width: width,
      height: height,
      child: FutureBuilder(
        future: source,
        builder: (context, snapshot) {
          final data = snapshot.data;
          final error = snapshot.error;
          final stackTrace = snapshot.stackTrace;
          if (data == null && error == null && stackTrace == null) {
            return placeholderBuilder(context, null, null, true);
          } else if (data != null) {
            return FlexibleImage(
              source: data,
              alignment: alignment,
              bitmapSettings: bitmapSettings,
              blendMode: blendMode,
              color: color,
              errorBuilder: errorBuilder,
              placeholderBuilder: placeholderBuilder,
              excludeFromSemantics: excludeFromSemantics,
              fit: fit,
              height: height,
              width: width,
              matchTextDirection: matchTextDirection,
              semanticsLabel: semanticsLabel,
              unsupportedBuilder: unsupportedBuilder,
              vectorSettings: vectorSettings,
            );
          } else if (error != null) {
            return errorBuilder(context, error, stackTrace);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class FlexibleImage extends StatefulWidget {
  const FlexibleImage({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.color,
    this.blendMode,
    this.fit,
    this.errorBuilder,
    this.placeholderBuilder,
    this.unsupportedBuilder,
    this.semanticsLabel,
    this.matchTextDirection,
    this.vectorSettings,
    this.bitmapSettings,
    this.excludeFromSemantics = false,
    required this.source,
  });

  FlexibleImage.defineSource({
    super.key,
    required String? source,
    this.alignment,
    this.bitmapSettings,
    this.blendMode,
    this.color,
    this.errorBuilder,
    this.excludeFromSemantics = false,
    this.fit,
    this.height,
    this.matchTextDirection,
    this.placeholderBuilder,
    this.semanticsLabel,
    this.unsupportedBuilder,
    this.vectorSettings,
    this.width,
  }) : source = FlexibleImageSource.fromNullableSource(source);

  final FlexibleImageSource source;
  final FlexibleVectorImageSettings? vectorSettings;
  final FlexibleBitmapImageSettings? bitmapSettings;
  final Alignment? alignment;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? blendMode;
  final BoxFit? fit;
  final FlexibleImageErrorBuilder? errorBuilder;
  final FlexibleImagePlaceholderBuilder? placeholderBuilder;
  final FlexibleImageUnsupportedBuilder? unsupportedBuilder;
  final String? semanticsLabel;
  final bool? matchTextDirection;
  final bool excludeFromSemantics;

  @override
  State<FlexibleImage> createState() => _FlexibleImageState();
}

class _FlexibleImageState extends State<FlexibleImage> {
  late ImageProvider<Object>? _imageProvider;
  late SvgLoader? _vectorProvider;

  @override
  void initState() {
    super.initState();
    _setProvider();
  }

  @override
  void didUpdateWidget(covariant FlexibleImage oldWidget) {
    if (widget.source.isBitmap != widget.source.isBitmap) {
      _setProvider();
    } else {
      switch (widget.source) {
        case FlexibleMemoryImageSource _:
          if (widget.source != oldWidget.source) {
            _setProvider();
          }
          break;
        default:
          _setProvider();
          break;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setProvider() {
    _imageProvider =
        widget.source.isBitmap ? widget.source.buildBitmapProvider() : null;
    _vectorProvider =
        widget.source.isVector ? widget.source.buildVectorProvider() : null;
  }

  FlexibleImageThemeData _mergeTheme(BuildContext context) {
    final theme = FlexibleImageTheme.of(context);
    return theme.copyWith(
      alignment: widget.alignment ?? theme.alignment,
      bitmapSettings: widget.bitmapSettings ?? theme.bitmapSettings,
      vectorSettings: widget.vectorSettings ?? theme.vectorSettings,
      blendMode: widget.blendMode ?? theme.blendMode,
      color: widget.color ?? theme.color,
      errorBuilder: widget.errorBuilder ?? theme.errorBuilder,
      fit: widget.fit ?? theme.fit,
      height: widget.height ?? theme.height,
      matchTextDirection: widget.matchTextDirection ?? theme.matchTextDirection,
      placeholderBuilder: widget.placeholderBuilder ?? theme.placeholderBuilder,
      unsupportedBuilder: widget.unsupportedBuilder ?? theme.unsupportedBuilder,
      width: widget.width ?? theme.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _mergeTheme(context);
    final source = widget.source;
    final color = widget.color;
    final bitmapProvider = _imageProvider;
    final vectorProvider = _vectorProvider;
    final placeholderBuilder = theme.placeholderBuilder;
    final errorBuilder = theme.errorBuilder;
    final unsupportedBuilder = theme.unsupportedBuilder;
    final bitmapSettings = theme.bitmapSettings;
    final vectorSettings = theme.vectorSettings;
    final blendMode = theme.blendMode;
    final alignment = theme.alignment;
    final fit = theme.fit;
    final matchTextDirection = theme.matchTextDirection;
    final frameBuilder = bitmapSettings.frameBuilder;
    final colorFilter = color == null
        ? null
        : ColorFilter.mode(
            color,
            blendMode ?? BlendMode.srcIn,
          );
    return FlexibleImageTheme(
      data: theme,
      child: Builder(
        builder: (context) {
          if (bitmapProvider != null) {
            return Image(
              image: bitmapProvider,
              centerSlice: bitmapSettings.centerSlice,
              filterQuality: bitmapSettings.filterQuality,
              gaplessPlayback: bitmapSettings.gaplessPlayback,
              isAntiAlias: bitmapSettings.isAntiAlias,
              opacity: bitmapSettings.opacity,
              repeat: bitmapSettings.repeat,
              loadingBuilder: (context, child, loadingProgress) {
                final expectedBytes = loadingProgress?.expectedTotalBytes;
                final loadedBytes = loadingProgress?.cumulativeBytesLoaded;
                final bytesLoading = expectedBytes != null &&
                    loadedBytes != null &&
                    loadedBytes < expectedBytes;
                return placeholderBuilder.call(
                  context,
                  child,
                  loadingProgress,
                  bytesLoading,
                );
              },
              errorBuilder: errorBuilder,
              frameBuilder: frameBuilder,
              semanticLabel: widget.semanticsLabel,
              width: widget.width,
              height: widget.height,
              excludeFromSemantics: widget.excludeFromSemantics,
              color: color,
              fit: fit,
              colorBlendMode: blendMode,
              alignment: alignment,
              matchTextDirection: matchTextDirection,
            );
          } else if (vectorProvider != null) {
            return SvgPicture(
              vectorProvider,
              renderingStrategy: vectorSettings.renderingStrategy,
              allowDrawingOutsideViewBox:
                  vectorSettings.allowDrawingOutsideViewBox,
              clipBehavior: vectorSettings.clipBehavior,
              excludeFromSemantics: widget.excludeFromSemantics,
              matchTextDirection: matchTextDirection,
              semanticsLabel: widget.semanticsLabel,
              width: widget.width,
              height: widget.height,
              alignment: alignment,
              fit: fit,
              colorFilter: colorFilter,
              errorBuilder: errorBuilder,
              placeholderBuilder: (context) =>
                  placeholderBuilder(context, null, null, true),
            );
          } else if (source is FlexibleUnsupportedImageSource) {
            return unsupportedBuilder(context, source);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
