// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';

class FormTextField extends StatelessWidget {
  final int? minLines;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  const FormTextField({
    super.key,
    this.minLines,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        textAlign: TextAlign.start,
        minLines: minLines,
        maxLines: minLines,
        controller: controller,
        validator: (validator == null)
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите $label';
                }
                return null;
              }
            : validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        style: kSemiBoldTextStyle.copyWith(fontSize: 16),
        decoration: basicInputDecoration(label),
      ),
    );
  }
}
