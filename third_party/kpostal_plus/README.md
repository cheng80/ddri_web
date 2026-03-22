[![pub package](https://img.shields.io/pub/v/kpostal_plus.svg?label=kpostal_plus&color=blue)](https://pub.dev/packages/kpostal_plus)
[![Pub Likes](https://img.shields.io/pub/likes/kpostal_plus)](https://pub.dev/packages/kpostal_plus/score)

[![English](https://img.shields.io/badge/Language-English-9cf?style=for-the-badge)](README.md)
[![Korean](https://img.shields.io/badge/Language-Korean-9cf?style=for-the-badge)](README.ko-kr.md)

# kpostal_plus

A **cross-platform** Flutter package for Korean postal address search using [Kakao postcode service](https://postcode.map.daum.net/guide). Enhanced version of `kpostal` with full mobile and web support in a single unified package.

## Features

- 📱 **Cross-platform support**: Works seamlessly on **iOS**, **Android**, and **Web** platforms
- 🔍 **Korean address search**: Powered by Kakao postcode service with real-time search
- 🌐 **Native web integration**: DOM manipulation for optimal web performance
- 📍 **Optional geocoding**: Get latitude/longitude coordinates
  - Platform geocoding (iOS/Android native)
  - Kakao geocoding API (higher accuracy for Korean addresses)
- 🛡️ **Null-safe**: Full null safety support
- 🎯 **Unified API**: Single package for all platforms - no platform-specific dependencies
- 🎨 **Customizable UI**: Configurable AppBar, colors, and loading indicators
- 🌐 **Local server support**: Optional localhost hosting for offline-capable apps
- 🔄 **Flexible callbacks**: Both callback and Navigator.pop return value support

## Screenshots

### Mobile

![Search Screen](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_app.png)

![Search Result](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_result_app.png)

![Custom UI](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/custom_search_app.png)

![API Key Dialog](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/need_api_app.png)

### Web

![Web Search](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_web.png)

![Web Result](https://raw.githubusercontent.com/pyowonsik/kpostal_plus/main/screenshots/search_result_web.png)

## Installation

Add `kpostal_plus` to your `pubspec.yaml` file:

```yaml
dependencies:
  kpostal_plus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Platform Support

| Platform    | Support | Notes                                    |
| ----------- | ------- | ---------------------------------------- |
| **Android** | ✅      | Requires internet permission             |
| **iOS**     | ✅      | Full support                             |
| **Web**     | ✅      | Native DOM integration                   |
| macOS       | ❌      | Not supported                            |
| Windows     | ❌      | Not supported                            |
| Linux       | ❌      | Not supported                            |

## Setup

### 🤖 Android

Add internet permission to your `AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <!-- ... -->
</manifest>
```

#### For Local Server (Optional)

If you want to use local server hosting (`useLocalServer: true`), add:

```xml
<application
    android:label="your_app"
    android:icon="@mipmap/ic_launcher"
    android:usesCleartextTraffic="true">
    <!-- ... -->
</application>
```

### 🍎 iOS

No additional setup required for basic usage.

#### For Geocoding (Optional)

If you want to use platform geocoding, add location permissions to your `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to provide accurate address information</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to provide accurate address information</string>
```

#### For Local Server (Optional)

Add `NSAppTransportSecurity` to your `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### 🌐 Web

No additional setup required. The package automatically handles web integration using native DOM manipulation.

### 🗺️ Kakao Geocoding (Optional)

For better geocoding accuracy with Korean addresses:

1. Go to [Kakao Developer Site](https://developers.kakao.com)
2. Register as a developer and create an app
3. Add Web Platform and register domain:
   - For GitHub hosting: `https://tykann.github.io`
   - For local server: `http://localhost:8080`
4. Get your **JavaScript key** from the "App Keys" section
5. Use it in your code:

```dart
KpostalPlusView(
  kakaoKey: 'YOUR_KAKAO_JAVASCRIPT_KEY',
  callback: (result) {
    // result.kakaoLatitude and result.kakaoLongitude will be available
  },
)
```

> **Note**: For open-source projects, use environment variables or user configuration instead of hardcoding API keys.

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:kpostal_plus/kpostal_plus.dart';

// Using callback
TextButton(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalPlusView(
          callback: (Kpostal result) {
            print('Postal Code: ${result.postCode}');
            print('Address: ${result.address}');
            print('Coordinates: ${result.latitude}, ${result.longitude}');
          },
        ),
      ),
    );
  },
  child: Text('Search Address'),
)

// Using return value
TextButton(
  onPressed: () async {
    Kpostal? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KpostalPlusView()),
    );
    if (result != null) {
      print('Selected address: ${result.address}');
    }
  },
  child: Text('Search Address'),
)
```

### Advanced Usage

```dart
KpostalPlusView(
  // [Optional] Custom AppBar
  title: '주소 검색',
  appBarColor: Colors.blue,
  titleColor: Colors.white,
  
  // [Optional] Or use custom AppBar widget
  appBar: AppBar(
    title: Text('Custom AppBar'),
    backgroundColor: Colors.green,
  ),
  
  // [Optional] Enable local server mode
  useLocalServer: true,
  localPort: 8080, // Default: 8080 (range: 1024-49151)
  
  // [Optional] Kakao JavaScript API key for geocoding
  kakaoKey: 'YOUR_KAKAO_JS_KEY',
  
  // [Optional] Custom loading indicator
  loadingColor: Colors.blue,
  onLoading: CircularProgressIndicator(color: Colors.red),
  
  // Callback
  callback: (Kpostal result) {
    print('🏠 Address Information:');
    print('Postal Code: ${result.postCode}');
    print('Road Address: ${result.roadAddress}');
    print('Jibun Address: ${result.jibunAddress}');
    print('Building Name: ${result.buildingName}');
    
    // Platform geocoding (may be null)
    print('Lat/Lng: ${result.latitude}, ${result.longitude}');
    
    // Kakao geocoding (if kakaoKey provided)
    print('Kakao Lat/Lng: ${result.kakaoLatitude}, ${result.kakaoLongitude}');
  },
)
```

### Use Cases

```dart
// 📮 For delivery address
KpostalPlusView(
  title: 'Delivery Address',
  callback: (result) {
    saveDeliveryAddress(
      postCode: result.postCode,
      address: result.address,
    );
  },
)

// 🏢 For company/store registration
KpostalPlusView(
  title: 'Register Store Location',
  kakaoKey: 'YOUR_KEY',
  callback: (result) {
    registerStore(
      name: storeName,
      address: result.address,
      latitude: result.kakaoLatitude ?? result.latitude,
      longitude: result.kakaoLongitude ?? result.longitude,
    );
  },
)

// 🗺️ For map integration
KpostalPlusView(
  kakaoKey: 'YOUR_KEY', // Required for coordinates
  callback: (result) {
    showOnMap(
      latitude: result.kakaoLatitude ?? result.latitude ?? 0,
      longitude: result.kakaoLongitude ?? result.longitude ?? 0,
    );
  },
)
```

## Parameters

### KpostalPlusView

| Parameter       | Type                        | Default          | Description                                               |
| --------------- | --------------------------- | ---------------- | --------------------------------------------------------- |
| title           | String                      | '주소검색'       | AppBar title text                                         |
| appBarColor     | Color                       | Colors.white     | AppBar background color                                   |
| titleColor      | Color                       | Colors.black     | AppBar title and icon color                               |
| appBar          | PreferredSizeWidget?        | null             | Custom AppBar (overrides title, appBarColor, titleColor)  |
| callback        | void Function(Kpostal)?     | null             | Callback when address is selected                         |
| useLocalServer  | bool                        | false            | Use localhost server instead of GitHub hosting            |
| localPort       | int                         | 8080             | Localhost port number (1024-49151)                        |
| loadingColor    | Color                       | Colors.blue      | Loading indicator color                                   |
| onLoading       | Widget?                     | null             | Custom loading widget (overrides loadingColor)            |
| kakaoKey        | String                      | ''               | Kakao JavaScript API key for geocoding                    |

### Kpostal Model

```dart
class Kpostal {
  // Basic Information
  String postCode;              // Postal code (우편번호)
  String address;               // Full address (전체 주소)
  String addressEng;            // Address in English
  String roadAddress;           // Road address (도로명 주소)
  String roadAddressEng;        // Road address in English
  String jibunAddress;          // Jibun address (지번 주소)
  String jibunAddressEng;       // Jibun address in English
  String autoJibunAddress;      // Auto jibun address
  String autoJibunAddressEnglish; // Auto jibun address in English
  
  // Building Information
  String buildingCode;          // Building code
  String buildingName;          // Building name
  String apartment;             // Is apartment (Y/N)
  
  // Address Type
  String addressType;           // R (road) or J (jibun)
  String userSelectedType;      // User selected type (R/J)
  
  // Region Information
  String sido;                  // City/Province (시/도)
  String sidoEng;              // City/Province in English
  String sigungu;              // District (시/군/구)
  String sigunguEng;           // District in English
  String sigunguCode;          // District code
  String bcode;                // B code
  String bname;                // Dong/Eup/Myeon (동/읍/면)
  String bnameEng;             // Dong/Eup/Myeon in English
  String bname1;               // Bname1
  
  // Road Information
  String roadnameCode;         // Road name code
  String roadname;             // Road name
  String roadnameEng;          // Road name in English
  
  // Additional
  String zonecode;             // Zone code
  String query;                // Search query
  String userLanguageType;     // User language type (K/E)
  
  // Geocoding (may be null)
  double? latitude;            // Platform geocoding latitude
  double? longitude;           // Platform geocoding longitude
  double? kakaoLatitude;       // Kakao geocoding latitude (if kakaoKey provided)
  double? kakaoLongitude;      // Kakao geocoding longitude (if kakaoKey provided)
  
  // Methods
  Future<Location?> get latLng; // Get platform geocoding result
  String get userSelectedAddress; // Get user selected address (road or jibun)
}
```

## Geocoding Support

### Platform Geocoding (Free, No API Key)

Uses native iOS (CoreLocation) and Android (Geocoder) services:

- ✅ **Pros**: Free, no API key needed
- ❌ **Cons**: Less accurate for Korean addresses, may fail, not supported on web

**Example:**
```dart
KpostalPlusView(
  callback: (result) {
    // May be null if geocoding fails
    print('Lat: ${result.latitude}');
    print('Lng: ${result.longitude}');
  },
)
```

### Kakao Geocoding (Requires API Key)

Uses Kakao's geocoding service:

- ✅ **Pros**: High accuracy for Korean addresses, works on all platforms (web/mobile)
- ✅ **Pros**: More reliable results
- ⚠️ **Note**: Requires Kakao JavaScript API key

> 📌 **Coming in v1.1.0**: Fully tested example with working Kakao API key integration and detailed setup guide.

**Example:**
```dart
KpostalPlusView(
  kakaoKey: 'YOUR_KAKAO_JAVASCRIPT_KEY',
  callback: (result) {
    // More reliable for Korean addresses
    print('Kakao Lat: ${result.kakaoLatitude}');
    print('Kakao Lng: ${result.kakaoLongitude}');
  },
)
```

### Recommendation

| Use Case | Recommendation |
| -------- | -------------- |
| Just need address text | No geocoding needed ✅ |
| Show location on map | Use Kakao geocoding ⭐ |
| Distance calculation | Use Kakao geocoding ⭐ |
| Route navigation | Use Kakao geocoding ⭐ |
| Web platform | Use Kakao geocoding (required) ⭐ |

## Local Server vs GitHub Hosting

### GitHub Hosting (Default)

```dart
KpostalPlusView(
  // Uses: https://tykann.github.io/kpostal/assets/kakao_postcode.html
  callback: (result) { /* ... */ },
)
```

- ✅ **Pros**: No additional setup, always available
- ✅ **Pros**: Faster initial load
- ❌ **Cons**: Depends on GitHub Pages availability
- ❌ **Cons**: Cannot modify HTML

### Local Server

```dart
KpostalPlusView(
  useLocalServer: true,
  localPort: 8080,
  callback: (result) { /* ... */ },
)
```

- ✅ **Pros**: Works offline (once HTML is loaded)
- ✅ **Pros**: Full control over HTML
- ✅ **Pros**: No external dependencies
- ❌ **Cons**: Requires additional platform setup (cleartext traffic)
- ❌ **Cons**: Slightly slower initial load

## Migration Guide

### From `kpostal` or `kpostal_web`

1. **Update `pubspec.yaml`:**

```yaml
dependencies:
  # Remove:
  # kpostal: ^x.x.x
  # kpostal_web: ^x.x.x
  
  # Add:
  kpostal_plus: ^1.0.0
```

2. **Update imports:**

```dart
// Old
import 'package:kpostal/kpostal.dart';
// or
import 'package:kpostal_web/kpostal_web.dart';

// New
import 'package:kpostal_plus/kpostal_plus.dart';
```

3. **Update class name:**

```dart
// Old (kpostal)
KpostalView(
  callback: (result) { /* ... */ },
)

// New (kpostal_plus)
KpostalPlusView(
  callback: (result) { /* ... */ },
)
```

4. **API remains the same!** Only class name changed - all parameters and callbacks work identically.

4. **New features available:**
   - Unified mobile + web support
   - Better error handling
   - Improved geocoding
   - More customization options

## Example

See the [`example/`](example/) directory for a complete working example app.

## Testing

Run tests:

```bash
flutter test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the original [kpostal](https://pub.dev/packages/kpostal) package by TykanN
- Built with [Kakao Postcode Service](https://postcode.map.daum.net/guide)
- Thanks to all contributors and users! 🎉

## Related Packages

- [kpostal](https://pub.dev/packages/kpostal) - Original mobile-only package
- [kpostal_web](https://pub.dev/packages/kpostal_web) - Original web-only package
- [geocoding](https://pub.dev/packages/geocoding) - Platform geocoding (used internally)
- [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview) - WebView for mobile (used internally)

## Support

If you encounter any issues or have feature requests, please file an issue on the [GitHub repository](https://github.com/pyowonsik/kpostal_plus/issues).

## Roadmap

### Upcoming in v1.1.0

- 🗺️ **Kakao Geocoding Examples**: Add fully tested examples with Kakao API key integration
- 📍 **Enhanced Geocoding Documentation**: Detailed guide for setting up and using Kakao geocoding
- 🧪 **Geocoding Integration Tests**: Comprehensive tests for both platform and Kakao geocoding

### Future Plans

- 🌍 Multi-language support (Japanese, Chinese)
- 🎨 Additional UI customization options
- 📦 Reduce package size
- ⚡ Performance optimizations

---

Made with ❤️ for the Flutter community
