import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_food_classifier/Classifier.dart';
import 'package:flutter_food_classifier/classifier_quant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;


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

  late Classifier _classifier;
  var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  Image? _imageWidget;

  img.Image? fox;

  Category? category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      logger.w('No image selected.');
      return;
    }

    setState(() {
      _image = File(pickedFile.path);
      _imageWidget = Image.file(_image!);

      _predict();
    });
  }

  void _predict() async {
    final bytes = _image!.readAsBytesSync();
    final imageInput = img.decodeImage(bytes);
    if (imageInput == null) {
      logger.e('Failed to decode image.');
      return;
    }

    // Convert to dart:ui.Image
    final dartUiImage = imageInput;

    // Pass the dart:ui.Image to the predict method
    var pred = _classifier.predict(dartUiImage as ui.Image);

    setState(() {
      category = pred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TfLite Flutter Helper',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: _image == null
                ? Text('No image selected.')
                : Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: _imageWidget,
            ),
          ),
          SizedBox(
            height: 36,
          ),
          Text(
            category != null ? category!.label : '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            category != null
                ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
                : '',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}


