import 'package:flutter/cupertino.dart';
import 'package:tmail/models/temp_email.model.dart';
// import 'package:tmail/services/mailtm/mailtm_client.dart';
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
  @override
  void initState() {
    super.initState();
    _getEmails();
  }

  _getEmails() async {
    // String token = await getToken(widget.emailAccount.address, widget.emailAccount.password);
    // TMAccount account = accountFromJson(widget.emailAccount.toJson(), widget.emailAccount.password, token);

    try {
      // List<TMMessage> messages = await account.getMessages();
      // for (var element in messages) {
      //   print(element.toJson());
      // }
      // subscription = account.messages.listen((e) async {
      //   print('Listened to message with id: $e');
      //   if (e.hasAttachments) {
      //     print('Message has following attachments:');
      //     e.attachments.forEach((a) => print('- $a'));
      //   }
      // });
    } catch (e) {
      print('Error in _getEmails ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            previousPageTitle: 'Mail',
            largeTitle: Text('Details'),
            backgroundColor: AppColors.navBarColor,
            border: null,
            stretch: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 26.5, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.info_circle_fill, color: CupertinoColors.systemYellow),
                  SizedBox(width: 15),
                  SizedBox(width: 300, child: Text('The password ones set can not be reset or changed')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
