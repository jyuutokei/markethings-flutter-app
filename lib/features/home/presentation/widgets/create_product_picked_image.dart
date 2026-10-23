import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class CreateProductPickedImage {
  final XFile? file;
  final Uint8List? bytes;
  final String? previewUrl;
  final String? storagePath;

  const CreateProductPickedImage({
    required this.file,
    required this.bytes,
    this.previewUrl,
    this.storagePath,
  });

  const CreateProductPickedImage.existing({
    required this.previewUrl,
    required this.storagePath,
  }) : file = null,
       bytes = null;
}
