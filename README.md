# Adaptive Image Loader 🖼️

A **drop-in replacement for `Image.network`** that automatically handles  
**Google Drive, Dropbox, and normal image URLs**, with optional caching support.

No more broken preview links or manual URL conversions.

---

## ✨ Features

- ✅ Works like `Image.network`
- 🔗 Automatically parses:
  - Google Drive share links
  - Dropbox share links
  - Normal public image URLs
- 🚀 Optional image caching using `cached_network_image`
- 🔄 Turn cache **ON / OFF** using a single boolean
- 📦 Lightweight and production-ready
- 💙 Null-safe

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  adaptive_image_loader: ^1.0.0
