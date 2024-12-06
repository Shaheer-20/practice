import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getOpenAIResponse(String prompt) async {
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  const String url =
      'https://api.openai.com/v1/chat/completions'; // Correct URL for chat completions

  if (apiKey.isEmpty) {
    throw Exception('API key is missing!');
  }

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: json.encode({
      'model': 'gpt-3.5-turbo', // Make sure this is 'gpt-3.5-turbo'
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 100,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data['choices'][0]['message']['content'].trim();
  } else {
    if (kDebugMode) {
      print('Error: ${response.body}');
    } // Print the full error response
    throw Exception('Failed to get response from OpenAI: ${response.body}');
  }
}
