// ignore_for_file: use_build_context_synchronously

import 'package:assessment/shared/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtil {
  /// Launch a URL and handle errors
  static Future<void> customLaunchUrl(
    String url, {
    required BuildContext context,
    bool isExternal = false,
  }) async {
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: isExternal
              ? LaunchMode.externalApplication
              : LaunchMode.inAppWebView,
        );
      } else {
        showSnackbar(
          context,
          'Could not launch the URL: $url',
          color: Colors.red.shade600,
        );
      }
    } catch (e) {
      showSnackbar(
        context,
        'Failed to launch the URL. Error: $e',
        color: Colors.red.shade600,
      );
    }
  }
}
