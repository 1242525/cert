import 'package:cert/screen/searchCert.dart';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../screen/searchCert.dart';

class CertDownloadPage extends StatefulWidget {
  final ApiService service;
  const CertDownloadPage({super.key, required this.service});

  @override
  State<CertDownloadPage> createState() => _CertDownloadPageState();
}

class _CertDownloadPageState extends State<CertDownloadPage> {
  final TextEditingController _commonNameController = TextEditingController();
  final TextEditingController _countryNameController = TextEditingController();
  final TextEditingController _provinceNameController = TextEditingController(text: 'Seoul');
  final TextEditingController _localNameController = TextEditingController(text: 'Gangnam');
  final TextEditingController _orgNameController = TextEditingController(text: 'MyOrganization');


  String _Error = '';
  bool _isLoading = false;


  void _onDownloadPressed() async {
    final common_name = _commonNameController.text.trim();
    final country_name = _countryNameController.text.trim();
    final province_name = 'Seoul';
    final local_name = 'Gangnam';
    final org_name = 'MyOrganization';

    await widget.service.downloadCertWeb(
      common_name,
      country_name,
      province_name,
      local_name,
      org_name,
    );

    widget.service.addPemFile('$common_name.zip');


    setState(() {
      _isLoading = true;
      _Error = '';
    });
  }

  void _onScreenPressed(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_)=>SearchCert(service: widget.service),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("create cert",
            ),
            const SizedBox(width: 1500),
            IconButton(
            icon: const Icon(Icons.search), // 🔍 Search 아이콘 추가
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchCert(service: widget.service,), // 🔍 SearchCert 페이지로 이동
                ),
              );
            },
          ),

          ],
        ),
      ),
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