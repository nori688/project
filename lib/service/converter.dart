import 'package:intl/intl.dart';

String getFormattedDate(String date) {
  // Format: Hari, Tanggal Bulan Tahun
  try {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate =
        DateFormat('EEEE, d MMMM y', 'ru_RU').format(parsedDate);

    return formattedDate;
  } catch (e) {
    print('Ошибка разбора даты: $e');
    return 'Данные некорректны';
  }
}

String getFormattedTime() {
  DateTime sekarang = DateTime.now();
  int jam = sekarang.hour;
  if (jam >= 4 && jam < 10) {
    return 'Доброе утро';
  } else if (jam >= 10 && jam < 15) {
    return 'Добрый день';
  } else if (jam >= 15 && jam < 18) {
    return 'Добрый вечер';
  } else {
    return 'Доброй ночи';
  }
}
