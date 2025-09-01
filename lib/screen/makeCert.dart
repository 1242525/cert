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
  final TextEditingController _provinceNameController = TextEditingController();
  final TextEditingController _localNameController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();


  String _Error = '';
  bool _isLoading = false;


  void _onDownloadPressed() async {
    final common_name = _commonNameController.text.trim();
    final country_name = _countryNameController.text.trim();
    final province_name = _provinceNameController.text.trim();
    final local_name = _localNameController.text.trim();
    final org_name = _orgNameController.text.trim();

    setState(() {
      _isLoading = true;
      _Error = '';
    });


    final api = ApiService();
    final result = await api.downloadCertWeb(common_name,
        country_name,
        province_name,
        local_name,
        org_name);
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
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _onDownloadPressed,
              icon: const Icon(Icons.download),
              label: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('파일 다운로드'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Text(_Error),
          ],
        ),
      ),
    );
  }
}