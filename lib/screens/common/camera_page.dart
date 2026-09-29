import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/image_service.dart';

class CameraPage extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const CameraPage({super.key, required this.onImageCaptured});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription> _availableCameras = [];
  int _currentCameraIndex = 0; // Track the current camera (0: back, 1: front)

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _availableCameras = await availableCameras();
      if (_availableCameras.isNotEmpty) {
        _initializeControllerForCamera(_availableCameras[_currentCameraIndex]);
      }
    } catch (e) {
      print("Ошибка инициализации камеры: $e");
    }
  }

  Future<void> _initializeControllerForCamera(CameraDescription camera) async {
    _cameraController?.dispose();
    _cameraController = CameraController(camera, ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {});
  }

  void _captureImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile file = await _cameraController!.takePicture();
        widget.onImageCaptured(file); // Pass the file back
        Navigator.pop(context); // Close the camera page
      } catch (e) {
        print("Ошибка съёмки: $e");
      }
    }
  }

  void _imageBrowse() async {
    ImageService imageService = ImageService();
    
    final XFile? pickedFile = await imageService.pickImage();
    if (pickedFile != null) {
      widget.onImageCaptured(pickedFile);
      Navigator.pop(context);
    }
  }

  // Switch between front and back camera
  void _switchCamera() {
    if (_availableCameras.isNotEmpty) {
      setState(() {
        // Toggle between 0 (back) and 1 (front)
        _currentCameraIndex =
            (_currentCameraIndex + 1) % _availableCameras.length;
      });
      _initializeControllerForCamera(_availableCameras[_currentCameraIndex]);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(children: [
          const AppBarPage(title: 'Добавить фото'),
          _cameraController != null && _cameraController!.value.isInitialized
              ? Expanded(child: CameraPreview(_cameraController!))
              : const Expanded(
                  child: Center(
                      child: CircularProgressIndicator(
                    color: kRed,
                  )),
                ),
        ]),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _imageBrowse,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: kWhite),
                    child: const Icon(
                      Icons.photo_album,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _captureImage,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: kGradientMain,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: kWhite,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _switchCamera,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: kWhite),
                    child: const Icon(
                      Icons.switch_camera,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
