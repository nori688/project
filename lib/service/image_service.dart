
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_dorm/constant/constant.dart';

class MyNetworkImage extends StatelessWidget {
  final String? imageURL;
  final double? width;
  final double? height;
  final double? nullHeight;
  final BoxFit? fit;
  const MyNetworkImage({
    super.key,
    required this.imageURL,
    this.width,
    this.height,
    this.nullHeight,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (imageURL == null || imageURL!.isEmpty) {
      return Container(
        width: width,
        height: nullHeight ?? height,
        color: Colors.grey[300],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported),
            Text(
              'Нет изображения',
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    return Image.network(imageURL!, width: width, height: height, fit: fit,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: kRed,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      }
    }, errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_not_supported),
            Text(
              'Не удалось загрузить изображение',
              textAlign: TextAlign.center,
              style: kRegularTextStyle.copyWith(fontSize: 10),
            )
          ],
        ),
      );
    });
  }
}

class ImageService {
  XFile? selectedImage;
  final ImagePicker _picker = ImagePicker();

  XFile? getSelectedImage() {
    return selectedImage;
  }

  Future<XFile?> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = pickedFile;
      return pickedFile;
    } else {
      print("Изображение не выбрано");
      return null;
    }
  }

  void clearImage() {
    selectedImage = null;
  }
}
