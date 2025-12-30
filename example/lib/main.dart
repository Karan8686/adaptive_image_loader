import 'package:flutter/material.dart';
import 'package:adaptive_image_loader/adaptive_image_loader.dart';

void main() {
  runApp(const MyApp());
}

/// Example application demonstrating all features of adaptive_image_loader.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Adaptive Image Loader Example')),

        // Scrollable list showcasing different image-loading scenarios.
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // -----------------------------------------------------------------
            // Normal web image without caching
            // -----------------------------------------------------------------
            const SectionTitle('Normal Web Image (No Cache)'),

            // Loads a public image URL without disk caching.
            AdaptiveImage.image(
              'https://picsum.photos/300/200',
              width: 300,
              height: 200,
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Normal web image with caching enabled
            // -----------------------------------------------------------------
            const SectionTitle('Normal Web Image (Cached)'),

            // Loads a public image URL with disk caching enabled.
            AdaptiveImage.image(
              'https://picsum.photos/300/201',
              width: 300,
              height: 200,
              useCache: true,
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Google Drive image with caching enabled
            // -----------------------------------------------------------------
            const SectionTitle('Google Drive Image (Cached)'),

            // Loads an image from a Google Drive share link.
            // The link is automatically converted to a direct image URL.
            AdaptiveImage.driveImage(
              'https://drive.google.com/file/d/FILE_ID/view',
              width: 300,
              height: 200,
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Google Drive image with caching disabled
            // -----------------------------------------------------------------
            const SectionTitle('Google Drive Image (Cache Disabled)'),

            // Loads a Google Drive image without disk caching.
            AdaptiveImage.driveImage(
              'https://drive.google.com/file/d/FILE_ID/view',
              width: 300,
              height: 200,
              useCache: false,
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Dropbox image with caching enabled
            // -----------------------------------------------------------------
            const SectionTitle('Dropbox Image (Cached)'),

            // Loads an image from a Dropbox share link.
            // The link is automatically converted to a direct download URL.
            AdaptiveImage.dropboxImage(
              'https://www.dropbox.com/s/FILE_ID/sample.jpg?dl=0',
              width: 300,
              height: 200,
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Circular image using AdaptiveImage widget
            // -----------------------------------------------------------------
            const SectionTitle('Circular Image (Widget + ClipOval)'),

            // Demonstrates circular clipping using ClipOval.
            // Suitable for profile images.
            ClipOval(
              child: AdaptiveImage.driveImage(
                'https://picsum.photos/200',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Background image using AdaptiveImageProvider (cached)
            // -----------------------------------------------------------------
            const SectionTitle('Background Image (Cached ImageProvider)'),

            // Uses AdaptiveImageProvider as a background image.
            // This approach supports disk caching and works with widgets
            // like CircleAvatar and DecorationImage.
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AdaptiveImageProvider(
                  'https://picsum.photos/300',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Background image using AdaptiveImageProvider (cache disabled)
            // -----------------------------------------------------------------
            const SectionTitle('Background Image (Cache Disabled)'),

            // Same background image, but disk caching is disabled.
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AdaptiveImageProvider(
                  'https://picsum.photos/301',
                  useCache: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable section header widget used in the example.
class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
