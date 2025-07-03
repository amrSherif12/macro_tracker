import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  String errorMessage;
  ErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Image.asset('assets/imgs/error.png'),
              ),
            ),
            const Text(
              'Error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'f',
              ),
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'f',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
