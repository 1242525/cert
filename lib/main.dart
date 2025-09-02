import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api/api_service.dart';
import 'screen/makeCert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cert App',
      theme: ThemeData(
        // ✅ 앱 전체 기본 폰트 적용
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home:  CertDownloadPage(service: ApiService())
    );
  }
}


