/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'searchCert.dart';

import 'makeCert.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('홈'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigoAccent,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 300, right: 40, left: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHomeButton(
                  context,
                  text: '인증서 발급',
                  icon: Icons.create_new_folder,
                  onPressed: () async {
                    // 필요하다면 async 작업 수행
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CertDownloadPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                _buildHomeButton(
                  context,
                  text: '인증서 찾기',
                  icon: Icons.lock_open_outlined,
                  onPressed: () async {
                    // 필요하다면 async 작업 수행
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchCert,
                      ),
                    );
                  },
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  //  버튼
  Widget _buildHomeButton(
      BuildContext context, {
        required String text,
        required IconData icon,
        required VoidCallback onPressed,
      }) {
    return SizedBox(
      width: 260,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: Colors.indigoAccent),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.indigoAccent,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.indigoAccent, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }
}

 */
