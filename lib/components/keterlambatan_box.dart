import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';

class KeterlambatanBox extends StatelessWidget {
  final String nama;
  final String reason;
  final DateTime date;

  const KeterlambatanBox({
    super.key,
    required this.nama,
    required this.reason,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ShadowContainer(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nama,
              textAlign: TextAlign.start,
              style: kBoldTextStyle.copyWith(fontSize: 14),
            ),
            Text(
              DateFormat('d MMMM yyyy - HH:mm', 'ru_RU').format(date),
              textAlign: TextAlign.start,
              style: kRegularTextStyle.copyWith(fontSize: 12, color: kGrey),
            ),
            SizedBox(height: 8), // Memberikan sedikit ruang sebelum alasan
            Row(
              children: [
                Expanded(
                  child: Text(
                    reason,
                    textAlign: TextAlign.start,
                    style: kMediumTextStyle.copyWith(fontSize: 14),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
