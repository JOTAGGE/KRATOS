import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ImageUploadService {
  // Client-ID público anônimo para envio de imagens
  static const String _imgurClientId = 'Client-ID 544ba371e8e8154';

  /// Faz o upload de bytes de imagem (funciona em Web, Android e iOS)
  static Future<String?> uploadImageToImgur(Uint8List imageBytes) async {
    try {
      final uri = Uri.parse('https://api.imgur.com/3/image');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = _imgurClientId
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: 'profile_picture.jpg',
          ),
        );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String imageUrl = data['data']['link'];
        return imageUrl;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}