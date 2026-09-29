import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/faq_box.dart';
import 'package:my_dorm/components/filter_button.dart';
import 'package:my_dorm/components/search_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/faq_model.dart';

class FaqListPage extends StatelessWidget {
  const FaqListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<FaqModel> daftarFAQ = [
      FaqModel(
          title: "Что такое MyDorm?",
          content:
              "MyDorm — это инновация, разработанная специально для жителей общежития Telkom University. MyDorm решает главные проблемы жителей общежития: учёт входа/выхода и управление посылками. С приложением MyDorm жители общежития могут легко и точно отслеживать свой вход и выход, а также узнавать о посылках, которые доставлены и оставлены в хелпдеске.",
          hasImage: false,
      ),
      FaqModel(
          title: "Как узнать о поступившей посылке?",
          content:
              "В приложении MyDorm есть уведомления, которые сообщают пользователям о важной информации, в том числе о поступивших посылках. Поступившие посылки обрабатываются хелпдеском или старшим резидентом, а владелец посылки получает уведомление.",
          hasImage: false
      ),
      FaqModel(
          title: "Как подтвердить вход/выход?",
          content:
              '1. Откройте главную страницу\n2. Выберите опцию «вход/выход»\n3. Нажмите опцию «вход/выход» — и вы подтвердите вход/выход',
          hasImage: true
          
      )
    ];
    return Scaffold(
        backgroundColor: kBgColor,
        body: Column(children: [
          AppBarPage(
            title: 'FAQ',
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          Column(
              children: List.generate(
                  daftarFAQ.length,
                  (index) => FaqBox(
                      title: daftarFAQ[index].title,
                      content: daftarFAQ[index].content,
                      hasImage: daftarFAQ[index].hasImage,)))
        ]));
  }
}
