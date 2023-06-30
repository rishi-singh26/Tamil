import 'package:flutter/cupertino.dart';
import 'package:tmail/components/dummy_icon/dummy_icon.dart';
import 'package:tmail/components/custom_slidable/flutter_slidable.dart';

class SlidableCupertinoTile extends StatelessWidget {
  final List<SlidableAction>? endActions;
  final List<SlidableAction>? startActions;
  final Function()? onEndSwipe;
  final Function()? onStartSwipe;
  final Function() onPress;
  final bool isLoading;
  final String additionalText;
  final String title;
  final String? subTitle;
  final IconData tileIcon;
  final Color iconBackColor;
  final bool? onlyIcon;
  final bool? isNotched;
  const SlidableCupertinoTile({
    Key? key,
    required this.additionalText,
    this.endActions,
    required this.isLoading,
    required this.onPress,
    this.onEndSwipe,
    this.onStartSwipe,
    this.startActions,
    required this.title,
    this.subTitle,
    required this.tileIcon,
    required this.iconBackColor,
    this.onlyIcon,
    this.isNotched,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (endActions == null && startActions == null) {
      if (isNotched == false) {
        return CupertinoListTile(
          title: Text(title),
          subtitle: subTitle == null ? null : Text(subTitle ?? ''),
          leading: onlyIcon == true ? Icon(tileIcon) : DummyIcon(color: iconBackColor, icon: tileIcon),
          additionalInfo: isLoading ? const CupertinoActivityIndicator(radius: 8) : Text(additionalText),
          trailing: const CupertinoListTileChevron(),
          onTap: onPress,
        );
      }
      return CupertinoListTile.notched(
        title: Text(title),
        subtitle: subTitle == null ? null : Text(subTitle ?? ''),
        leading: onlyIcon == true ? Icon(tileIcon) : DummyIcon(color: iconBackColor, icon: tileIcon),
        additionalInfo: isLoading ? const CupertinoActivityIndicator(radius: 8) : Text(additionalText),
        trailing: const CupertinoListTileChevron(),
        onTap: onPress,
      );
    }
    return Slidable(
      key: const ValueKey(0),
      endActionPane: endActions == null
          ? null
          : ActionPane(
              dismissible: DismissiblePane(
                onDismissed: () async {
                  await onEndSwipe!();
                },
              ),
              motion: const ScrollMotion(),
              children: endActions ?? [],
            ),
      startActionPane: startActions == null
          ? null
          : ActionPane(
              dismissible: DismissiblePane(
                onDismissed: () async {
                  await onStartSwipe!();
                },
              ),
              motion: const ScrollMotion(),
              children: startActions ?? [],
            ),
      child: isNotched == false
          ? CupertinoListTile(
              title: Text(title),
              subtitle: subTitle == null ? null : Text(subTitle ?? ''),
              leading: onlyIcon == true ? Icon(tileIcon) : DummyIcon(color: iconBackColor, icon: tileIcon),
              additionalInfo: isLoading ? const CupertinoActivityIndicator(radius: 8) : Text(additionalText),
              trailing: const CupertinoListTileChevron(),
              onTap: onPress,
            )
          : CupertinoListTile.notched(
              title: Text(title),
              subtitle: subTitle == null ? null : Text(subTitle ?? ''),
              leading: onlyIcon == true ? Icon(tileIcon) : DummyIcon(color: iconBackColor, icon: tileIcon),
              additionalInfo: isLoading ? const CupertinoActivityIndicator(radius: 8) : Text(additionalText),
              trailing: const CupertinoListTileChevron(),
              onTap: onPress,
            ),
    );
  }
}
