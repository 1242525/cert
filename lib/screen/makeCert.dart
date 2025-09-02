import 'package:flutter/material.dart';
import '../api/api_service.dart';

class CertDownloadPage extends StatefulWidget {
  const CertDownloadPage({super.key});

  @override
  State<CertDownloadPage> createState() => _CertDownloadPageState();
}

class _CertDownloadPageState extends State<CertDownloadPage> {
  final TextEditingController _commonNameController = TextEditingController();
  final TextEditingController _countryNameController = TextEditingController();

  // UI용 기본값 컨트롤러
  final TextEditingController _provinceNameController = TextEditingController(text: 'Seoul');
  final TextEditingController _localNameController = TextEditingController(text: 'Gangnam');
  final TextEditingController _orgNameController = TextEditingController(text: 'MyOrganization');

  String _Error = '';
  bool _isLoading = false;

  void _onDownloadPressed() async {
    final common_name = _commonNameController.text.trim();
    final country_name = _countryNameController.text.trim();

    // 항상 기본값 사용
    final province_name = 'Seoul';
    final local_name = 'Gangnam';
    final org_name = 'MyOrganization';

    setState(() {
      _isLoading = true;
      _Error = '';
    });

    try {
      final api = ApiService();
      await api.downloadCertWeb(
        common_name,
        country_name,
        province_name,
        local_name,
        org_name,
      );
    } catch (e) {
      setState(() {
        _Error = '다운로드 중 오류 발생: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _commonNameController,
              decoration: const InputDecoration(
                labelText: 'common name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _countryNameController,
              decoration: const InputDecoration(
                labelText: 'country name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _provinceNameController,
              decoration: const InputDecoration(
                labelText: 'province name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _localNameController,
              decoration: const InputDecoration(
                labelText: 'local name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _orgNameController,
              decoration: const InputDecoration(
                labelText: 'org name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _onDownloadPressed,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('다운로드'),
            ),
            const SizedBox(height: 20),
            if (_Error.isNotEmpty)
              Text(
                _Error,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
