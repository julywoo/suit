import 'package:bykak/src/model/bottom_size_model.dart';
import 'package:bykak/src/model/customer/customer_model.dart';
import 'package:bykak/src/model/shirt_size_model.dart';
import 'package:bykak/src/model/top_size_model.dart';
import 'package:bykak/src/model/vest_size_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';

class CsvUpload extends StatefulWidget {
  const CsvUpload({super.key});

  @override
  State<CsvUpload> createState() => _CsvUploadState();
}

class _CsvUploadState extends State<CsvUpload> {
  List<List<dynamic>>? csvData;

  Future<List<List<dynamic>>> processCsv() async {
    var result = await DefaultAssetBundle.of(context).loadString(
      "test1.csv",
    );
    return const CsvToListConverter().convert(result, eol: "\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Csv reader"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: csvData == null
            ? const CircularProgressIndicator()
            : DataTable(
                columns: csvData![0]
                    .map(
                      (item) => DataColumn(
                        label: Text(
                          item.toString(),
                        ),
                      ),
                    )
                    .toList(),
                rows: csvData!
                    .map(
                      (csvrow) => DataRow(
                        cells: csvrow
                            .map(
                              (csvItem) => DataCell(
                                Text(
                                  csvItem.toString(),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          csvData = await processCsv();
          print(csvData!.length);
          // print(csvData.toString());
          print(csvData!.length.toString());
          for (var i = 0; i < csvData!.length; i++) {
            List csvDataTemp = csvData![i];
            if (i == 0) {
              print('이름:' + csvDataTemp[0].toString());
              print('연락처:' + csvDataTemp[1].toString());
              print('잔여:' +
                  csvDataTemp[2]
                      .toString()
                      .replaceAll(',', '')
                      .replaceAll(' ', ''));
              print('누적:' +
                  csvDataTemp[3]
                      .toString()
                      .replaceAll(',', '')
                      .replaceAll(' ', ''));
              print('사용:' +
                  csvDataTemp[4]
                      .toString()
                      .replaceAll(',', '')
                      .replaceAll(' ', ''));
            }
          }
          setState(() {});
        },
      ),
    );
  }

  void customerInsert(
      String name, String phone, int point, int accruedPoint, int usedPoint) {
    TopSize _inputTopSize = TopSize();
    BottomSize _inputBottomSize = BottomSize();
    VestSize _inputVestSize = VestSize();
    ShirtSize _inputShirtSize = ShirtSize();

    phone = phone.replaceAll('-', '').replaceAll(' ', '');
    if (phone.length < 1) {
      phone = '01000000000';
    } else {
      phone = phone.replaceAll('-', '');
    }

    String formatPhone = "";
    if (phone.toString().length == 11) {
      formatPhone = phone.toString().substring(7, 11);
    } else if (phone.toString().length == 10) {
      formatPhone = phone.toString().substring(6, 10);
    } else {
      // formatPhone = "01000000000";
    }

    final customers = FirebaseFirestore.instance
        .collection('customers')
        .doc('${name}_${formatPhone}_바이각제물포점');

    Customer customerData = Customer(
        name: name,
        phone: phone,
        gender: '0',
        birthDate: '',
        firstVisitDate: '20230101',
        lastVisitDate: '20230101',
        storeName: '바이각제물포점',
        grade: '바이각제물포점',
        point: point,
        accruedPoint: accruedPoint,
        usedPoint: accruedPoint,
        purchaseAmount: 0,
        purchaseCount: 1,
        etc: '',
        height: '',
        weight: '',
        shoulderShape: '',
        pointHistory: [],
        legShape: '',
        posture: '',
        eventAgree: 'Y',
        topSize: _inputTopSize,
        bottomSize: _inputBottomSize,
        vestSize: _inputVestSize,
        shirtSize: _inputShirtSize);
    try {
      customers.set(customerData.toJson());
    } catch (e) {
      print(e);
    }
  }
}
