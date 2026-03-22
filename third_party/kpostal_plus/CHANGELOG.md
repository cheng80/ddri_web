## 1.0.3

### 💥 Breaking Changes

- **Rename `KpostalView` to `KpostalPlusView`**: Class name changed to better reflect the package name
  - Migration: Replace all `KpostalView` with `KpostalPlusView` in your code
  - Example: `KpostalView(...)` → `KpostalPlusView(...)`

### 🐛 Bug Fixes

- Fix screenshot display on pub.dev by using GitHub raw URLs
- Update README to use markdown image syntax for better compatibility

## 1.0.2

### 🐛 Bug Fixes

- Fix screenshot paths for pub.dev compatibility
- Add screenshots to assets

## 1.0.1

### 🐛 Bug Fixes

- Fix screenshot paths for pub.dev compatibility
- Add screenshots to assets

## 1.0.0

### 🎉 INITIAL RELEASE - kpostal_plus

Enhanced version of `kpostal` with full cross-platform support, combining the best of `kpostal` and `kpostal_web` into a single unified package.

### ✨ KEY FEATURES

- **Cross-platform support**: Works seamlessly on mobile (iOS/Android) and web platforms
- **Web integration**: Native web support using Kakao Postcode Service with DOM manipulation
- **Unified API**: Single package that works across all platforms without separate dependencies
- **Korean address search**: Powered by Kakao postcode service
- **Geocoding support**: Get latitude/longitude coordinates (optional Kakao API integration)
- **Null-safe**: Full null safety support

### 🔧 TECHNICAL IMPROVEMENTS

- **Modern web interop**: Uses `dart:js_interop` and `package:web` for robust web integration
- **Conditional imports**: Platform-specific code loading to prevent build errors
- **Memory leak prevention**: Proper cleanup of DOM elements and event listeners
- **Error handling**: Robust null-safe JSON parsing and widget lifecycle management
- **Performance optimization**: Optimized resource usage and improved error handling

### 🛠️ DEPENDENCIES

- Minimum Flutter version: `3.24.0`
- Minimum Dart SDK version: `^3.5.0`
- `flutter_inappwebview: ^6.1.5` for mobile WebView
- `geocoding: ^3.0.0` for coordinate conversion
- `web: ^1.1.0` for modern web support

### 📱 PLATFORM SUPPORT

- ✅ **Android** (API 19+)
- ✅ **iOS** (9.0+)
- ✅ **Web** (Chrome, Safari, Firefox, Edge)

### 🔄 MIGRATION NOTES

If you're migrating from `kpostal` or `kpostal_web`:

1. Update your `pubspec.yaml`:
   ```yaml
   dependencies:
     kpostal_plus: ^1.0.0  # Replace kpostal or kpostal_web
   ```

2. Update imports:
   ```dart
   // Old
   import 'package:kpostal/kpostal.dart';
   // or
   import 'package:kpostal_web/kpostal_web.dart';

   // New
   import 'package:kpostal_plus/kpostal_plus.dart';
   ```

3. The API remains the same - no code changes needed! ✨

### 📝 NOTES

- **Kakao Geocoding**: Full example with working Kakao API key will be added in v1.1.0
- Current version includes all geocoding functionality, API key integration examples coming soon

---

## Upcoming in v1.1.0

### 🗺️ Kakao Geocoding Examples
- Add fully tested example with Kakao JavaScript API key
- Demonstrate accurate coordinate retrieval
- Show platform vs Kakao geocoding comparison

### 📍 Enhanced Documentation
- Detailed Kakao API setup guide with screenshots
- Best practices for API key management
- Production deployment guidelines

---

## Previous Versions (from original kpostal)

## 0.5.1

- fix #12 issue : show representative jibunAddress

## 0.5.0

- remove pubspec.lock from git.
- update dependencies.
- improve method for searching latitude and logitude through geocoding.
  if not found by eng address, retry using kor address.
- log info.

## 0.4.2

- fix a bug below Android 10.

## 0.4.1

- add "bname1" parameter.

## 0.4.0

- remove "webview_flutter" from dependencies.
  all components related to Webview(local hosting, javascript message, view page...) are integrated using "flutter_inappwebview" package.

## 0.3.2

- fix "not callback when geocoding value is null"
- fix protocol error and update html file

## 0.3.1

- fix platform geocoding returns wrong coordinates.
- add kakao geocoding(optional)
- update docs

## 0.3.0

- provides latitude and logitude
- update docs

## 0.2.0

- add search w/ localhost server

## 0.1.3

- update README.md
- add Korean docs
- add 'userSelectedAddress' getter

## 0.1.2

- update docs typo

## 0.1.1

- update docs & fix android bug(can't listen callback)

## 0.1.0

- initial publish
