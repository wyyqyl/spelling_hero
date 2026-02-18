import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scanner_controller.g.dart';

@riverpod
class ScannerController extends _$ScannerController {
  @override
  FutureOr<List<String>> build() {
    return [];
  }

  Future<void> pickAndScanImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Homework',
          toolbarColor: const Color(0xFF4FACFE),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Homework'),
      ],
    );

    if (croppedFile == null) return;

    state = const AsyncValue.loading();

    try {
      final inputImage = InputImage.fromFilePath(croppedFile.path);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      final lines = recognizedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      state = AsyncValue.data(lines);

      await textRecognizer.close();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void removeLine(int index) {
    final current = state.asData?.value;
    if (current != null) {
      final newList = List<String>.from(current)..removeAt(index);
      state = AsyncValue.data(newList);
    }
  }

  void updateLine(int index, String newText) {
    final current = state.asData?.value;
    if (current != null) {
      final newList = List<String>.from(current)..[index] = newText;
      state = AsyncValue.data(newList);
    }
  }
}
