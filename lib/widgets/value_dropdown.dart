import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ValueDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T?> onChanged;
  final String labelText;
  final IconData iconData;

  const ValueDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.labelText,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff80a6ff),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.only(left: 15.0),
      child: InputDecorator(
        decoration: InputDecoration(
          icon: Icon(
            iconData,
            color: const Color(0xfff8f8f8),
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.roboto(fontSize: 18),
          border: InputBorder.none,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            dropdownColor: const Color(0xff80a6ff),
            hint: Text(
              labelText,
              style: GoogleFonts.lobster(fontSize: 18),
            ),
            value: selectedItem,
            items: items.map<DropdownMenuItem<T>>((dynamic item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.getName,
                  style: GoogleFonts.lobster(fontSize: 18),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
