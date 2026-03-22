import 'package:flutter/material.dart';
import 'package:kpostal_plus/kpostal_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kpostal_plus Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Kpostal? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('kpostal_plus Example'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚀 kpostal_plus',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Korean Postal Address Search\nCross-platform support for iOS, Android, and Web',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Search Buttons
            _buildSearchButton(
              context,
              title: 'Basic Search',
              subtitle: 'Using default settings',
              icon: Icons.search,
              color: Colors.blue,
              onPressed: () => _searchBasic(context),
            ),
            const SizedBox(height: 12),

            _buildSearchButton(
              context,
              title: 'With Local Server',
              subtitle: 'Using localhost:8080',
              icon: Icons.dns,
              color: Colors.green,
              onPressed: () => _searchWithLocalServer(context),
            ),
            const SizedBox(height: 12),

            _buildSearchButton(
              context,
              title: 'With Custom UI',
              subtitle: 'Custom AppBar colors',
              icon: Icons.palette,
              color: Colors.purple,
              onPressed: () => _searchWithCustomUI(context),
            ),
            const SizedBox(height: 12),

            _buildSearchButton(
              context,
              title: 'With Kakao Geocoding',
              subtitle: 'Get accurate coordinates (requires API key)',
              icon: Icons.location_on,
              color: Colors.orange,
              onPressed: () => _searchWithKakaoKey(context),
            ),
            const SizedBox(height: 24),

            // Results Display
            if (_selectedAddress != null) ...[
              const Divider(height: 48),
              _buildResultCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_selectedAddress == null) return const SizedBox.shrink();
    final address = _selectedAddress!;

    return Card(
      color: Colors.green[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Selected Address',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildResultRow('📮 Postal Code', address.postCode),
            _buildResultRow('🛣️ Road Address', address.roadAddress),
            _buildResultRow('🏘️ Jibun Address', address.jibunAddress),
            if (address.buildingName.isNotEmpty)
              _buildResultRow('🏢 Building', address.buildingName),
            _buildResultRow('📍 Region', '${address.sido} ${address.sigungu}'),

            // Geocoding results
            if (address.latitude != null || address.kakaoLatitude != null) ...[
              const Divider(height: 24),
              const Text(
                '📍 Coordinates',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (address.latitude != null)
              _buildResultRow(
                '  • Platform',
                '${address.latitude!.toStringAsFixed(6)}, ${address.longitude!.toStringAsFixed(6)}',
              ),
            if (address.kakaoLatitude != null)
              _buildResultRow(
                '  • Kakao',
                '${address.kakaoLatitude!.toStringAsFixed(6)}, ${address.kakaoLongitude!.toStringAsFixed(6)}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Search Methods

  void _searchBasic(BuildContext context) async {
    final result = await Navigator.push<Kpostal>(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalPlusView(
          callback: (Kpostal result) {
            setState(() => _selectedAddress = result);
          },
        ),
      ),
    );
    if (result != null) {
      setState(() => _selectedAddress = result);
    }
  }

  void _searchWithLocalServer(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalPlusView(
          useLocalServer: true,
          localPort: 8080,
          callback: (Kpostal result) {
            setState(() => _selectedAddress = result);
          },
        ),
      ),
    );
  }

  void _searchWithCustomUI(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalPlusView(
          title: 'Custom Address Search',
          appBarColor: Colors.purple,
          titleColor: Colors.white,
          loadingColor: Colors.purple,
          callback: (Kpostal result) {
            setState(() => _selectedAddress = result);
          },
        ),
      ),
    );
  }

  void _searchWithKakaoKey(BuildContext context) async {
    // Show dialog to inform user
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ API Key Required'),
        content: const Text(
          'To use Kakao geocoding, you need to:\n\n'
          '1. Get a Kakao JavaScript API key from:\n'
          '   https://developers.kakao.com\n\n'
          '2. Add the key to the code:\n'
          '   kakaoKey: \'YOUR_KEY_HERE\'\n\n'
          '3. Register your domain in Kakao console:\n'
          '   • For local: http://localhost:8080\n'
          '   • For web: https://your-domain.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Uncomment and add your Kakao API key to use this feature
    /*
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalPlusView(
          kakaoKey: 'YOUR_KAKAO_JAVASCRIPT_KEY',
          callback: (Kpostal result) {
            setState(() => _selectedAddress = result);
          },
        ),
      ),
    );
    */
  }
}
