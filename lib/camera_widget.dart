import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:http/http.dart';
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmacy_app/shared_preferences_wrapper.dart';
import 'package:image_picker/image_picker.dart';

class CameraWidget extends StatefulWidget{
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>{
  CameraController controller;
  List<CameraDescription> cameras;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  String imagePath;

  @override
  void initState(){
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
                children: <Widget>[
                  Transform.scale(
                    scale: controller.value.aspectRatio / deviceRatio,
                    child: Center(
                      child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(controller)
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 8.5 * 37.0,
                      height: 11.0 * 41.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromARGB(50, 100, 100, 100),
                          border: Border.all(color: Colors.black87)
                      ),
                    )
                  ),
                  Positioned(
                    left: 225,
                    top: 265,
                    child: Container(
                      width: 25,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border: Border.all(color: Colors.redAccent[700])
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topCenter,
                    child: Text("Наведите красную рамку на номер СНИЛС", style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(10),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: onCaptureButtonPressed,
                      child: Icon(Icons.photo_camera, color: Colors.grey,),
                    )
                  ),
                ]
              ); //cameraPreview
        } else {
          return Center(
              child:
              CircularProgressIndicator()); // Otherwise, display a loading indicator.
        }
      },
    );
  }

  uploadSnils() async {
    if (imagePath == null) return;
    String base64Image = base64Encode(File(imagePath).readAsBytesSync());
    String userID = "";
    String url = "https://es.svodnik.pro:55443/es_test/ru_RU/hs/oauth/SNILS?UserID=$userID";
    var tokens = await SharedPreferencesWrap.getTokens();
    var info = await SharedPreferencesWrap.getDeviceInfo();
    Map<String, String> headers = {"AccessToken": tokens[1], "DeviceID": info['deviceID'], "AppID": info["appID"], "InstanceID": info['instanceID']};

    Response response = await put(url, headers: headers);
    if (response.statusCode == 200){

    }

  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = controller.initialize();
    if (!mounted){
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  void onCaptureButtonPressed() async {  //on camera button press
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path//TODO: change IOS settings for path_provider
        '${DateTime.now()}.png',
      );
      print(path);
      imagePath = path;
      await controller.takePicture(path); //take photo

      setState(() {

      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller != null
          ? _initializeControllerFuture = controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }
}