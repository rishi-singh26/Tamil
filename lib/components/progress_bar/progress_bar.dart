import 'package:flutter/cupertino.dart';

class ProgressBar extends StatelessWidget {
  final double filled;
  final double total;

  const ProgressBar({super.key, required this.filled, required this.total});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          FractionallySizedBox(
            widthFactor: filled / total,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.activeGreen,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
