import 'dart:convert';
import 'package:http/http.dart' as http;

//GET 요청
Future<List> fetchData() async {
  final response = await http.get(Uri.parse('http://54.180.141.54:8080/data/'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
//Post 요청
Future<void> sendData(String title, String description) async {
  final response = await http.post(
    Uri.parse('http://54.180.141.54:8080/data/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'title': title, 'description': description}),
  );

  if (response.statusCode == 201) {
    print('Data successfully saved');
  } else {
    throw Exception('Failed to save data');
  }
}
