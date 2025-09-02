import 'package:flutter/material.dart';
import '../api/api_service.dart';

class SearchCert extends StatefulWidget{
  final ApiService service;
  const SearchCert({super.key, required this.service});

  State<SearchCert> createState() => _SearchCertState();
}

class _SearchCertState extends State<SearchCert>{
  String _serchQuery ='';

  void _selectPemFile(String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('선택된 파일, $fileName')),
    );
  }

  @override
  Widget build(BuildContext context) {
  final filteredFiles = widget.service.pemFiles.
    where((f)=> f.toLowerCase().contains(_serchQuery.toLowerCase())).toList();

  return Scaffold(
    body: Padding(padding: const EdgeInsets.all(16),
    child: Column(
      children: [

        TextField(
          decoration: const InputDecoration(
            labelText: '파일 검색',
            prefixIcon: Icon(Icons.search_rounded),
            border: OutlineInputBorder(),
    ),
      onChanged: (value){
            setState(() {
              _serchQuery=value;
            });
      },

          ),
    const SizedBox(height: 16,),
        Expanded(
          child: filteredFiles.isEmpty
              ? const Center(child: Text('저장된 PEM 파일이 없습니다.'))
              : ListView.builder(
            itemCount: filteredFiles.length,
            itemBuilder: (context, index) {
              final file = filteredFiles[index];
              return ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(file),
                onTap: () => _selectPemFile(file),
              );
            },
          ),
        ),
        // 다운로드 버튼
      ],
    ),
    ),
  );
  }
}
