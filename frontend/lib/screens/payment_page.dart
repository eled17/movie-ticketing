import 'package:flutter/material.dart';
import '../services/api.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool paymentProcessing = false;

  void processPayment(int showtimeId, List<String> seats) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      paymentProcessing = true;
    });

    try {
      // Simulate booking each seat via API
      for (String seat in seats) {
        await ApiService.bookTicket(showtimeId, seat);
      }

      setState(() {
        paymentProcessing = false;
      });

      // Navigate to confirmation page
      Navigator.pushNamed(
        context,
        "/confirmation",
        arguments: {
          "showtimeId": showtimeId,
          "seats": seats,
          "cardName": cardNameController.text,
        },
      );
    } catch (e) {
      setState(() {
        paymentProcessing = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final showtimeId = args["showtimeId"] as int;
    final seats = List<String>.from(args["seats"]);

    final totalPrice = seats.length * 10; // $10 per seat

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Payment Information",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Seats: ${seats.join(', ')}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Total Price: \$${totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Cardholder Name
                    TextFormField(
                      controller: cardNameController,
                      decoration: InputDecoration(
                        labelText: "Cardholder Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),
                    SizedBox(height: 16),

                    // Card Number
                    TextFormField(
                      controller: cardNumberController,
                      decoration: InputDecoration(
                        labelText: "Card Number",
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Required";
                        if (value.length != 16) return "Must be 16 digits";
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Expiration and CVV
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: expDateController,
                            decoration: InputDecoration(
                              labelText: "MM/YY",
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Required"
                                : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: cvvController,
                            decoration: InputDecoration(
                              labelText: "CVV",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            validator: (value) =>
                                value == null || value.length != 3
                                ? "3 digits required"
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Pay Now button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: paymentProcessing
                            ? null
                            : () => processPayment(showtimeId, seats),
                        child: paymentProcessing
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                "Pay Now",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
