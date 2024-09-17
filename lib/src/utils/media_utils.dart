import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class MediaUtils {
  static Future<String?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  static Future<String?> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }

  static Future<String> saveUserImageToDirectory(
      Uint8List imageData, String uid) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/user_images');
      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }
      final file = File('${imagesDirectory.path}/user_image_$uid.png');
      await file.writeAsBytes(imageData);
      print('Image saved successfully to: ${file.path}');
      return file.path;
    } catch (e) {
      print('Error saving image: $e');
      return Future.error('Error saving image: $e');
    }
  }

  static Future<String> saveUserFaceBase64ImageToDirectory(
      String base64imageString, String uid) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/user_images');

      // Create the directory if it doesn't exist
      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }

      final file =
          File('${imagesDirectory.path}/user_face_base64_image_$uid.txt');

      // Write the base64 string to the file
      await file.writeAsString(base64imageString);
      print('Image base64 saved successfully to: ${file.path}');
      return file.path; // Return the file path
    } catch (e) {
      print('Error saving image base64: $e');
      return Future.error('Error saving image base64: $e');
    }
  }

  Future<Uint8List> fetchImageAsUint8List(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

//take Uint8List as input and lower its size and return as Uint8List

  /// Function to resize the image if its width is greater than 1000 pixels.
  /// Takes Uint8List as input and returns the resized Uint8List.
  Future<Uint8List> resizeImage(Uint8List uintImage, int maxFileWidth) async {
    // Decode the image to get its dimensions and data
    img.Image? image = img.decodeImage(uintImage);

    if (image == null) {
      throw Exception('Unable to decode image');
    }

    // Check if the image's width is greater than 1000, and resize if needed
    if (image.width > maxFileWidth) {
      // Resize the image to have a maximum width of 1000 pixels
      image = img.copyResize(image, width: maxFileWidth);
    }

    // Encode the resized (or original) image to Uint8List
    Uint8List resizedImage = Uint8List.fromList(img.encodeJpg(image));

    return resizedImage;
  }
}
