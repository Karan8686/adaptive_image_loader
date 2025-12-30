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

  /// Cached image callbacks
  final Widget Function(BuildContext, String)? cachedPlaceholder;
  final Widget Function(BuildContext, String, dynamic)? cachedErrorWidget;

  /// Normal image callback
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
    this.cachedPlaceholder,
    this.cachedErrorWidget,
    this.imageErrorBuilder,
  });

  /// Normal public image (no cache)
  static Widget image(
    String url, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    ImageErrorWidgetBuilder? errorBuilder,
    bool useCache =
        false, // 👈 expose the flag (default: false for backward compat)
  }) {
    return AdaptiveImage._(
      key: key,
      url: url,
      isDrive: false,
      isDropbox: false,
      useCache: useCache, // ✅ now controllable
      width: width,
      height: height,
      fit: fit,
      imageErrorBuilder: errorBuilder,
    );
  }

  /// Google Drive image (cached by default)
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

  /// Dropbox image (cached by default)
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
            (context, _) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            cachedErrorWidget ?? (context, _, error) => const Icon(Icons.error),
      );
    }

    return Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder:
          imageErrorBuilder ??
          (context, error, stackTrace) => const Icon(Icons.error),
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
    if (url.contains('?dl=1') || url.contains('&dl=1')) {
      return url;
    }
    if (url.contains('?dl=0')) {
      return url.replaceFirst('?dl=0', '?dl=1');
    }
    if (url.contains('&dl=0')) {
      return url.replaceFirst('&dl=0', '&dl=1');
    }
    return url.contains('?') ? '$url&dl=1' : '$url?dl=1';
  }
}
