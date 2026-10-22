import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class CreateProductPickedImage {
  final XFile file;
  final Uint8List bytes;

  const CreateProductPickedImage({required this.file, required this.bytes});
}