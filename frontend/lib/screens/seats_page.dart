import 'package:flutter/material.dart';
import '../services/api.dart';

class SeatsPage extends StatefulWidget {
  final int showtimeId;

  SeatsPage({required this.showtimeId});

  @override
  _SeatsPageState createState() => _SeatsPageState();
}

class _SeatsPageState extends State<SeatsPage> {
  List<String> seats = List.generate(30, (i) => "A${i + 1}");
  Set<String> bookedSeats = {};
  Set<String> selectedSeats = {};
  String? hoveredSeat;

  @override
  void initState() {
    super.initState();
    loadBookedSeats();
  }

  Future<void> loadBookedSeats() async {
    try {
      final data = await ApiService.getTickets(widget.showtimeId);
      setState(() {
        bookedSeats = data.map<String>((ticket) => ticket['seat_number']).toSet();
      });
    } catch (e) {
      print("Error fetching booked seats: $e");
    }
  }


  void toggleSeatSelection(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  void bookSelectedSeats() async {
    if (selectedSeats.isEmpty) return;

    try {
      for (String seat in selectedSeats) {
        await ApiService.bookTicket(widget.showtimeId, seat);
      }
      // After booking, refresh booked seats and clear selection
      await loadBookedSeats();
      setState(() {
        selectedSeats.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tickets booked successfully!")),
      );
    } catch (e) {
      print("Error booking tickets: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to book tickets")),
      );
    }
  }

  Color getSeatColor(String seat) {
    if (bookedSeats.contains(seat)) return Colors.red;
    if (hoveredSeat == seat) return Colors.yellow;
    if (selectedSeats.contains(seat)) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Seats"),
      ),
      body: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(16),
        children: seats.map((seat) {
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                hoveredSeat = seat;
              });
            },
            onExit: (_) {
              setState(() {
                if (hoveredSeat == seat) hoveredSeat = null;
              });
            },
            child: GestureDetector(
              onTap: bookedSeats.contains(seat)
                  ? null
                  : () {
                      toggleSeatSelection(seat);
                    },
              child: Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: getSeatColor(seat),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    seat,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: selectedSeats.isEmpty
              ? null
              : () {
                  // Navigate to payment page with selected seats
                  Navigator.pushNamed(
                    context,
                    "/payment",
                    arguments: {
                      "showtimeId": widget.showtimeId,
                      "seats": selectedSeats.toList(),
                    },
                  );
                },
          child: Text("Book Selected Seats (${selectedSeats.length})"),
        ),
),

    );
  }
}

