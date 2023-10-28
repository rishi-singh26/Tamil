import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mailtm_client/mailtm_client.dart';
import 'package:tmail/components/custom_slidable/src/actions.dart';
import 'package:tmail/components/custom_slidable/src/auto_close_behavior.dart';
import 'package:tmail/components/slidable_tile/slidable_tile.dart';
import 'package:tmail/models/temp_email.model.dart';
import 'package:tmail/pages/email_view/email_view.dart';
import 'package:tmail/services/alert.service.dart';
import 'package:tmail/services/date.service.dart';
import 'package:tmail/styles/app_colors.dart';

class EmailList extends StatefulWidget {
  final TempEmail emailAccount;
  const EmailList({
    super.key,
    required this.emailAccount,
  });

  @override
  State<EmailList> createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {
  late StreamSubscription? subscription;
  List<TMMessage> _messages = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _getEmails();
  }

  @override
  void dispose() {
    super.dispose();
    // subscription ?? subscription?.cancel();
  }

  Future<void> _getEmails() async {
    try {
      TMAccount account = await MailTm.login(
        id: widget.emailAccount.id,
        address: widget.emailAccount.address,
        password: widget.emailAccount.password,
      );
      List<TMMessage> messages = await account.getMessages();
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) print('Error in _getEmails ${e.toString()}');
    }
  }

  void _confirmMessageDeletetion(BuildContext context, TMMessage message) {
    AlertService.showAlertDialog(
      context,
      AlertContent(
        actionBtnContent: ActionBtnContent(text: 'Delete', onAction: () => message.delete(), isDestructive: true),
        content: "Are you sure you want to delete this mailbox? All the emails in this mailbox will be permanently deleted.",
        title: 'Alert',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            previousPageTitle: 'Mailboxes',
            largeTitle: Text(widget.emailAccount.address.split('@')[0]),
            backgroundColor: AppColors.navBarColor,
            border: null,
          ),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 26.5, right: 20, top: 10),
                child: CupertinoActivityIndicator(),
              ),
            ),
          CupertinoSliverRefreshControl(onRefresh: _getEmails),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                AnimatedOpacity(
                  opacity: _messages.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: SlidableAutoCloseBehavior(
                    child: CupertinoListSection.insetGrouped(
                      children: _messages.isNotEmpty
                          ? _messages.map((TMMessage message) {
                              // TMAccount acc = accountFromJson(email.toJson(), email.password);
                              return SlidableCupertinoTile(
                                additionalText: '',
                                isLoading: false,
                                onPress: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => EmailView(message: message))),
                                onEndSwipe: () => _confirmMessageDeletetion(context, message),
                                onStartSwipe: () => message.see(),
                                endActions: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      print("Action Pressed");
                                    },
                                    backgroundColor: CupertinoColors.systemPurple,
                                    foregroundColor: CupertinoColors.white,
                                    icon: CupertinoIcons.cloud_download,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) => _confirmMessageDeletetion(context, message),
                                    backgroundColor: CupertinoColors.systemRed,
                                    foregroundColor: CupertinoColors.white,
                                    icon: CupertinoIcons.trash,
                                  ),
                                ],
                                startActions: [
                                  SlidableAction(
                                    onPressed: (context) => message.see(),
                                    backgroundColor: CupertinoColors.systemBlue,
                                    foregroundColor: CupertinoColors.white,
                                    icon: CupertinoIcons.envelope_open_fill,
                                  ),
                                ],
                                title: 'From: ${message.from['address'] ?? ''}',
                                subTitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(message.subject),
                                    Text(DateService.getReadableDate(
                                      message.createdAt,
                                      isTwelveHourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
                                    )),
                                  ],
                                ),
                                titleStyle: const TextStyle(fontSize: 15),
                                iconBackColor: CupertinoColors.activeGreen,
                                tileIcon: message.seen ? CupertinoIcons.mail : CupertinoIcons.mail_solid,
                                onlyIcon: true,
                                isNotched: true,
                              );
                            }).toList()
                          : [const SizedBox.shrink()],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _isLoading || _messages.isNotEmpty ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 180.0),
                    child: Center(child: Text('No Emails', style: TextStyle(color: Color(0XFF777777)))),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
