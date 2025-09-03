import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:archive/archive.dart';
import 'package:x509/x509.dart';

class CertValid{
  final String content;
  final bool isValid;
  CertValid({required this.content, required this.isValid});
}

class ApiService {
  final List<String> _pemFiles = [];



  List<String> get pemFiles => List.unmodifiable(_pemFiles);

  void addPemFile(String fileName) {
    if (!_pemFiles.contains(fileName)) _pemFiles.add(fileName);
  }

  // ZIP 파일 다운로드 및 blob 저장
  Future<Uint8List?> downloadCertWeb(String common_name,
      String country_name,
      String province_name,
      String local_name,
      String org_name) async {
    var url = Uri.parse('http://220.149.241.73:5000/get_key');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'common_name': common_name,
          'country_name': country_name,
          'province_name': province_name,
          'local_name': local_name,
          'org_name': org_name,
        }),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // 웹에서 다운로드 트리거
        final blob = html.Blob([bytes], 'application/zip');
        final downloadUrl = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: downloadUrl)
          ..setAttribute('download', '$common_name.zip')
          ..click();
        html.Url.revokeObjectUrl(downloadUrl);

        // ZIP 파일 이름만 리스트에 추가
        addPemFile('$common_name.zip');

        return bytes;
      } else {
        print('서버 오류: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('예외 발생: $e');
      return null;
    }
  }

  // 메모리 상 ZIP 해제 후 .crt.pem만 추출
  List<String> unzipZipBytes(Uint8List zipBytes) {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    List<String> crtPemFiles = [];

    for (final file in archive) {
      if (!file.isFile) continue;
      if (file.name.endsWith('.crt.pem')) {
        crtPemFiles.add(file.name);
      }
    }
    return crtPemFiles;
  }



  Future<CertValid> readAndDecodingPem(Uint8List zipBytes, String fileName) async {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    for (final file in archive) {
      if (file.isFile && file.name == fileName) {
        final rawContent = utf8.decode(file.content as List<int>);
        final certs = parsePem(rawContent);

        if (certs.isNotEmpty && certs.first is X509Certificate) {
          final cert = certs.first as X509Certificate;

          final subjectLines = cert.tbsCertificate.subject
              .toString()
              .split(',')
              .map((s) => s.trim())
              .join('\n');

          final issuerLines = cert.tbsCertificate.issuer
              .toString()
              .split(',')
              .map((s) => s.trim())
              .join('\n');

          final validity = cert.tbsCertificate.validity;
          final validFrom = validity?.notBefore?.toString() ?? '알 수 없음';
          final validTo = validity?.notAfter?.toString() ?? '알 수 없음';

          final now = DateTime.now();
          final isValid = validity?.notAfter?.isAfter(now) ?? false;

          final content = '''
Subject:
$subjectLines

Issuer:
$issuerLines

Valid From: $validFrom
Valid To: $validTo
''';

          return CertValid(content: content, isValid: isValid);
        } else {
          return CertValid(content: "파일을 읽을 수 없습니다.", isValid: false);
        }
      }
    }

    return CertValid(content: '파일을 찾을 수 없습니다.', isValid: false);
  }



    void removePemFile(String fileName) {
      _pemFiles.remove(fileName);
    }
  }

