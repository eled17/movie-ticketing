import 'package:flutter/material.dart';
import '../services/api.dart';

// Showtime model
class Showtime {
  final int id;
  final int movieId;
  final String time;

  Showtime({required this.id, required this.movieId, required this.time});

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'],
      movieId: json['movie_id'],
      time: json['time'],
    );
  }
}

class ShowtimesPage extends StatefulWidget {
  final int movieId;

  ShowtimesPage({required this.movieId});

  @override
  _ShowtimesPageState createState() => _ShowtimesPageState();
}

class _ShowtimesPageState extends State<ShowtimesPage> {
  late Future<List<Showtime>> futureShowtimes;

  @override
  void initState() {
    super.initState();
    futureShowtimes = fetchShowtimes();
  }

  Future<List<Showtime>> fetchShowtimes() async {
    final data = await ApiService.getShowtimes();
    return data
        .map<Showtime>((json) => Showtime.fromJson(json))
        .where((show) => show.movieId == widget.movieId)
        .toList();
  }

  // Helper to get a lively gradient based on index
  LinearGradient getGradient(int index) {
    final gradients = [
      LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
      LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
      LinearGradient(colors: [Colors.purple, Colors.pinkAccent]),
      LinearGradient(colors: [Colors.green, Colors.lightGreen]),
      LinearGradient(colors: [Colors.teal, Colors.cyanAccent]),
    ];
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Showtimes"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Showtime>>(
        future: futureShowtimes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No showtimes available"));
          }

          final showtimes = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
              ),
              itemCount: showtimes.length,
              itemBuilder: (context, index) {
                final show = showtimes[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/seats",
                          arguments: show.id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: getGradient(index),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          show.time,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


