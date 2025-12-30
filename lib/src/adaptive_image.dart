import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdaptiveImage extends StatelessWidget {
  final String url;
  final bool isDrive;
  final bool isDropbox;
  final bool useCache;

  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Color? color;
  final BlendMode? colorBlendMode;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final FilterQuality filterQuality;
  final bool excludeFromSemantics;
  final String? semanticLabel;

  /// 🔹 Cached image callbacks (for CachedNetworkImage)
  final Widget Function(BuildContext, String)? cachedPlaceholder;
  final Widget Function(BuildContext, String, dynamic)? cachedErrorWidget;

  /// 🔹 Normal image callback (for Image.network)
  final ImageErrorWidgetBuilder? imageErrorBuilder;

  const AdaptiveImage._({
    super.key,
    required this.url,
    required this.isDrive,
    required this.isDropbox,
    required this.useCache,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.color,
    this.colorBlendMode,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.excludeFromSemantics = false,
    this.semanticLabel,
    this.cachedPlaceholder,
    this.cachedErrorWidget,
    this.imageErrorBuilder,
  });

  /// Normal public image (non-cached by default)
  static Widget image(
    String url, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    ImageErrorWidgetBuilder? errorBuilder,
  }) {
    return AdaptiveImage._(
      key: key,
      url: url,
      isDrive: false,
      isDropbox: false,
      useCache: false,
      width: width,
      height: height,
      fit: fit,
      imageErrorBuilder: errorBuilder,
    );
  }

  /// Google Drive image — uses caching by default
  static Widget driveImage(
    String url, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    bool useCache = true,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    return AdaptiveImage._(
      key: key,
      url: url,
      isDrive: true,
      isDropbox: false,
      useCache: useCache,
      width: width,
      height: height,
      fit: fit,
      cachedPlaceholder: placeholder,
      cachedErrorWidget: errorWidget,
    );
  }

  /// Dropbox image — uses caching by default
  static Widget dropboxImage(
    String url, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    bool useCache = true,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    return AdaptiveImage._(
      key: key,
      url: url,
      isDrive: false,
      isDropbox: true,
      useCache: useCache,
      width: width,
      height: height,
      fit: fit,
      cachedPlaceholder: placeholder,
      cachedErrorWidget: errorWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    String resolvedUrl = url;
    if (isDrive) {
      resolvedUrl = _convertDriveLink(url);
    } else if (isDropbox) {
      resolvedUrl = _convertDropboxLink(url);
    }

    if (useCache) {
      return CachedNetworkImage(
        imageUrl: resolvedUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder:
            cachedPlaceholder ??
            (_, __) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            cachedErrorWidget ?? (_, __, ___) => const Icon(Icons.error),
      );
    }

    return Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      color: color,
      colorBlendMode: colorBlendMode,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
      excludeFromSemantics: excludeFromSemantics,
      semanticLabel: semanticLabel,
      errorBuilder:
          imageErrorBuilder ?? (_, __, ___) => const Icon(Icons.error),
    );
  }

  String _convertDriveLink(String url) {
    final match = RegExp(
      r'https://drive\.google\.com/file/d/([^/\?&]+)',
    ).firstMatch(url);
    if (match != null) {
      return 'https://drive.google.com/uc?export=download&id=${match.group(1)}';
    }
    return url;
  }

  String _convertDropboxLink(String url) {
    // If already direct, return as-is
    if (url.contains('?dl=1') || url.contains('&dl=1')) {
      return url;
    }
    // Replace dl=0 with dl=1
    if (url.contains('?dl=0')) {
      return url.replaceFirst('?dl=0', '?dl=1');
    }
    if (url.contains('&dl=0')) {
      return url.replaceFirst('&dl=0', '&dl=1');
    }
    // Append dl=1
    if (url.contains('?')) {
      return '$url&dl=1';
    } else {
      return '$url?dl=1';
    }
  }
}
