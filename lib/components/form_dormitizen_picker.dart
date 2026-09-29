import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/common/search_dormitizen_page.dart';

class FormDormitizenPicker extends StatefulWidget {
  const FormDormitizenPicker({super.key});

  @override
  State<FormDormitizenPicker> createState() => _FormDormitizenPickerState();
}

class _FormDormitizenPickerState extends State<FormDormitizenPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SearchDormitizenPage()));
        },
        child: InputDecorator(
          decoration: basicInputDecoration('Проживающий'),
          child: const Text(
            'Выберите проживающего',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
