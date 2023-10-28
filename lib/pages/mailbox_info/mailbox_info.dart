import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tmail/components/progress_bar/progress_bar.dart';
import 'package:tmail/models/temp_email.model.dart';
import 'package:tmail/services/alert.service.dart';
import 'package:tmail/services/byte_converter.service.dart';
import 'package:tmail/styles/app_colors.dart';

class MailBoxInfo extends StatefulWidget {
  final TempEmail mailBox;
  const MailBoxInfo({super.key, required this.mailBox});

  @override
  State<MailBoxInfo> createState() => _MailBoxInfoState();
}

class _MailBoxInfoState extends State<MailBoxInfo> {
  final Widget spacer = const SizedBox(height: 5);
  double blurValue = 5;

  void _showInfo(BuildContext context, String info) {
    AlertService.showAlertDialog(
      context,
      AlertContent(
        actionBtnContent: const ActionBtnContent(text: 'Ok', onAction: null, isDefault: true),
        content: info,
        showCancelButton: false,
        title: 'Info',
      ),
    );
  }

  ColorAndText _getColorAndText() {
    if (widget.mailBox.isDeleted) {
      return ColorAndText(color: CupertinoColors.systemRed, string: 'Deleted');
    } else if (widget.mailBox.isDisabled) {
      return ColorAndText(color: CupertinoColors.systemYellow, string: 'Disabled');
    } else {
      return ColorAndText(color: CupertinoColors.activeGreen, string: 'Active');
    }
  }

  void _togglePasswordVisiblity() {
    setState(() {
      blurValue = blurValue == 5 ? 0 : 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorAndText colorAndText = _getColorAndText();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            previousPageTitle: 'Mailboxes',
            largeTitle: Text('Details'),
            backgroundColor: AppColors.navBarColor,
            border: null,
            stretch: true,
          ),
          SliverToBoxAdapter(
            child: CupertinoCard(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: 200,
                    //   height: 200,
                    //   child: BackdropFilter(
                    //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    //     child: Container(
                    //       child: const Text("This is the blurred widget"),
                    //       // Add child widgets here
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: [
                        const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('  ●  ', style: TextStyle(fontSize: 14, color: colorAndText.color)),
                        Text(colorAndText.string),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _showInfo(context,
                                    'If you wish to use this account on Web browser, You can copy the credentials to use on Mail.tm official website. Please note, the password cannot be reset or changed.');
                              },
                              child: const Icon(CupertinoIcons.info_circle, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Address:  ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Flexible(child: Text(widget.mailBox.address, overflow: TextOverflow.ellipsis)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.mailBox.address));
                          },
                          child: const Icon(CupertinoIcons.doc_on_doc, size: 18),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Password:  ', style: TextStyle(fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: _togglePasswordVisiblity,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                            child: Text(widget.mailBox.password),
                          ),
                        ),
                        // BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Text(widget.mailBox.password)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.mailBox.password));
                          },
                          child: const Icon(CupertinoIcons.doc_on_doc, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          SliverToBoxAdapter(
            child: CupertinoCard(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quota Left:', style: TextStyle(fontWeight: FontWeight.bold)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _showInfo(context,
                                'Once you reach your Quota limit, you cannot receive any more messages. Deleting your previous messages will free up your used Quota.');
                          },
                          child: const Icon(CupertinoIcons.info_circle, size: 18),
                        ),
                      ],
                    ),
                    spacer,
                    Text(
                      '${ByteConverterService(widget.mailBox.used.toDouble()).toHumanReadable(SizeUnit.KB)} / ${ByteConverterService(widget.mailBox.quota.toDouble()).toHumanReadable(SizeUnit.MB)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    spacer,
                    // Putting a minimum value of 1000000 so that the progress bar is not empty
                    ProgressBar(
                        filled: widget.mailBox.used < 1000000 ? 1000000 : widget.mailBox.used.toDouble(), total: widget.mailBox.quota.toDouble())
                  ],
                ),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: CupertinoListSection.insetGrouped(
          //     children: const [
          //       CupertinoListTile(
          //         title: Text('title, style: titleStyle'),
          //         subtitle: Text('subTitle'),
          //         leading: Icon(CupertinoIcons.add_circled),
          //         additionalInfo: Text('4'),
          //         trailing: CupertinoListTileChevron(),
          //         // onTap: () {},
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}

class CupertinoCard extends StatelessWidget {
  final Widget child;
  const CupertinoCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }
}

class ColorAndText {
  final Color color;
  final String string;

  ColorAndText({required this.color, required this.string});
}
