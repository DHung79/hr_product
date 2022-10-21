import 'package:flutter/material.dart';

import '../themes/jt_theme.dart';

class JTDropdownButtonFormField<T> extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Function(T?)? onSaved;
  final String? Function(T?)? validator;
  final List<Map<String, dynamic>> dataSource;
  final T defaultValue;
  final Function(T?)? onChanged;
  final Function()? onTap;
  const JTDropdownButtonFormField({
    Key? key,
    this.title,
    this.titleStyle,
    required this.defaultValue,
    required this.dataSource,
    this.onSaved,
    this.validator,
    required this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    T displayedValue = defaultValue;
    if (displayedValue == null) {
      // Get the first value of the `dataSource`
      if (dataSource.isEmpty) {
        return const Text('DataSource must not be empty');
      }
      displayedValue = dataSource[0]['name'];
    }
    if (displayedValue == null) {
      return const Text('Could not find the default value');
    }
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: JTColors.n300,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: JTColors.n300,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      isExpanded: true,
      value: displayedValue,
      iconSize: 24,
      elevation: 16,
      icon: SvgIcon(
        SvgIcons.arrowIosDownward,
        size: 24,
      ),
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      items: dataSource.map<DropdownMenuItem<T>>((Map<String, dynamic> value) {
        return DropdownMenuItem<T>(
          value: value['value'] as T,
          child: Text(
            value['name'],
          ),
        );
      }).toList(),
    );
  }
}
