// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

//write a material app theme page with a scaffold that has a full camera view and continously scans for pieces of text
class PoliceMode extends StatefulWidget {
  @override
  _PoliceModeState createState() => _PoliceModeState();
}

class _PoliceModeState extends State<PoliceMode> {
  String _platformVersion = 'Unknown';

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterMobileVision.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  int? _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = true;
  bool _showTextOcr = true;
  Size? _previewOcr;
  List<OcrText> _textsOcr = [];
  int? _cameraTest = FlutterMobileVision.CAMERA_BACK;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          if (previewSizes[_cameraTest] == null) {
            return;
          }
          _previewOcr = previewSizes[_cameraOcr]!.first;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Mode'),
        automaticallyImplyLeading: true,
      ),
      body: _getOcrScreen(context),
    );
  }

  List<DropdownMenuItem<Size>> _getPreviewSizes(int facing) {
    List<DropdownMenuItem<Size>> previewItems = [];

    List<Size>? sizes = FlutterMobileVision.getPreviewSizes(facing);

    if (sizes != null) {
      for (var size in sizes) {
        previewItems.add(
          DropdownMenuItem(
            value: size,
            child: Text(size.toString()),
          ),
        );
      }
    } else {
      previewItems.add(
        const DropdownMenuItem(
          value: null,
          child: Text('Empty'),
        ),
      );
    }

    return previewItems;
  }

  List<DropdownMenuItem<int>> _getCameras() {
    List<DropdownMenuItem<int>> cameraItems = [];

    cameraItems.add(const DropdownMenuItem(
      value: FlutterMobileVision.CAMERA_BACK,
      child: Text('BACK'),
    ));

    cameraItems.add(const DropdownMenuItem(
      value: FlutterMobileVision.CAMERA_FRONT,
      child: Text('FRONT'),
    ));

    return cameraItems;
  }

  Widget _getOcrScreen(BuildContext context) {
    List<Widget> items = [];

    items.add(const Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        left: 18.0,
        right: 18.0,
      ),
      child: Text('Camera:'),
    ));

    items.add(Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
      ),
      child: DropdownButton<int>(
        items: _getCameras(),
        onChanged: (value) {
          _previewOcr = null;
          setState(() => _cameraOcr = value);
        },
        value: _cameraOcr,
      ),
    ));

    items.add(const Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        left: 18.0,
        right: 18.0,
      ),
      child: Text('Preview size:'),
    ));

    items.add(Padding(
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
      ),
      child: DropdownButton<Size>(
        items: _getPreviewSizes(_cameraOcr ?? 0),
        onChanged: (value) {
          setState(() => _previewOcr = value);
        },
        value: _previewOcr,
      ),
    ));

    items.add(SwitchListTile(
      title: const Text('Torch:'),
      value: _torchOcr,
      onChanged: (value) => setState(() => _torchOcr = value),
    ));

    items.add(SwitchListTile(
      title: const Text('Return all texts:'),
      value: _multipleOcr,
      onChanged: (value) => setState(() => _multipleOcr = value),
    ));

    // items.add(SwitchListTile(
    //   title: const Text('Capture when tap screen:'),
    //   value: _waitTapOcr,
    //   onChanged: (value) => setState(() => _waitTapOcr = value),
    // ));

    items.add(SwitchListTile(
      title: const Text('Show text:'),
      value: _showTextOcr,
      onChanged: (value) => setState(() => _showTextOcr = value),
    ));

    items.add(
      Padding(
        padding: const EdgeInsets.only(
          left: 18.0,
          right: 18.0,
          bottom: 12.0,
        ),
        child: ElevatedButton(
          onPressed: _read,
          child: const Text('Read Registration Numbers'),
        ),
      ),
    );
    items.addAll(
      ListTile.divideTiles(
        context: context,
        tiles: _textsOcr
            .map(
              (ocrText) => OcrTextWidget(ocrText),
            )
            .toList(),
      ),
    );

    return ListView(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      children: items,
    );
  }

  Future<void> _read() async {
    List<OcrText> texts = [];
    Size scanpreviewOcr = _previewOcr ?? FlutterMobileVision.PREVIEW;
    try {
      texts = await FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: _autoFocusOcr,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        forceCloseCameraOnTap: true,
        imagePath: '', //'path/to/file.jpg'
        showText: _showTextOcr,
        preview: _previewOcr ?? FlutterMobileVision.PREVIEW,
        scanArea: Size(scanpreviewOcr.width - 20, scanpreviewOcr.height - 20),
        camera: _cameraOcr ?? FlutterMobileVision.CAMERA_BACK,
        fps: 10.0,
      );
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }
    if (!mounted) return;

    setState(() => _textsOcr = texts);
  }
}

class OcrTextWidget extends StatelessWidget {
  final OcrText ocrText;

  const OcrTextWidget(this.ocrText);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.title),
        title: Text(ocrText.value),
        subtitle: Text(ocrText.language),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => {
              print(ocrText.value),
            });
  }
}
