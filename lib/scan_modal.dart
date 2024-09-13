import 'dart:io';
import 'package:Stash/add_barcode.dart';
import 'package:Stash/store_modal.dart';
import 'package:camera/camera.dart';
import 'package:Stash/add_card_name.dart';
import 'package:Stash/alert_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanModal {
  static Future<void> show(BuildContext context) async {
    // Request camera permission
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    // Get the list of available cameras.
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      AlertBox.show(context,
          title: "No Camera Detected",
          content: "We couldn't find an available camera on your device.",
          accept: "Dismiss",
          decline: "Dismiss",
          acceptColor: Colors.red, declineCallback: () async {
        Navigator.pop(context);
      }, acceptCallback: () async {});
      return;
    }

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // Initialize a CameraController
    final controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
      enableAudio: false,
    );

    // Initialize the controller. This returns a Future.
    await controller.initialize();

    // Specify the formats you want to scan (in this case, all formats)
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    final barcodeScanner = BarcodeScanner(formats: formats);

    // State to control the blur and tick animation
    bool hasScanned = false;

    showModalBottomSheet(
      backgroundColor: Theme.of(context).shadowColor,
      isScrollControlled: true,
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            controller.startImageStream((CameraImage image) async {
              if (!hasScanned) {
                final inputImage =
                    _inputImageFromCameraImage(controller, image);
                if (inputImage == null) return;

                try {
                  // Process the image to detect barcodes
                  final List<Barcode> barcodes =
                      await barcodeScanner.processImage(inputImage);

                  if (barcodes.isNotEmpty) {
                    setState(() {
                      hasScanned = true;
                    });

                    // Optionally: Stop the image stream to avoid multiple scans
                    await controller.stopImageStream();

                    Future.delayed(const Duration(seconds: 1), () {
                      print(barcodes[0].format.toString());
                      Navigator.pop(context); // Dismiss the modal first
                      StoreModal.show(context, barcodes[0].rawValue ?? "Null",
                          barcodes[0].format.toString());
                      // Navigate to the EnterCardNamePage
                    });

                    // Process barcodes (example handling)
                    for (Barcode barcode in barcodes) {
                      final BarcodeType type = barcode.type;
                      final String? displayValue = barcode.displayValue;
                      final String? rawValue = barcode.rawValue;

                      // Example switch case to handle different barcode types
                      switch (type) {
                        case BarcodeType.wifi:
                          final BarcodeWifi wifiInfo =
                              barcode.value as BarcodeWifi;
                          print(
                              'Wi-Fi: ${wifiInfo.ssid}, ${wifiInfo.password}');
                          break;
                        case BarcodeType.url:
                          final BarcodeUrl urlInfo =
                              barcode.value as BarcodeUrl;
                          print('URL: ${urlInfo.title}, ${urlInfo.url}');
                          break;
                        default:
                          print('Barcode value: $rawValue');
                          break;
                      }
                    }
                  }
                } catch (e) {
                  print('Error scanning barcode: $e');
                }
              }
            });

            return Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            controller.dispose();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).shadowColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.scan_loyalty_card,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: "SFProRounded",
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display the camera preview
                  Stack(
                    children: [
                      buildCameraPreview(controller),
                      AnimatedOpacity(
                        opacity: hasScanned ? 1.0 : 0.0,
                        duration: const Duration(
                            milliseconds: 500), // Adjust the duration as needed
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 273,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white.withOpacity(0),
                              ),
                            ).asGlass(
                              enabled: true,
                              tintColor: Colors.transparent,
                              clipBorderRadius: BorderRadius.circular(15.0),
                            ),
                            const Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Colors.green,
                              size: 60,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBarcode()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.add_manually_button,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() async {
      // Dispose of the controller when the modal is closed
      await controller.dispose();

      // Close the barcode scanner to release resources
      barcodeScanner.close();
    });
  }

  static InputImage? _inputImageFromCameraImage(
      CameraController controller, CameraImage image) {
    // Get image rotation
    final sensorOrientation = controller.description.sensorOrientation;
    InputImageRotation rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation)!;
    } else if (Platform.isAndroid) {
      final rotationCompensation =
          _getRotationCompensation(controller, sensorOrientation);
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation)!;
    } else {
      return null;
    }

    // Get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    // Since format is constrained to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // Compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  static int _getRotationCompensation(
      CameraController controller, int sensorOrientation) {
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    var rotationCompensation = orientations[controller.value.deviceOrientation];
    if (rotationCompensation == null) return sensorOrientation;
    if (controller.description.lensDirection == CameraLensDirection.front) {
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }
    return rotationCompensation;
  }

  static void _showNoCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Camera Found'),
          content:
              const Text('No available cameras were found on this device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Widget buildCameraPreview(CameraController cameraController) {
  const double previewAspectRatio = 0.7;
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: AspectRatio(
      aspectRatio: 1 / previewAspectRatio,
      child: ClipRect(
        child: Transform.scale(
          scale: cameraController.value.aspectRatio / previewAspectRatio,
          child: Center(
            child: CameraPreview(cameraController),
          ),
        ),
      ),
    ),
  );
}
