import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color cardColor;

  const TaskCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.cardColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(top: 5, bottom: 10),


      child: Padding(
      padding: const EdgeInsets.only(left: 10), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(top:10, bottom:10),child:
          Text(

            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          ),
          Padding(padding: const EdgeInsets.only(top:10, bottom:10),child:
          Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
      ),

        ],
      ),
    ),
        elevation: (5),
    );
  }
}
