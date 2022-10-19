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
        for (var i = 1; i <= itemCount; i++)
          i == currentIndex ? _buildLine() : _buildDot()
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: JTColors.n300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 40,
      height: 10,
      decoration: BoxDecoration(
        color: JTColors.pPurple,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
