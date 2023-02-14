import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class PrivacyTerms extends StatefulWidget {
  const PrivacyTerms({Key? key}) : super(key: key);

  @override
  State<PrivacyTerms> createState() => _PrivacyTermsState();
}

class _PrivacyTermsState extends State<PrivacyTerms> {
  String dataFromFile = "";

  @override
  void initState() {
    readText();
    super.initState();
  }

  Future<void> readText() async {
    final String response =
        await rootBundle.loadString('assets/policy/privacy_terms.txt');
    setState(() {
      dataFromFile = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, size: 25.0, color: Colors.black),
        ),
        elevation: 0,
        title: Text(
          '개인정보 처리방침',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              dataFromFile,
              style: TextStyle(fontFamily: 'NanumGothic'),
            ),
          ),
        ),
      ),
    );
  }
}

// class PrivacyTerms extends StatefulWidget {
//   const PrivacyTerms({Key? key}) : super(key: key);

//   @override
//   _PrivacyTermsState createState() => _PrivacyTermsState();
// }

// class _PrivacyTermsState extends State<PrivacyTerms> {
  
// }
