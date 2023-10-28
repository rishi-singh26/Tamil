import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mailtm_client/mailtm_client.dart';
import 'package:tmail/components/custom_slidable/src/actions.dart';
import 'package:tmail/components/custom_slidable/src/auto_close_behavior.dart';
import 'package:tmail/components/slidable_tile/slidable_tile.dart';
import 'package:tmail/models/temp_email.model.dart';
import 'package:tmail/pages/add_email/add_email.dart';
import 'package:tmail/pages/email_list/email_list.dart';
import 'package:tmail/pages/mailbox_info/mailbox_info.dart';
import 'package:tmail/redux/store/app.state.dart';
import 'package:tmail/redux/temp_email/temp_email_action.dart';
import 'package:tmail/services/alert.service.dart';
import 'package:tmail/styles/app_colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _confirmDelete(BuildContext context, TempEmail emailBox) {
    AlertService.showAlertDialog(
      context,
      AlertContent(
        actionBtnContent: ActionBtnContent(text: 'Delete', onAction: () => _deleteMailBox(context, emailBox), isDestructive: true),
        content: "Are you sure you want to delete this mailbox? All the emails in this mailbox will be permanently deleted.",
        title: 'Alert',
      ),
    );
  }

  Future<void> _deleteMailBox(BuildContext context, TempEmail emailBox) async {
    try {
      StoreProvider.of<AppState>(context).dispatch(RemoveOneTempEmail(removedEmail: emailBox));
      TMAccount account = await MailTm.login(id: emailBox.id, address: emailBox.address, password: emailBox.password);
      account.delete();
    } catch (e) {
      if (kDebugMode) print('Error in _deleteMailBox $e');
    }
  }

  void _navigateToDetails(TempEmail email) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return MailBoxInfo(mailBox: email);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Mailboxes'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('Add'),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return const AddEmail();
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            // leading: CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   child: const Text('Delete All'),
            //   onPressed: () {
            //     StoreProvider.of<AppState>(context).dispatch(RemoveAllTempEmail());
            //   },
            // ),
            backgroundColor: AppColors.navBarColor,
            border: null,
            stretch: true,
          ),
          StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    SlidableAutoCloseBehavior(
                      child: state.emailData.emails.isNotEmpty
                          ? CupertinoListSection.insetGrouped(
                              children: state.emailData.emails.map((email) {
                                // TMAccount acc = accountFromJson(email.toJson(), email.password);
                                return SlidableCupertinoTile(
                                  additionalText: '',
                                  isLoading: false,
                                  onPress: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => EmailList(emailAccount: email))),
                                  onEndSwipe: () => _confirmDelete(context, email),
                                  onStartSwipe: () => _navigateToDetails(email),
                                  endActions: [
                                    SlidableAction(
                                      onPressed: (context) => _confirmDelete(context, email),
                                      backgroundColor: CupertinoColors.systemRed,
                                      foregroundColor: CupertinoColors.white,
                                      icon: CupertinoIcons.trash,
                                    ),
                                  ],
                                  startActions: [
                                    SlidableAction(
                                      onPressed: (context) => _navigateToDetails(email),
                                      backgroundColor: CupertinoColors.systemYellow,
                                      foregroundColor: CupertinoColors.white,
                                      icon: CupertinoIcons.info_circle,
                                    ),
                                  ],
                                  title: email.name.isNotEmpty ? email.name : email.address,
                                  iconBackColor: CupertinoColors.activeGreen,
                                  tileIcon: CupertinoIcons.tray,
                                  onlyIcon: true,
                                  isNotched: false,
                                );
                              }).toList(),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 180.0),
                              child: CupertinoButton(child: const Text('Create a temp mail.'), onPressed: () {}),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
