import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'dart:typed_data';

class SearchCert extends StatefulWidget {
  final ApiService service;
  final Uint8List? lastDownloadedBytes;

  const SearchCert({super.key, required this.service, this.lastDownloadedBytes});

  @override
  State<SearchCert> createState() => _SearchCertState();
}

class _SearchCertState extends State<SearchCert> {
  String _searchQuery = '';
  List<String> extractedFiles = [];

  @override
  Widget build(BuildContext context) {
    final filteredFiles = widget.service.pemFiles
        .where((f) => f.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("PEM 파일 검색")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: '파일 검색',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  final fileName = filteredFiles[index];
                  final isZip = fileName.endsWith('.zip');

                  return ListTile(
                    title: Text(fileName),
                    trailing: isZip
                        ? ElevatedButton(
                      onPressed: () {
                        if (widget.lastDownloadedBytes != null) {
                          extractedFiles = widget.service.unzipZipBytes(widget.lastDownloadedBytes!);

                          // 리스트에 추가
                          for (var f in extractedFiles) {
                            widget.service.addPemFile(f);
                          }

                          widget.service.removePemFile(fileName);
                          setState(() {});
                        }
                      },
                      child: const Text('압축 풀기'),
                    )
                        : null,
                    onTap: () async {
                      if (!isZip && fileName.endsWith('.crt.pem')) {
                        final result = await widget.service.readAndDecodingPem(
                            widget.lastDownloadedBytes!, fileName);

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: result.isValid ? Colors.green[100] : Colors.red[100],
                            title: const Text("인증서 정보"),
                            content: SingleChildScrollView(
                              child: Text(
                                result.content,
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('닫기')),
                            ],
                          ),
                        );
                      }
                    },

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
