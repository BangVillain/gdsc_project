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

  Future<void> _sendRequest() async {
    setState(() {
      isLoading = true;
      _response = '';
    });

    final url = Uri.parse('http://192.168.200.183:8000/bye/'); // 여기에 API URI를 입력하세요.

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        setState(() {
          _response = data.toString();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _sendRequest,
          child: Text('Send API Request'),
        ),
        SizedBox(height: 20),
        isLoading
            ? CircularProgressIndicator()
            : Text(_response),
      ],
    );
  }
}