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
        bookedSeats =
            data.map<String>((ticket) => ticket['seat_number']).toSet();
      });
    } catch (e) {
      print("Error fetching booked seats: $e");
    }
  }

  void toggleSeatSelection(String seat) {
    if (bookedSeats.contains(seat)) return;

    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  Color getSeatColor(String seat) {
    if (bookedSeats.contains(seat)) return Colors.red;
    if (selectedSeats.contains(seat)) return Colors.blue;
    if (hoveredSeat == seat) return Colors.yellow;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Seats"),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),

          /// SCREEN INDICATOR
          Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              "SCREEN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),

          SizedBox(height: 30),

          /// SEATS GRID
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 60),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: seats.length,
              itemBuilder: (context, index) {
                String seat = seats[index];

                return MouseRegion(
                  onEnter: (_) => setState(() => hoveredSeat = seat),
                  onExit: (_) => setState(() {
                    if (hoveredSeat == seat) hoveredSeat = null;
                  }),
                  child: GestureDetector(
                    onTap: () => toggleSeatSelection(seat),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: getSeatColor(seat),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: selectedSeats.contains(seat) ? 8 : 2,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        seat,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// LEGEND
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _legendItem(Colors.green, "Available"),
                _legendItem(Colors.blue, "Selected"),
                _legendItem(Colors.red, "Booked"),
              ],
            ),
          ),
        ],
      ),

      /// BOOK BUTTON
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: selectedSeats.isEmpty
              ? null
              : () {
                  Navigator.pushNamed(
                    context,
                    "/payment",
                    arguments: {
                      "showtimeId": widget.showtimeId,
                      "seats": selectedSeats.toList(),
                    },
                  );
                },
          child: Text(
            "Book Selected Seats (${selectedSeats.length})",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}


