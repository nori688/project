import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';

class RequestBox extends StatelessWidget {
  final String nama;
  final String type;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestBox({
    super.key,
    required this.nama,
    required this.type,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ShadowContainer(
        onTap: () {},
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('images/dormitizen.png'),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nama,
                        textAlign: TextAlign.start,
                        style: kBoldTextStyle.copyWith(fontSize: 14)),
                    RichText(
                        text: TextSpan(
                            style: kMediumTextStyle.copyWith(
                                fontSize: 12, color: Colors.black),
                            children: [
                          const TextSpan(text: 'подтверждение '),
                          TextSpan(
                              text: (type == 'In') ? 'вход' : 'выход',
                              style: kBoldTextStyle.copyWith(
                                  fontSize: 14, color: kRed)),
                          const TextSpan(text: ' общежитие'),
                        ])),
                  ]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onReject,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: kGradientMain,
                    borderRadius: BorderRadius.circular(4)),
                child: const Icon(
                  FluentIcons.dismiss_24_filled,
                  color: kWhite,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAccept,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    gradient: kGradientGreen,
                    borderRadius: BorderRadius.circular(4)),
                child: const Icon(
                  FluentIcons.checkmark_24_filled,
                  color: kWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
