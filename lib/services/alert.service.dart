import 'package:flutter/cupertino.dart';

class AlertService {
  static void showAlertDialog(BuildContext context, AlertContent content) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(content.title),
        content: Text(content.content),
        actions: <CupertinoDialogAction>[
          if (content.showCancelButton == true)
            CupertinoDialogAction(
              isDestructiveAction: content.cancelBtnContent.isDestructive,
              isDefaultAction: content.cancelBtnContent.isDefault,
              onPressed: () {
                Navigator.pop(context);
                content.cancelBtnContent.onAction != null ? content.cancelBtnContent.onAction!() : null;
              },
              child: Text(content.cancelBtnContent.text),
            ),
          CupertinoDialogAction(
            isDestructiveAction: content.actionBtnContent.isDestructive,
            isDefaultAction: content.actionBtnContent.isDefault,
            onPressed: () {
              Navigator.pop(context);
              content.actionBtnContent.onAction != null ? content.actionBtnContent.onAction!() : null;
            },
            child: Text(content.actionBtnContent.text),
          ),
        ],
      ),
    );
  }
}

class AlertContent {
  final String title;
  final String content;
  final bool showCancelButton;
  final ActionBtnContent cancelBtnContent;
  final ActionBtnContent actionBtnContent;

  AlertContent({
    required this.actionBtnContent,
    required this.content,
    required this.title,
    this.showCancelButton = true,
    this.cancelBtnContent = const ActionBtnContent(text: 'Cancel', onAction: null),
  });
}

class ActionBtnContent {
  final String text;
  final bool isDestructive;
  final bool isDefault;
  final void Function()? onAction;

  const ActionBtnContent({
    this.isDefault = false,
    this.isDestructive = false,
    required this.text,
    required this.onAction,
  });
}
