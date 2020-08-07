import 'package:flutter/material.dart';
import 'package:images_gallery/image_translator.dart';

void main() => runApp(Shell());

class Shell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Images Translator",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ImageTranslator(),
    );
  }
}
