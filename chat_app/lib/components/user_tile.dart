// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 1.0,
            color: Colors.grey,
            margin: EdgeInsets.only(left: 70),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('images/userAvatar.jpg'),
                  ),
                ),
                SizedBox(width: 10),
                Text(text, style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 16,color: Theme.of(context).colorScheme.background)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}