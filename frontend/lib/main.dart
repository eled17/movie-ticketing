import 'package:flutter/material.dart';
import 'screens/movies_page.dart';
import 'screens/showtimes_page.dart';
import 'screens/seats_page.dart';
import 'screens/confirmation_page.dart';
import 'screens/payment_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Tickets',
      initialRoute: "/",
      routes: {
        "/": (context) => MoviesPage(),
        '/movies': (context) => MoviesPage(),
        "/showtimes": (context) {
          int movieId = ModalRoute.of(context)!.settings.arguments as int;
          return ShowtimesPage(movieId: movieId);
        },
        "/seats": (context) {
          int showtimeId = ModalRoute.of(context)!.settings.arguments as int;
          return SeatsPage(showtimeId: showtimeId);
        },
        '/confirmation': (context) => ConfirmationPage(),
        '/payment': (context) => PaymentPage(),
      },
    );
  }
}
