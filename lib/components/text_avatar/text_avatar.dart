import 'package:flutter/cupertino.dart';

class TextAvatar extends StatelessWidget {
  final String string;
  const TextAvatar({Key? key, required this.string}) : super(key: key);

  String _getInitials(String txt) {
    String initials = '';
    List<String> items = txt.split(' ');
    for (var item in items) {
      initials += item[0].toUpperCase();
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGrey2,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Center(
          child: Text(
        _getInitials(string),
        style: TextStyle(
          color: CupertinoTheme.of(context).brightness == Brightness.dark
              ? CupertinoColors.systemGrey6
              : const Color(0xFF1D1D1D),
          fontSize: 21,
        ),
      )),
    );
  }
}
