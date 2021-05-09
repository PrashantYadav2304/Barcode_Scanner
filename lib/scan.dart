import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {

  File _image;
  final picker = ImagePicker();
  String barcodeVal = '000000';
  BarcodeValueType barcodeType;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
     if (pickedFile != null) {
        _image = File(pickedFile.path);
        final File imageFile = _image;
        final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
        final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
        final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);

        for (Barcode barcode in barcodes) {
          // final Rectangle<int> boundingBox = barcode.boundingBox;
          // final List<Point<int>> cornerPoints = barcode.cornerPoints;
            setState(() {
              barcodeVal = barcode.rawValue;
              barcodeType = barcode.valueType;
              print('$barcodeVal');
            });
            
            break;
        }
         barcodeDetector.close();
      } else {
        print('No image selected.');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: getImage, child: Text("SCAN"))
      )
    );
    
  }
}