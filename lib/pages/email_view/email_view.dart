import 'package:flutter/cupertino.dart';
import 'package:mailtm_client/mailtm_client.dart';
import 'package:tmail/components/text_avatar/text_avatar.dart';
import 'package:tmail/services/date.service.dart';
import 'package:tmail/styles/app_colors.dart';

class EmailView extends StatelessWidget {
  final TMMessage message;
  const EmailView({super.key, required this.message});
  final Widget spacer = const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    message.seen ? null : message.see();
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.navBarColor,
        border: null,
        middle: Text(message.subject),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 110, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressView(message: message),
            spacer,
            Text(message.subject, style: theme.textTheme.navTitleTextStyle.copyWith(fontSize: 20)),
            spacer,
            Text(message.text),
            spacer,
            if (message.hasAttachments) Text(message.attachments[0].name),
          ],
        ),
      ),
    );
  }
}

class AddressView extends StatelessWidget {
  final TMMessage message;
  const AddressView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAvatar(string: message.from['address'] ?? ''),
        const SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'From: ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: message.from['address'] ?? '', style: const TextStyle(color: CupertinoColors.activeBlue)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'To: ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: message.to[0]['address'] ?? '', style: const TextStyle(color: CupertinoColors.activeBlue)),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    DateService.getReadableDate(
                      message.createdAt,
                      isTwelveHourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
                    ),
                    style: theme.textTheme.tabLabelTextStyle.copyWith(fontSize: 14)),
                const SizedBox(width: 10),
                if (message.hasAttachments) Icon(CupertinoIcons.paperclip, size: 14, color: theme.textTheme.tabLabelTextStyle.color)
              ],
            ),
          ],
        )
      ],
    );
  }
}
