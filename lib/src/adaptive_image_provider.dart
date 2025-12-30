import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdaptiveImageProvider extends ImageProvider<AdaptiveImageProvider> {
  final String url;
  final bool useCache;

  const AdaptiveImageProvider(this.url, {this.useCache = true});

  // Required by ImageProvider
  @override
  Future<AdaptiveImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AdaptiveImageProvider>(this);
  }

  // Flutter 3.x+ API
  @override
  ImageStreamCompleter loadImage(
    AdaptiveImageProvider key,
    ImageDecoderCallback decode,
  ) {
    final resolvedUrl = _resolveUrl(url);

    final ImageProvider provider = useCache
        ? CachedNetworkImageProvider(resolvedUrl)
        : NetworkImage(resolvedUrl);

    return provider.loadImage(provider, decode);
  }

  // Important for image cache correctness
  @override
  bool operator ==(Object other) {
    return other is AdaptiveImageProvider &&
        other.url == url &&
        other.useCache == useCache;
  }

  @override
  int get hashCode => Object.hash(url, useCache);

  // ---- URL helpers ----

  static String _resolveUrl(String url) {
    if (_isDrive(url)) {
      return _convertDriveLink(url);
    }
    if (_isDropbox(url)) {
      return _convertDropboxLink(url);
    }
    return url;
  }

  static bool _isDrive(String url) => url.contains('drive.google.com');

  static bool _isDropbox(String url) => url.contains('dropbox.com');

  static String _convertDriveLink(String url) {
    final match = RegExp(
      r'https://drive\.google\.com/file/d/([^/\?&]+)',
    ).firstMatch(url);

    if (match != null) {
      return 'https://drive.google.com/uc?export=view&id=${match.group(1)}';
    }
    return url;
  }

  static String _convertDropboxLink(String url) {
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
