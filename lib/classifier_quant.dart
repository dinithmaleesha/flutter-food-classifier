
import 'package:flutter_food_classifier/Classifier.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';

class ClassifierQuant extends Classifier {
  ClassifierQuant({int numThreads = 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'mobilenet_v1_1.0_224_quant.tflite';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}