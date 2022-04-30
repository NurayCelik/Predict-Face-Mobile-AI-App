import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  File _image;
  bool _loading = false;
  List _output;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      //setState(() { });
    });
  }

  @override
  void dispose() {
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

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
        asynch: true);
    setState(() {
      _loading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/mymodel.tflite",
      labels: "assets/labels.txt",
      isAsset: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff424449),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 8.0, //80.0,
              ),
              Text(
                'AI CNN App',
                style: TextStyle(
                  color: Color(0xff8887da),
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Detect Female Vs Male',
                style: TextStyle(
                    color: Color(0xffeeda28),
                    fontWeight: FontWeight.w500,
                    fontSize: 28.0),
              ),
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: _loading
                    ? Container(
                        width: MediaQuery.of(context).size.width / 2.0, //300.0,
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.asset(
                                'assets/images/start.png',
                                height: MediaQuery.of(context).size.height /
                                    3.0, //300.0,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  15.0, //50.0,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height /
                                  2.7, //250.0,
                              child: !_loading || _image != null
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : CircularProgressIndicator(),
                            ),
                            SizedBox(
                              height: 20.0, //20.0,
                            ),
                             _output != null //_output[0]['confidence']
                                ? Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: _output != null
                                        ? Text(
                                            '${_output[0]['label']}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          )
                                        : Text('No Image Taken',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0)),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 35.0, //20.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 17.0,
                          width: MediaQuery.of(context).size.width - 220,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 1.0),
                          decoration: BoxDecoration(
                              color: Color(0xff7170b9),
                              borderRadius: BorderRadius.circular(6.0)),
                          child: Text(
                            "Take a photo",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60.0, //20.0,
                      //10.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: GestureDetector(
                        onTap: pickGalleryImage,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 17.0,
                          width: MediaQuery.of(context).size.width - 220,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 1.0),
                          decoration: BoxDecoration(
                              color: Color(0xff7170b9),
                              borderRadius: BorderRadius.circular(6.0)),
                          child: Text(
                            "Camera Roll",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
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
