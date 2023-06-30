import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mailtm_client/mailtm_client.dart';
import 'package:tmail/components/custom_slidable/src/actions.dart';
import 'package:tmail/components/custom_slidable/src/auto_close_behavior.dart';
import 'package:tmail/components/slidable_tile/slidable_tile.dart';
import 'package:tmail/models/temp_email.model.dart';
import 'package:tmail/pages/email_view/email_view.dart';
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

  _getEmails() async {
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            previousPageTitle: 'Mail',
            largeTitle: Text(widget.emailAccount.address.split('@')[0]),
            backgroundColor: AppColors.navBarColor,
            border: null,
            stretch: true,
          ),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 26.5, right: 20, top: 10),
                child: CupertinoActivityIndicator(),
              ),
            ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                SlidableAutoCloseBehavior(
                  child: _messages.isNotEmpty
                      ? CupertinoListSection.insetGrouped(
                          children: _messages.map((TMMessage message) {
                            // TMAccount acc = accountFromJson(email.toJson(), email.password);
                            return SlidableCupertinoTile(
                              additionalText: '',
                              isLoading: false,
                              onPress: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => EmailView(message: message))),
                              onEndSwipe: () {
                                print("End Swipe");
                              },
                              endActions: [
                                SlidableAction(
                                  onPressed: (context) {
                                    print("Action Pressed");
                                  },
                                  backgroundColor: CupertinoColors.systemPurple,
                                  foregroundColor: CupertinoColors.white,
                                  icon: CupertinoIcons.info_circle,
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    print("Action Pressed");
                                  },
                                  backgroundColor: CupertinoColors.systemRed,
                                  foregroundColor: CupertinoColors.white,
                                  icon: CupertinoIcons.trash,
                                ),
                              ],
                              title: 'From: ${message.from['address'] ?? ''}',
                              subTitle: Text(message.subject),
                              titleStyle: const TextStyle(fontSize: 15),
                              iconBackColor: CupertinoColors.activeGreen,
                              tileIcon: CupertinoIcons.mail,
                              onlyIcon: true,
                              isNotched: true,
                            );
                          }).toList(),
                        )
                      : !_isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 180.0),
                              child: Center(child: Text('No Emails', style: TextStyle(color: Color(0XFF777777)))),
                            )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
