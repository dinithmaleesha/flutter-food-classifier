import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Classification',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  List<Map<String, dynamic>>? _output;
  bool _loading = false;
  late Interpreter interpreter;
  List<String>? labels;
  int HEIGHT = 224;
  int WIDTH = 224;

  @override
  void initState() {
    super.initState();
    _loading = true;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Classification', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          _image != null
              ? Expanded(child: Image.file(_image!))
              : Expanded(child: Center(child: Text('No image selected.'))),
          SizedBox(height: 36),
          if (!_loading && _output != null && _output!.isNotEmpty)
            Column(
              children: _output!.map((prediction) => Text(
                  '${prediction['label']}: ${(prediction['confidence'] * 100).toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 16))).toList(),
            ),
          if (_loading)
            Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
