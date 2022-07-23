import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List _outputs = [];
  File? _image;

  Future openCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = File(image!.path);
    });
    classifyImage(_image!);
  }

  Future openGallery() async {
    var image;
    image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = File(image!.path);
    });
    classifyImage(_image!);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );
    setState(() {
      _outputs = output!;
      print(_outputs);
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState((){});
    });
  }

  @override
  void dispose() async {
    await Tflite.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML with Flutter'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _image != null ?
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(_image!),
                  fit: BoxFit.cover
                )
              ),
            )
                :
            Container(),

            SizedBox(height: 16,),
            _outputs.isNotEmpty ? Text('Output', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),) : Text('Select image', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),

            _outputs.isNotEmpty ? Text('Confidence: ${_outputs.first['confidence']}', style: TextStyle(fontSize: 18),) : Container(),
            _outputs.isNotEmpty ? Text('Object: ${_outputs.first['label']}', style: TextStyle(fontSize: 18),) : Container(),

          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              openCamera();
            },
            tooltip: 'Pick from camera',
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 16,),
          FloatingActionButton(
            onPressed: (){
              openGallery();
            },
            tooltip: 'Pick from gallery',
            child: Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}
