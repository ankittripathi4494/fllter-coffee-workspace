import 'package:flutter/material.dart';

class CustomDialog {
  static showDialogDeleteRequest(BuildContext context,
      {bool? barrierDismissible,
      Color? barrierColor,
      Widget? icon,
      Widget? title,
      Widget? content,
      List<Widget>? actions,
      MainAxisAlignment? actionsAlignment}) {
    return showDialog(
      context: context,
      barrierColor: (barrierColor != null) ? barrierColor : null,
      barrierDismissible:
          (barrierDismissible != null) ? barrierDismissible : true,
      builder: (context) => AlertDialog(
        icon: (icon != null) ? icon : null,
        title: (title != null) ? title : null,
        content: (content != null) ? content : null,
        actionsAlignment: (actionsAlignment != null) ? actionsAlignment : null,
        actions: (actions != null) ? actions : null,
      ),
    );
  }
}
