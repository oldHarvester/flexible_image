import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toolkit/flutter_toolkit.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';
export 'package:vector_graphics/vector_graphics.dart';

import 'core/flexible_image_source/flexible_image_source.dart';

part 'core/flexible_image_theme.dart';
part 'core/flexible_vector_image_settings.dart';
part 'core/flexible_bitmap_image_settings.dart';

class FlexibleImage extends StatelessWidget {
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

  FlexibleImageThemeData _mergeTheme(BuildContext context) {
    final theme = FlexibleImageTheme.of(context);
    return theme.copyWith(
      alignment: alignment ?? theme.alignment,
      bitmapSettings: bitmapSettings ?? theme.bitmapSettings,
      vectorSettings: vectorSettings ?? theme.vectorSettings,
      blendMode: blendMode ?? theme.blendMode,
      color: color ?? theme.color,
      errorBuilder: errorBuilder ?? theme.errorBuilder,
      fit: fit ?? theme.fit,
      height: height ?? theme.height,
      matchTextDirection: matchTextDirection ?? theme.matchTextDirection,
      placeholderBuilder: placeholderBuilder ?? theme.placeholderBuilder,
      unsupportedBuilder: unsupportedBuilder ?? theme.unsupportedBuilder,
      width: width ?? theme.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _mergeTheme(context);
    final source = this.source;
    final color = this.color;
    final bitmapProvider = source.bitmapProvider;
    final vectorProvider = source.vectorProvider;
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
              loadingBuilder: placeholderBuilder,
              errorBuilder: errorBuilder,
              frameBuilder: frameBuilder,
              semanticLabel: semanticsLabel,
              width: width,
              height: height,
              excludeFromSemantics: excludeFromSemantics,
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
              excludeFromSemantics: excludeFromSemantics,
              matchTextDirection: matchTextDirection,
              semanticsLabel: semanticsLabel,
              width: width,
              height: height,
              alignment: alignment,
              fit: fit,
              colorFilter: colorFilter,
              errorBuilder: errorBuilder,
              placeholderBuilder: (context) =>
                  placeholderBuilder(context, null, null),
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
