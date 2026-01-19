part of '../flexible_image.dart';

typedef FlexibleImageErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

typedef FlexibleImagePlaceholderBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  ImageChunkEvent? loadingProgress,
);

typedef FlexibleBitmapImageFrameBuilder = Widget Function(
  BuildContext context,
  Widget child,
  int? frame,
  bool wasSynchronouslyLoaded,
);

typedef FlexibleImageUnsupportedBuilder = Widget Function(
  BuildContext context,
  FlexibleUnsupportedImageSource unsupportedSource,
);

class FlexibleImageTheme extends InheritedWidget {
  const FlexibleImageTheme({
    super.key,
    required super.child,
    required this.data,
  });

  static FlexibleImageThemeData of(
    BuildContext context, {
    bool createDependency = true,
  }) {
    try {
      return InheritedProvider.of<FlexibleImageTheme>(
        context,
        createDependency: createDependency,
      ).data;
    } catch (e) {
      return FlexibleImageThemeData.defaultTheme;
    }
  }

  static FlexibleImageThemeData? maybeOf(
    BuildContext context, {
    bool createDependency = true,
  }) {
    return InheritedProvider.maybeOf(
      context,
      createDependency: createDependency,
    );
  }

  final FlexibleImageThemeData data;

  @override
  bool updateShouldNotify(covariant FlexibleImageTheme oldWidget) {
    return oldWidget.data != data;
  }
}

class FlexibleImageThemeData with EquatableMixin {
  const FlexibleImageThemeData({
    this.vectorSettings = const FlexibleVectorImageSettings(),
    required this.bitmapSettings,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.matchTextDirection = false,
    required this.placeholderBuilder,
    required this.errorBuilder,
    required this.unsupportedBuilder,
    this.height,
    this.width,
    this.color,
    this.blendMode,
  });

  static const _undefined = Object();

  static final FlexibleImageThemeData defaultTheme = FlexibleImageThemeData(
    bitmapSettings: FlexibleBitmapImageSettings(
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
          opacity: frame == null ? 0 : 1,
          child: child,
        );
      },
    ),
    errorBuilder: (context, error, stackTrace) {
      return Text(
        error.toString(),
        textAlign: TextAlign.center,
      );
    },
    placeholderBuilder: (context, child, loadingProgress) {
      return child ?? SizedBox.shrink();
    },
    unsupportedBuilder: (context, unsupportedSource) {
      return Text(
          'Unsupported format - ${unsupportedSource.fileFormat.format}');
    },
  );

  FlexibleImageThemeData copyWith({
    FlexibleVectorImageSettings? vectorSettings,
    FlexibleBitmapImageSettings? bitmapSettings,
    FlexibleImageErrorBuilder? errorBuilder,
    FlexibleImagePlaceholderBuilder? placeholderBuilder,
    FlexibleImageUnsupportedBuilder? unsupportedBuilder,
    Alignment? alignment,
    BoxFit? fit,
    bool? matchTextDirection,
    Object? width = _undefined,
    Object? height = _undefined,
    Object? color = _undefined,
    Object? blendMode = _undefined,
  }) {
    return FlexibleImageThemeData(
      vectorSettings: vectorSettings ?? this.vectorSettings,
      bitmapSettings: bitmapSettings ?? this.bitmapSettings,
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      matchTextDirection: matchTextDirection ?? this.matchTextDirection,
      width: width == _undefined ? this.width : width as double?,
      height: height == _undefined ? this.height : height as double?,
      color: color == _undefined ? this.color : color as Color?,
      blendMode:
          blendMode == _undefined ? this.blendMode : blendMode as BlendMode?,
      errorBuilder: errorBuilder ?? this.errorBuilder,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
      unsupportedBuilder: unsupportedBuilder ?? this.unsupportedBuilder,
    );
  }

  final FlexibleVectorImageSettings vectorSettings;
  final FlexibleBitmapImageSettings bitmapSettings;
  final Alignment alignment;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? blendMode;
  final BoxFit fit;
  final bool matchTextDirection;
  final FlexibleImageErrorBuilder errorBuilder;
  final FlexibleImagePlaceholderBuilder placeholderBuilder;
  final FlexibleImageUnsupportedBuilder unsupportedBuilder;

  @override
  List<Object?> get props => [
        vectorSettings,
        bitmapSettings,
        alignment,
        width,
        height,
        color,
        blendMode,
        fit,
        matchTextDirection,
        errorBuilder,
        placeholderBuilder,
        unsupportedBuilder,
      ];
}
