import 'package:camera/camera.dart';
import 'dart:developer' as dev;

class CameraService {
  // Singleton pattern
  static final CameraService _instance = CameraService._internal();

  factory CameraService() => _instance;

  CameraService._internal();

  List<CameraDescription> _availableCameras = [];
  CameraController? _cameraController;

  // Initialize available cameras
  Future<void> initializeCameras() async {
    try {
      _availableCameras = availableCameras;
    } catch (e) {
      print("Ошибка инициализации камер: $e");
      dev.log('$e');
    }
  }

  // Getter for available cameras
  List<CameraDescription> get availableCameras => _availableCameras;

  // Start the camera preview with the selected camera
  Future<void> startCameraPreview(CameraDescription camera) async {
    _cameraController?.dispose(); // Dispose of any existing controller
    _cameraController = CameraController(camera, ResolutionPreset.high);
    try {
      await _cameraController?.initialize();
    } catch (e) {
      print("Ошибка запуска предпросмотра камеры: $e");
      dev.log('$e');
    }
  }

  // Get the current camera controller
  CameraController? get cameraController => _cameraController;

  // Stop the camera preview
  void stopCameraPreview() {
    _cameraController?.dispose();
    _cameraController = null;
  }
}
