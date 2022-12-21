import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class PoliceMode extends StatefulWidget {
  @override
  State<PoliceMode> createState() => _PoliceModeState();
}

class _PoliceModeState extends State<PoliceMode> {
  late List<CameraDescription> _cameras;
  CameraController? controller;
  late CameraImage _image;
  String toptext = 'NUMBER PLATE EXAMPLE';
  bool isProcessing = false;
  bool showAllBoxes = false;
  List<Rect> boxes = [];
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  Rect _textRect = const Rect.fromLTWH(0, 0, 0, 0);

  initCameras() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller!.startImageStream((CameraImage image) {
        _image = image;
        final bytes = cameraImageToBytes(image);
        final planeData = image.planes.map(
          (Plane plane) {
            return InputImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width,
            );
          },
        ).toList();
        log(isProcessing.toString());
        !isProcessing
            ? processImage(
                InputImage.fromBytes(
                  bytes: bytes,
                  inputImageData: InputImageData(
                    planeData: planeData,
                    size: Size(image.width.toDouble(), image.height.toDouble()),
                    imageRotation: InputImageRotation.rotation0deg,
                    inputImageFormat:
                        InputImageFormatValue.fromRawValue(image.format.raw) ??
                            InputImageFormat.nv21,
                  ),
                ),
              )
            : null;
      });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initCameras();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Police Mode'),
        ),
        drawer: Drawer(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 50,
            ),
            Switch.adaptive(
              value: showAllBoxes,
              onChanged: (a) => setState(() {
                showAllBoxes = a;
              }),
            ),
            const Text('Text Boxes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
          ]),
        ),
        body: Stack(alignment: Alignment.center, children: [
          CameraView(controller: controller),
          //draw a rectangle around the number plate
          for (int i = 0; i < boxes.length; i++)
            showAllBoxes
                ? Positioned(
                    top: boxes[i].top - 50,
                    left: boxes[i].left,
                    width: boxes[i].width,
                    height: boxes[i].height,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  )
                : Container(),
          Positioned(
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 5),
                shape: BoxShape.circle,
              ),
              //width: MediaQuery.of(context).size.width,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 65,
                    onPressed: () {},
                    //get an icon for a target aiming
                    icon: const Icon(Icons.car_crash),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    toptext,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              )),
        ]));
  }

  cameraImageToBytes(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  processImage(InputImage inputImage) async {
    setState(() {
      isProcessing = true;
    });
    //toptext = DateTime.now().millisecondsSinceEpoch.toString();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      _textRect = rect;
      if (boxes.length > 10) {
        boxes.removeAt(0);
      }
      boxes.add(rect);
      //final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      //final List<String> languages = block.recognizedLanguages;
      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        if (text.length > 3) {
          toptext = text;
        }
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
        }
      }
    }
    setState(() {
      isProcessing = false;
    });
  }
}

class CameraView extends StatelessWidget {
  const CameraView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CameraController? controller;

  @override
  Widget build(BuildContext context) {
    return controller != null
        ? !controller!.value.isInitialized
            ? Column(
                children: const [CircularProgressIndicator()],
              )
            : SizedBox(
                height: MediaQuery.of(context).size.width * 4 / 3,
                width: MediaQuery.of(context).size.width,
                child: CameraPreview(controller!),
              )
        : const Center(child: CircularProgressIndicator());
  }
}
