import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

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
              child: Image.asset('assets/imgs/nointernet.png'),
            ),
            const Text(
              'No Internet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'f',
              ),
            ),
            const Text(
              'Try reloading the page or checking you internet connection.',
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
