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
      "test.csv",
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
        scrollDirection: Axis.horizontal,
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
          print(csvData.toString());
          print(csvData!.length.toString());
          for (var i = 0; i < csvData!.length; i++) {
            List csvDataTemp = csvData![i];
            print('이름:' + csvDataTemp[0].toString());
            print('연락처:' + csvDataTemp[1].toString());
            print('등급:' + csvDataTemp[2].toString());
            print('포인트:' + csvDataTemp[3].toString());
            print('잔여:' + csvDataTemp[4].toString());
          }
          setState(() {});
        },
      ),
    );
  }
}
