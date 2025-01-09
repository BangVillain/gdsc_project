import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DjangoTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Django API Test'),
        ),
        body: Center(
          child: ApiRequestWidget(),
        ),
      ),
    );
  }
}

class ApiRequestWidget extends StatefulWidget {
  @override
  _ApiRequestWidgetState createState() => _ApiRequestWidgetState();
}

class _ApiRequestWidgetState extends State<ApiRequestWidget> {
  String _response = '';
  bool isLoading = false;
  Image? _image;

  Future<void> _sendRequest() async {
    setState(() {
      isLoading = true;
      _response = '';
      _image = null;
    });

    // 테스트용 로컬 주소
    // final url = Uri.parse('http://192.168.219.107:8000/imgtest/'); // 여기에 API URI를 입력하세요.

    // 실제 서버 주소
    final url = Uri.parse('http://54.180.141.54:8080/imgtest/'); // 여기에 API URI를 입력하세요.

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        final base64Image = data['image'];
        setState(() {
          _image = Image.memory(base64Decode(base64Image));
        });
      } else {
        setState(() {
          _response = 'Failed to get response from API: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Request Example'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : _image != null
                ? _image!
                : Text(_response),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendRequest,
        child: Icon(Icons.send),
      ),
    );
  }
}