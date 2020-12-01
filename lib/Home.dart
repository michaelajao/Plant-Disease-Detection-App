import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 38,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/plant_model.tflite", labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod * 100.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.8],
            colors: [Colors.greenAccent, Colors.lightBlueAccent],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "Detect Plant Disease",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 28),
              ),
              Text(
                "MobileNet V2",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7)
                    ]),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 200,
                                child: Column(
                                  children: [
                                    Image.asset("assets/plant.png"),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(_image),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _output != null
                                        ? Text(
                                            'Prediction is: ${_output[0]['label']}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          )
                                        : Container(),
                                    Text(
                                      'confidence is: ${roundDouble(_output[0]['confidence'], 2)}%',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                  color: Color(0xFF56AB2F),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                "Take a photo",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: pickGalleryImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                  color: Color(0xFF56AB2F),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                "Camera Roll",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
