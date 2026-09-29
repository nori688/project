import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/common/report_list_page.dart';

class UnavailableFeaturesPage extends StatelessWidget {
  const UnavailableFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppBarPage(title: 'Название функции'),
          Column(
            children: [
              Icon(
                Icons.sentiment_very_dissatisfied,
                size: 150,
                color: kRed,
              ),
              SizedBox(height: 25),
              Text("Извините, эта функция пока недоступна"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GradientButton(
                ontap: () {
                  Navigator.pop(context);
                },
                title: 'Назад'),
          )
        ],
      ),
    );
  }
}
