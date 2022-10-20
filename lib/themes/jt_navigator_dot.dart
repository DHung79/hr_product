import 'package:flutter/material.dart';
import 'jt_theme.dart';

class JTNavigatorDot extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  const JTNavigatorDot({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        for (var i = 1; i <= itemCount; i++) _buildDot(currentIndex == i)
      ],
    );
  }

  Widget _buildDot(bool isLine) {
    return AnimatedContainer(
      width: isLine ? 40 : 10,
      height: 10,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isLine ? JTColors.pPurple : JTColors.n300,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
