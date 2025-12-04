import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8000";

  // Get movies
  static Future<List<dynamic>> getMovies() async {
    var response = await http.get(Uri.parse("$baseUrl/movies"));
    return jsonDecode(response.body);
  }

  // Get showtimes
  static Future<List<dynamic>> getShowtimes() async {
    var response = await http.get(Uri.parse("$baseUrl/showtimes"));
    return jsonDecode(response.body);
  }

  // Book ticket
  static Future<dynamic> bookTicket(int showtimeId, String seatNumber) async {
    var response = await http.post(
      Uri.parse("$baseUrl/tickets"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"showtime_id": showtimeId, "seat_number": seatNumber}),
    );
    return jsonDecode(response.body);
  }

  // Get tickets for specific movie
  static Future<List<dynamic>> getTickets(int showtimeId) async {
  final response = await http.get(Uri.parse("$baseUrl/tickets/$showtimeId"));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } 
  else {
      throw Exception("Failed to fetch tickets");
    }
  }
}
