import 'package:flutter/material.dart';
// import 'package:frontend/screens/home_page.dart';
import 'screens/movies_page.dart';
import 'screens/showtimes_page.dart';
import 'screens/seats_page.dart';
import 'screens/confirmation_page.dart';
import 'screens/payment_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/my_tickets_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Tickets',
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
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
        '/my_tickets': (context) {
            final userId = ModalRoute.of(context)!.settings.arguments as int;
            return MyTicketsPage(userId: userId);
          },

      },
    );
  }
}
