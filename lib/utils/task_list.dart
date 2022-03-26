import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/sectors/drawer/drawer_globals.dart'
as globals;

final ValueNotifier<Color> subtextColourNotifier = ValueNotifier(globals.getSubtextColour());

class TaskList extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  const TaskList(
      {Key? key,
      required this.icon,
      required this.iconBackgroundColor,
      required this.title,
      required this.subtitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: subtextColourNotifier,
      builder: (_, subtextColour, __) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundColor: iconBackgroundColor,
            child: Icon(
              icon,
              size: 15.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: subtextColour),
              ),
            ],
          )
        ],
      );
    });
  }
}
