import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:typed_data';

class ApiService {
  Future<void> downloadCertWeb(String common_name, country_name, province_name, local_name, org_name) async {
    var url = Uri.parse('https://220.149.241.73:5000/get_key');

    var request = http.MultipartRequest('POST', url);
    request.fields['common_name'] = common_name;
    request.fields['country_name']= country_name;
    request.fields['province_name']= province_name;
    request.fields['local_name']= local_name;
    request.fields['org_name']= org_name;

    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      Uint8List bytes = await streamedResponse.stream.toBytes();

      final blob = html.Blob([bytes]);
      final downloadUrl = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: downloadUrl)
        ..setAttribute('download', '$common_name.zip')
        ..click();
      html.Url.revokeObjectUrl(downloadUrl);
    } else {
      print('서버 오류: ${streamedResponse.statusCode}');
    }
  }

}
