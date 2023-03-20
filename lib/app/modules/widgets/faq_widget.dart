import 'package:flutter/material.dart';

class Faq extends StatefulWidget {
  Faq({Key? key, required this.data, this.title}) : super(key: key);
  final List<List<String>> data;
  final String? title;
  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Column(
              // children: widget.data.map((group) {
              //   int index = widget.data.indexOf(group) + 1;
              //   return ListExpandableWidget(
              //     isExpanded: index == 0,
              //     header: _header('Question $index'),
              //     items: _buildItems(context, group),
              //   );
              // }).toList(),
              )
        ],
      ),
    );
  }
}
