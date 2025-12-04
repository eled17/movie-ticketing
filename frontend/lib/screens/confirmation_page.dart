import 'package:flutter/material.dart';
import '../services/api.dart';

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Receive arguments from PaymentPage
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final showtimeId = args["showtimeId"] as int;
    final seats = List<String>.from(args["seats"]);
    final cardName = args["cardName"] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Confirmation"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchBookingDetails(showtimeId, seats),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final booking = snapshot.data!;
          final movieTitle = booking["movieTitle"] as String;
          final showtime = booking["showtime"] as String;
          final totalPrice = booking["totalPrice"] as double;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 80,
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Booking Confirmed!",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildInfoRow(Icons.movie, "Movie", movieTitle),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.access_time, "Showtime", showtime),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.event_seat, "Seats",
                          seats.join(', ')),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.credit_card, "Cardholder", cardName),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.attach_money, "Total Price",
                          "\$${totalPrice.toStringAsFixed(2)}"),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/movies', (route) => false);
                          },
                          child: Text(
                            "Back to Movies",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        SizedBox(width: 12),
        Text(
          "$label: ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Simulate fetching details from backend
  Future<Map<String, dynamic>> _fetchBookingDetails(
      int showtimeId, List<String> seats) async {
    final showtimes = await ApiService.getShowtimes();
    final showtime = showtimes.firstWhere((s) => s['id'] == showtimeId);

    final movieId = showtime['movie_id'];
    final movies = await ApiService.getMovies();
    final movie = movies.firstWhere((m) => m['id'] == movieId);
    final movieTitle = movie['title'];

    final pricePerSeat = 10.0;
    final totalPrice = seats.length * pricePerSeat;

    return {
      "movieTitle": movieTitle,
      "showtime": showtime['time'],
      "totalPrice": totalPrice,
    };
  }
}

