import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyTicketsPage extends StatefulWidget {
  final int userId; // pass the logged-in user ID

  MyTicketsPage({required this.userId});

  @override
  _MyTicketsPageState createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  bool isLoading = true;
  List<dynamic> tickets = [];

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/tickets/user/${widget.userId}'), // replace with your backend URL
      );

      if (response.statusCode == 200) {
        setState(() {
          tickets = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tickets: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? Center(child: Text('You have no tickets yet.'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.movie, color: Colors.deepPurple),
                        title: Text(
                          'Seat: ${ticket['seat_number']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Showtime ID: ${ticket['showtime_id']}\nTicket ID: ${ticket['id']}'),
                        trailing: Icon(Icons.confirmation_num, color: Colors.green),
                      ),
                    );
                  },
                ),
    );
  }
}
