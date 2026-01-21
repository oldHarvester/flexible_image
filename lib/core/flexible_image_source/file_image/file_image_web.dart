// ignore_for_file: implementation_imports

import 'package:flutter/rendering.dart';
import 'package:flutter_svg/src/utilities/file.dart';

class FileImage extends ImageProvider {
  const FileImage(
    this.file, {
    this.scale = 1.0,
  });
  
  final File file;
  final double scale;

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    throw UnimplementedError();
  }
}
