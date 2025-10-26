import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'person.dart';

void main() {
  runApp(const MaterialApp(home: SearchPage()));
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Person> people = [];
  Person? foundPerson;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData(); 
  }

  void _loadData() {
    const jsonString = '''
    [
      {
        "name": "Nguyen Van A",
        "email": "VanA@gmail.com",
        "address": {
          "city": "Da Nang",
          "ward": "Hai Chau",
          "street": "Le Duan",
          "houseNumber": "123/45"
        },
        "school": [
          {
            "name": "Da Nang University of Science and Technology",
            "yearIn": 2022,
            "yearOut": 2027,
            "address": "Da Nang"
          },
          {
            "name": "Phan Chau Trinh High School",
            "yearIn": 2019,
            "yearOut": 2022,
            "address": "Da Nang"
          }
        ]
      },
      {
        "name": "Tran Thi B",
        "email": "ThiB@gmail.com",
        "address": {
          "city": "Hue",
          "ward": "Phu Nhuan",
          "street": "Nguyen Hue",
          "houseNumber": "55"
        },
        "school": [
          {
            "name": "Hue University",
            "yearIn": 2021,
            "yearOut": 2026,
            "address": "Hue"
          }
        ]
      }
    ]
    ''';

    final List<dynamic> jsonList = jsonDecode(jsonString);
    people = jsonList.map((e) => Person.fromJson(e)).toList();
  }

  void _search() {
    setState(() {
      final name = _controller.text.trim().toLowerCase();
      if (name.isEmpty) {
        error = 'Vui lòng nhập tên cần tra cứu';
        foundPerson = null;
        return;
      }

      foundPerson = people.firstWhere(
        (p) => p.name.toLowerCase() == name,
        orElse: () => Person(
          name: '',
          email: '',
          address: Address(city: '', ward: '', street: '', houseNumber: ''),
          school: [],
        ),
      );

      if (foundPerson!.name.isEmpty) {
        error = 'Không tìm thấy người có tên "$name"';
        foundPerson = null;
      } else {
        error = null;
      }
    });
  }
  Future<void> _saveAsJson() async {
    if (foundPerson == null) return;

    try {
      final dir = await getApplicationDocumentsDirectory();

      String safe(String s) => s
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
          .replaceAll(RegExp(r'^_+|_+$'), '');
      final baseName =
          safe(foundPerson!.name.isEmpty ? 'person' : foundPerson!.name);
      final ts = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/$baseName-$ts.json');

      final pretty =
          const JsonEncoder.withIndent('  ').convert(foundPerson!.toJson());
      await file.writeAsString(pretty);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu: ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu JSON: $e')),
      );
    }
  }

 
  Future<void> _openSaveFolder() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      await OpenFilex.open(dir.path); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở thư mục: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tra cứu thông tin JSON')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Ô nhập tìm kiếm
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Nhập tên cần tra cứu',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _search,
                  ),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _search(),
              ),
              const SizedBox(height: 20),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),

              // Khối kết quả
              if (foundPerson != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hàng nút thao tác: Lưu JSON + Mở thư mục lưu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _saveAsJson,
                          icon: const Icon(Icons.save),
                          label: const Text('Lưu JSON'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _openSaveFolder,
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Mở thư mục lưu'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Card 1: Thông tin cá nhân 
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thông tin cá nhân:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            _infoBox(
                              title: 'Họ và tên',
                              value: foundPerson!.name,
                            ),
                            _infoBox(
                              title: 'Email',
                              value: foundPerson!.email,
                            ),
                            _infoBox(
                              title: 'Địa chỉ',
                              value:
                                  '${foundPerson!.address.houseNumber}, ${foundPerson!.address.street}, ${foundPerson!.address.ward}, ${foundPerson!.address.city}',
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Card 2: Danh sách trường học 
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Danh sách trường học:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...foundPerson!.school.map((s) {
                              return Container(
                                width: double.infinity,
                                height: 110, 
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      s.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text('Thời gian: ${s.yearIn} - ${s.yearOut}'),
                                    Text('Địa chỉ: ${s.address}'),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Ô thông tin cố định dùng cho Card 1
  Widget _infoBox({
    required String title,
    required String value,
    int maxLines = 1,
  }) {
    return Container(
      width: double.infinity,
      height: 110,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
