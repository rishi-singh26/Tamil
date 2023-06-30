import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tmail/components/custom_slidable/src/actions.dart';
import 'package:tmail/components/custom_slidable/src/auto_close_behavior.dart';
import 'package:tmail/components/slidable_tile/slidable_tile.dart';
import 'package:tmail/pages/add_email/add_email.dart';
import 'package:tmail/pages/email_list/email_list.dart';
import 'package:tmail/redux/store/app.state.dart';
import 'package:tmail/redux/temp_email/temp_email_action.dart';
import 'package:tmail/styles/app_colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Mail'),
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
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('Delete All'),
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(RemoveAllTempEmail());
              },
            ),
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
                                  additionalText: '0',
                                  isLoading: false,
                                  onPress: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => EmailList(emailAccount: email))),
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
                                  title: email.address,
                                  iconBackColor: CupertinoColors.activeGreen,
                                  tileIcon: CupertinoIcons.mail,
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
