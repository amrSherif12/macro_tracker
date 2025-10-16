import 'package:flutter/material.dart';

class InfoTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  const InfoTitle({super.key, required this.title, this.subTitle = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Divider(
            thickness: 2,
            endIndent: 110,
            indent: 110,
            height: 25,
            color: Colors.grey[800]!,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'F',
                    fontSize: 23,
                  ),
                ),
                subTitle.isNotEmpty
                    ? Text(
                        subTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'F',
                          fontSize: 15,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            endIndent: 110,
            indent: 110,
            height: 25,
            color: Colors.grey[800]!,
          ),
        ],
      ),
    );
  }
}
