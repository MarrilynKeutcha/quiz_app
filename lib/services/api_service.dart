import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Define the base URL as a static constant
  static const String baseUrl = "https://opentdb.com";

  // Fetch categories
  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/api_category.php"));
    if (response.statusCode == 200) {
      return json.decode(response.body)['trivia_categories'];
    } else {
      throw Exception("Failed to load categories");
    }
  }

  // Fetch questions
  static Future<List<dynamic>> fetchQuestions({
    required int amount,
    required int category,
    required String difficulty,
    required String type,
  }) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/api.php?amount=$amount&category=$category&difficulty=$difficulty&type=$type"));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception("Failed to load questions");
    }
  }
}
