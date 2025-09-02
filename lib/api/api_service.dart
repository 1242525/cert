import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class ApiService {

  final List<String> _pemFiles=[];

  List<String> get pemFiles => List.unmodifiable(_pemFiles);

  void addPemFile(String fileName){
    _pemFiles.add(fileName);
  }

  Future<void> downloadCertWeb(String common_name, country_name, province_name, local_name, org_name) async {
    var url = Uri.parse('https://220.149.241.73:5000/get_key');

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
        // ZIP 파일은 bodyBytes 사용
        final bytes = response.bodyBytes;

        final blob = html.Blob([bytes], 'application/zip');
        final downloadUrl = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: downloadUrl)
          ..setAttribute('download', '$common_name.zip')
          ..click();
        html.Url.revokeObjectUrl(downloadUrl);

        print('다운로드 성공');
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('예외 발생: $e');
    }
  }
}
