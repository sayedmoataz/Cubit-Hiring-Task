import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/branches/domain/entities/branch_entity.dart';
import '../widgets/custom_toast/custom_toast.dart';

class UrlLuncherUtils {
  static Future<void> launchDirections(
    BuildContext context,
    BranchEntity branch,
  ) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${branch.latitude},${branch.longitude}',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          CustomToast.error(context, 'Could not open maps');
        }
      }
    } catch (_) {
      if (context.mounted) {
        CustomToast.error(context, 'Could not open maps');
      }
    }
  }

  static Future<void> launchPhone(BuildContext context, String phone) async {
    final url = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (_) {
      if (context.mounted) {
        CustomToast.error(context, 'Could not make phone call');
      }
    }
  }
}
