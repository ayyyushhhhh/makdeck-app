import 'package:flutter/material.dart';
import 'package:makdeck/screens/home_page.dart';
import '../../services/authentication/user_authentication.dart';

class OrderConfirmScreen extends StatelessWidget {
  final String orderId;
  const OrderConfirmScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            Text(
              "Hey ${FirebaseAuthentication.getUserName}",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your order has been placed successfully.\nWe Will connect with you soon',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Your Order Id: $orderId",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                    (Route<dynamic> route) => false);
              },
              child: const SizedBox(
                width: double.infinity,
                height: 80,
                child: Center(
                  child: Text(
                    "Continue Shopping",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
