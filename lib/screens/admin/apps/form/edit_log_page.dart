import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_date_time_picker.dart';
import 'package:my_dorm/components/form_drop_down.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class EditLogPage extends StatefulWidget {
  const EditLogPage({super.key});

  @override
  State<EditLogPage> createState() => _EditLogPageState();
}

class _EditLogPageState extends State<EditLogPage> {
  final List<Map<String, dynamic>> dormitizenDataList = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kamarController = TextEditingController();
  String waktu = "";
  String? selectedDormitizen;
  String? selectedKategori;
  String error = "";
  bool _showSpinner = false;
  Future<void> searchDormitizen(String nomorKamar) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      dormitizenDataList.clear();
      String? token = await getToken();
      var response = await getDataToken('/user/$nomorKamar', token!);

      if (response['response'] != null) {
        List<Map<String, dynamic>> dormitizens = (response['response'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        for (var dormitizen in dormitizens) {
          dormitizenDataList.add({
            'id': dormitizen['dormitizen_id'],
            'nama': dormitizen['nama'],
          });
        }
        print('Проживающие: $dormitizens');
      } else {
        setState(() {
          error = "Проживающий не найден.";
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        error = "Ошибка: $e";
      });
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Column(
          children: [
            const AppBarPage(title: 'Добавить запись вручную'),
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
                      TextFormField(
                        controller: _kamarController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: basicInputDecoration("Номер комнаты").copyWith(
                          suffixIcon: IconButton(
                            onPressed: () async {
                              await searchDormitizen(_kamarController.text);
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Номер комнаты не может быть пустым';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: DropdownButtonFormField<String>(
                          style: kMediumTextStyle.copyWith(
                              fontSize: 16, color: Colors.black),
                          decoration: basicInputDecoration("Выберите проживающего"),
                          value: selectedDormitizen,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          items: dormitizenDataList
                              .map((Map<String, dynamic> dormitizen) {
                            return DropdownMenuItem<String>(
                              value: dormitizen['id'].toString(),
                              child: Text(dormitizen['nama']),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDormitizen = newValue;
                            });
                            print('Выбран проживающий: $selectedDormitizen');
                          },
                        ),
                      ),
                      FormDropDown(
                        kategoriItems: const ['Вход', 'Выход'],
                        title: 'Статус',
                        onItemSelected: (selectedItem) {
                          // Handle the selected item here
                          print('Выбран элемент: $selectedItem');
                        },
                      ),
                      FormDatePicker(
                        onDateTimeSelected: (selectedDateTime) {
                          // Handle the combined DateTime here
                          print('Выбранные дата и время: $selectedDateTime');
                        },
                      ),
                      GradientButton(
                          ontap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              try {
                                //_addInformasi();
        
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
      ),
    );
  }
}
