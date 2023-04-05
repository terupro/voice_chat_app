import 'dart:convert';
import 'package:http/http.dart' as http;

String apiKey = "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";

class ApiServices {
  static String baseUrl = "https://api.openai.com/v1/chat/completions";
  static Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  static Future<String?> sendMessage(String? message) async {
    var res = await http.post(
      Uri.parse(baseUrl),
      headers: header,
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ],
        "temperature": 0.7,
        "max_tokens": 50,
        "top_p": 1,
        "frequency_penalty": 0.0,
        "presence_penalty": 0.0,
      }),
    );
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      var msg = data["choices"][0]["message"]["content"];
      return msg;
    } else {
      print("Failed to fetch data");
    }
  }
}
