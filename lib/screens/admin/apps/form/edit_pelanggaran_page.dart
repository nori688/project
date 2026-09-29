import 'package:cross_file/cross_file.dart';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_date_time_picker.dart';
import 'package:my_dorm/components/form_drop_down.dart';
import 'package:my_dorm/components/form_photo_picker.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class EditPelanggaranPage extends StatefulWidget {
  final String noKamar;
  final String dormitizenId;
  final String pelanggaranId;
  final String kategori;
  final String waktu;
  final String dormitizenName;
  const EditPelanggaranPage(
      {super.key,
      required this.noKamar,
      required this.dormitizenId,
      required this.pelanggaranId,
      required this.kategori,
      required this.waktu,
      required this.dormitizenName});

  @override
  State<EditPelanggaranPage> createState() => _EditPelanggaranPageState();
}

class _EditPelanggaranPageState extends State<EditPelanggaranPage> {
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _DormitizenController = TextEditingController();
  final TextEditingController _kamarController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  XFile? gambar;
  final List<Map<String, dynamic>> dormitizenDataList = [];
  final _formKey = GlobalKey<FormState>();
  String waktu = "";
  String? selectedKategori;

  String error = "";
  String infoSnackbar = "Нарушение успешно изменено!";
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();
    _DormitizenController.text = widget.dormitizenName;

    _kamarController.text = widget.noKamar;
    // waktu = widget.waktu;
    // DateTime dateTime = DateTime.parse(widget.waktu).toLocal();
    // _waktuController.text = DateFormat('hh:mm a').format(dateTime);

    // _kategoriController.text = widget.kategori;
    // selectedKategori = widget.kategori;
  }

  Future<void> _editPelanggaran() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    dynamic response = {};
    try {
      dev.log('изображение: ${gambar?.path}');
      Map<String, String> data = {
        'kategori': selectedKategori!,
        'waktu': waktu,
        'dormitizen_id': widget.dormitizenId,
      };
      dev.log('Отправляемые данные: $data');
      dev.log('ID нарушения: ${widget.pelanggaranId}');
      response = await updateDataTokenWithFile(
          "/pelanggaran/${widget.pelanggaranId}", data, gambar);
      dev.log('Ответ на изменение нарушения: $response');
      if (mounted) {
        setState(() {
          infoSnackbar = 'Нарушение успешно изменено!';
        });
      } else {
        setState(() {
          infoSnackbar = 'Не удалось изменить нарушение';
        });
      }
      print(response['message']);
    } catch (e) {
      setState(() {
        _showSpinner = false;
        infoSnackbar = 'Не удалось изменить нарушение!';
        error = "${response['message']}";
      });
      print('Ошибка входа: $e');
      print(response);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Column(
          children: [
            const AppBarPage(title: 'Изменить нарушение'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: false,
                          controller: _kamarController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration:
                              basicInputDecoration("Номер комнаты").copyWith(),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            enabled: false,
                            controller: _DormitizenController,
                            decoration:
                                basicInputDecoration("Проживающий").copyWith(),
                          ),
                        ),
                        FormDropDown(
                          title: 'Категория',
                          kategoriItems: const [
                            'Курение',
                            'Опоздание',
                            'Вейп',
                            'Алкоголь',
                            'Запрещённые предметы',
                            'Нахождение с лицом противоположного пола в комнате',
                            'Приглашение гостей извне общежития',
                          ],
                          onItemSelected: (selectedItem) {
                            selectedKategori = selectedItem;
                          },
                        ),
                        FormDatePicker(
                          onDateTimeSelected: (selectedDateTime) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(selectedDateTime!);
                            waktu = formattedDate;
                          },
                        ),
                        FormPhotoPicker(
                          title: 'нарушение',
                          onImageSelected: (selectedImage) {
                            if (selectedImage != null) {
                              print(
                                  'Путь к изображению: ${selectedImage.path}');
                              setState(() {
                                gambar = selectedImage;
                              });
                            } else {
                              print('Изображение удалено');
                            }
                          },
                        ),
                        GradientButton(
                          ontap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (waktu != "" && gambar != null) {
                                try {
                                  _editPelanggaran();

                                  // Create the SnackBar
                                  var snackBar = SnackBar(
                                    content: Text(infoSnackbar),
                                  );

                                  // Show the SnackBar
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.pop(context, 'sesuatu');
                                } catch (e) {
                                  print(e);
                                }
                              } else {}
                            } else {
                              print('Форма недействительна');
                            }
                          },
                          title: 'Сохранить изменения',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
