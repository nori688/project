import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';

class Konfirmasi extends StatelessWidget {
  const Konfirmasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBarPage(title: 'Подтверждение'),
          Column(
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    gradient: kGradientMain,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: Icon(
                  Icons.check,
                  size: 100,
                  color: kWhite,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Данные успешно добавлены!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
            child: GradientButton(ontap: () {}, title: 'Назад'),
          )
        ],
      ),
    );
  }
}
