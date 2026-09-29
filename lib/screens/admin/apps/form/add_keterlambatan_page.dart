import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_textfield.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';

class AddKeterlambatanPage extends StatefulWidget {
  const AddKeterlambatanPage({super.key});

  @override
  State<AddKeterlambatanPage> createState() => _AddKeterlambatanPageState();
}

class _AddKeterlambatanPageState extends State<AddKeterlambatanPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        children: [
          const AppBarPage(title: 'Добавить опоздание'),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    FormTextField(label: 'Заголовок', controller: _judulController),
                    FormTextField(
                      label: 'Описание',
                      controller: _deskripsiController,
                      minLines: 3,
                    ),
                    GradientButton(
                        ontap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {

                                // Create the SnackBar
                                const snackBar = SnackBar(
                                  content: Text('Данные успешно добавлены!'),
                                );

                                // Show the SnackBar
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context, 'sesuatu');
                              } catch (e) {
                                print(e);
                              }
                          }
                        },
                        title: 'Отправить')
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
