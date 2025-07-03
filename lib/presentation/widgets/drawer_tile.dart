import 'package:flutter/material.dart';

class DrawerTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(widget.icon, color: Colors.white, size: 27),
            const SizedBox(width: 20),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'f',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
