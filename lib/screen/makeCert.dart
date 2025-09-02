import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'searchCert.dart';
import 'dart:typed_data';

class CertDownloadPage extends StatefulWidget {
  final ApiService service;
  const CertDownloadPage({super.key, required this.service});

  @override
  State<CertDownloadPage> createState() => _CertDownloadPageState();
}

class _CertDownloadPageState extends State<CertDownloadPage> {
  final TextEditingController _commonNameController = TextEditingController();
  final TextEditingController _countryNameController = TextEditingController();
  final TextEditingController _provinceNameController = TextEditingController();
  final TextEditingController _localNameController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();

  Uint8List? lastDownloadedBytes;

  void _onDownloadPressed() async {
    final common_name = _commonNameController.text.trim();
    final country_name = _countryNameController.text.trim();
    final province_name = _provinceNameController.text.trim();
    final local_name = _localNameController.text.trim();
    final org_name = _orgNameController.text.trim();

    final bytes = await widget.service.downloadCertWeb(
      common_name,
      country_name,
      province_name,
      local_name,
      org_name,
    );

    if (bytes != null) {
      lastDownloadedBytes = bytes; // 나중에 unzip 용도로 저장
      setState(() {});
    }
  }

  void _onScreenPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchCert(
          service: widget.service,
          lastDownloadedBytes: lastDownloadedBytes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Cert"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onScreenPressed,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _commonNameController, decoration: const InputDecoration(labelText: 'Common Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _countryNameController, decoration: const InputDecoration(labelText: 'Country Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _provinceNameController, decoration: const InputDecoration(labelText: 'Province Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _localNameController, decoration: const InputDecoration(labelText: 'Local Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _orgNameController, decoration: const InputDecoration(labelText: 'Org Name', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _onDownloadPressed,
              icon: const Icon(Icons.download),
              label: const Text('파일 다운로드'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
