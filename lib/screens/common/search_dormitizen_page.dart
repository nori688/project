import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';

class SearchDormitizenPage extends StatelessWidget {
  const SearchDormitizenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(children: [
      AppBarPage(
        title: 'Найти проживающего',
      ),
    ]));
  }
}
