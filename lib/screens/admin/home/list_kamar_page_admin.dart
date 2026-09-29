import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/list/list_pelanggaran_page.dart';
import 'package:my_dorm/service/http_service.dart';

class ListKamarPageAdmin extends StatefulWidget {
  const ListKamarPageAdmin({super.key});

  @override
  State<ListKamarPageAdmin> createState() => _ListKamarPageAdminState();
}

class _ListKamarPageAdminState extends State<ListKamarPageAdmin> {
  List<Map<String, dynamic>> kamars = [];
  String error = "";
  bool _showSpinner = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getKamar();
  }

  Future<void> getKamar() async {
    setState(() {
      _showSpinner = true;
      error = "";
    });
    try {
      String? token = await getToken();
      var response = await getDataToken('/kamar/status/all', token!);
      if (response['data'] != null) {
        setState(() {
          kamars = (response['data'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        });
        print('Комнаты: $kamars');
      } else {
        setState(() {
          error = "Нет данных о комнатах.";
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

  /// Filter kamar berdasarkan lantai
  List<Map<String, dynamic>> getKamarByLantai(int lantai) {
    return kamars
        .where((kamar) => kamar['nomor'].startsWith('$lantai'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarPage(
            title: 'Комнаты',
            canBack: false,
          ),
          const SizedBox(height: 10),
          if (_showSpinner)
            const Center(child: CircularProgressIndicator())
          else if (error.isNotEmpty)
            Center(
              child: Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    _selectedIndex = value;
                  });
                },
                itemCount: 4,
                itemBuilder: (context, pageIndex) {
                  int floorNumber = pageIndex + 1;
                  List<Map<String, dynamic>> kamarLantai =
                      getKamarByLantai(floorNumber);

                  int kamarCount = (floorNumber == 1) ? 20 : 24;

                  return Column(
                    children: [
                      Text(
                        'Этаж $floorNumber',
                        style: kBoldTextStyle.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: kamarCount,
                          itemBuilder: (context, index) {
                            if (index < kamarLantai.length) {
                              var kamar = kamarLantai[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListPelanggaranPage(
                                                  noKamar: kamar['nomor'])));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (kamar['status'] == 'terkunci')
                                        ? kGray
                                        : kRed,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${kamar['nomor']}',
                                      textAlign: TextAlign.center,
                                      style: kBoldTextStyle.copyWith(
                                        fontSize: 24,
                                        color: (kamar['status'] == 'terkunci')
                                            ? Colors.black.withOpacity(0.4)
                                            : kWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: kGray,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    'Н/Д',
                                    textAlign: TextAlign.center,
                                    style: kBoldTextStyle.copyWith(
                                      fontSize: 24,
                                      color: kWhite,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => AnimatedContainer(
                margin: const EdgeInsets.only(right: 6),
                height: 5,
                width: (index == _selectedIndex) ? 25 : 12,
                decoration: BoxDecoration(
                  color: (index == _selectedIndex)
                      ? Colors.black.withOpacity(0.75)
                      : Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(2.5),
                ),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOutQuint,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
