import 'dart:convert';
import 'package:http/http.dart' as http;

class AiApiService {
  static const String baseUrl = 'https://massar-backend.onrender.com/api/v1';
  static const String placeholderToken = 'placeholder-token';
  
  // Static conversation ID so the backend keeps context of this session.
  static const String defaultConversationId = '123e4567-e89b-12d3-a456-426614174000';

  Future<String> sendMessage(String message) async {
    try {
      final uri = Uri.parse('$baseUrl/chat/send');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $placeholderToken',
        },
        body: json.encode({
          'message': message,
          'conversation_id': defaultConversationId,
        }),
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw Exception('Request timed out'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['assistant_message']['content'] as String;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (_) {
      // Re-throw to caller so the UI knows to fallback
      rethrow;
    }
  }
}
