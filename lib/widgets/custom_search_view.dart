import 'package:flutter/material.dart';
import 'package:spenzy/theme/theme_helper.dart';

class CustomSearchView extends StatefulWidget {
  final String hintText;
  final Widget prefix;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  CustomSearchView({
    required this.hintText,
    required this.prefix,
    required this.onChanged,
    required this.controller,
  });

  @override
  _CustomSearchViewState createState() => _CustomSearchViewState();
}

class _CustomSearchViewState extends State<CustomSearchView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1D1F2C),
        borderRadius: BorderRadius.circular(13.0),
        border: Border.all(color: appTheme.tealA400, width: 1.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          widget.prefix,
          SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white, fontFamily: 'Courgette'),
              ),
              style: TextStyle(fontSize: 20.0),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
