import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mailtm_client/mailtm_client.dart';
import 'package:tmail/models/temp_email.model.dart';
import 'package:tmail/redux/store/app.state.dart';
import 'package:tmail/redux/temp_email/temp_email_action.dart';
import 'package:tmail/services/email.service.dart';
import 'package:tmail/styles/app_colors.dart';

class AddEmail extends StatefulWidget {
  const AddEmail({super.key});

  @override
  State<AddEmail> createState() => _AddEmailState();
}

class _AddEmailState extends State<AddEmail> {
  late TextEditingController _emailAddressController;
  late TextEditingController _passwordController;
  late FocusNode _passwordBoxFocusNode;
  int _selectedDomain = 0;
  bool _shouldGenerateRandomPass = true;
  final double _kPasswordBoxMaxHeight = 45;
  double _passwordBoxHeight = 0;
  final double _kItemExtent = 32.0;
  List<TMDomain> _domainNames = [];

  @override
  void initState() {
    super.initState();
    _emailAddressController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _passwordBoxFocusNode = FocusNode();
    _getDomains();
  }

  _getDomains() async {
    final List<TMDomain> domainsList = await EmailService.getAvailableDomains();
    setState(() {
      _domainNames = domainsList;
    });
  }

  @override
  void dispose() {
    _emailAddressController.dispose();
    _passwordController.dispose();
    _passwordBoxFocusNode.dispose();
    super.dispose();
  }

  void _pickDomain() {
    _showDomainPicker(
      CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: _kItemExtent,
        scrollController: FixedExtentScrollController(initialItem: _selectedDomain),
        onSelectedItemChanged: (int selectedItem) {
          setState(() {
            _selectedDomain = selectedItem;
          });
        },
        children: List<Widget>.generate(_domainNames.length, (int index) {
          return Center(child: Text(_domainNames[index].domain));
        }),
      ),
    );
  }

  void _showDomainPicker(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(top: false, child: child),
      ),
    );
  }

  void _generateRandomAddress() {
    _emailAddressController.text = EmailService.generateRandomAddtess(10);
  }

  void _togglePasswordBox() {
    if (_shouldGenerateRandomPass) {
      _passwordBoxFocusNode.requestFocus();
    } else {
      _passwordBoxFocusNode.unfocus();
    }
    setState(() {
      _passwordBoxHeight = _shouldGenerateRandomPass ? _kPasswordBoxMaxHeight : 0;
      _shouldGenerateRandomPass = !_shouldGenerateRandomPass;
    });
  }

  void _registerAccount(BuildContext context) async {
    try {
      TMAccount account = await MailTm.register(
        username: _emailAddressController.text.isEmpty ? null : _emailAddressController.text,
        password: _passwordController.text.isEmpty ? null : _passwordController.text,
        domain: _domainNames.isEmpty ? null : _domainNames[_selectedDomain],
      );
      // ignore: use_build_context_synchronously
      StoreProvider.of<AppState>(context).dispatch(AddTempEmailAction(newEmail: TempEmail.fromJson(account.toJson())));
      // ignore: use_build_context_synchronously
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (e) {
      if (kDebugMode) print('Error in _registerAccount ${e.toString()}');
    }

    // print(account.toJson());
    // late StreamSubscription subscription;
    // subscription = account.messages.listen((e) async {
    //   print('Listened to message with id: $e');
    //   if (e.hasAttachments) {
    //     print('Message has following attachments:');
    //     e.attachments.forEach((a) => print('- $a'));
    //   }
    //   await account.delete();
    //   await subscription.cancel();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
            ),
            largeTitle: const Text('New Address'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _registerAccount(context),
              child: const Text('Create'),
            ),
            backgroundColor: AppColors.navBarColor,
            border: null,
            stretch: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
              child: CupertinoTextField(
                controller: _emailAddressController,
                placeholder: 'Address',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: _generateRandomAddress,
                  child: const Text('Random address'),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
              child: GestureDetector(
                onTap: _pickDomain,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0XffDfDfDf)),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: CupertinoColors.white,
                    ),
                    child: Text('@ ${_domainNames.isEmpty ? 'Select' : _domainNames[_selectedDomain].domain}'),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedContainer(
              height: _passwordBoxHeight,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              child: AnimatedOpacity(
                opacity: _shouldGenerateRandomPass ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  child: CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    focusNode: _passwordBoxFocusNode,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: _togglePasswordBox,
                    child: Icon(_shouldGenerateRandomPass ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.check_mark_circled),
                  ),
                  const Text('Generate random password')
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
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
