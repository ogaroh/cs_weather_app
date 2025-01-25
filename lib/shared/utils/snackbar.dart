// show scaffold snackbar
// ignore_for_file: avoid_redundant_argument_values, cascade_invocations

import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context,
  String text, {
  Color? color,
  IconData? icon,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
  messenger.showSnackBar(
    SnackBar(
      backgroundColor: color ?? Colors.black,
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              icon ?? Icons.info_outline,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
