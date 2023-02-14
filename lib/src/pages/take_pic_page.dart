// import 'dart:io';

// import 'package:bykak/src/app.dart';
// import 'package:bykak/src/widget/custom_elevated_buttod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:permission_handler/permission_handler.dart';

// class TakePicPage extends StatefulWidget {
//   TakePicPage({Key? key}) : super(key: key);

//   @override
//   State<TakePicPage> createState() => _TakePicPageState();
// }

// class _TakePicPageState extends State<TakePicPage> {
//   File? _image, _image1, _image2;
//   final picker = ImagePicker();
//   int picCount = 0;
//   bool pic = false;
//   String picTitle = "정면 촬영";
//   var imagePathList = List<String>.filled(3, "");
//   var orderNo = Get.arguments['orderNo'];

//   // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
//   Future getImage(ImageSource imageSource) async {
//     final image = await picker.pickImage(
//       source: imageSource,
//     );

//     setState(() {
//       if (picCount == 1) {
//         _image = File(image!.path);
//       } else if (picCount == 2) {
//         _image1 = File(image!.path);
//       } else {
//         _image2 = File(image!.path);
//       }
//       // 가져온 이미지를 _image에 저장
//     });
//   }

//   // 이미지를 보여주는 위젯
//   Widget showImage() {
//     return Container(
//         color: Colors.white,
//         height: MediaQuery.of(context).size.height * 0.5,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Center(
//                 child: _image == null
//                     ? Container(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         color: Colors.white,
//                         child: Center(
//                             child: Text(
//                           "정면",
//                           style: TextStyle(color: Colors.black),
//                         )),
//                       )
//                     : Container(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         child: Image.file(
//                           File(_image!.path),
//                         ))),
//             Center(
//                 child: _image1 == null
//                     ? Container(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         color: Colors.white,
//                         child: Center(
//                             child: Text(
//                           "측면",
//                           style: TextStyle(color: Colors.black),
//                         )),
//                       )
//                     : Container(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         child: Image.file(
//                           File(_image1!.path),
//                         ))),
//             Center(
//                 child: _image2 == null
//                     ? Container(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         color: Colors.white,
//                         child: Center(
//                             child: Text(
//                           "후면",
//                           style: TextStyle(color: Colors.black),
//                         )),
//                       )
//                     : Container(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         child: Image.file(
//                           File(_image2!.path),
//                         ))),
//           ],
//         ));
//   }

//   // 이미지를 보여주는 위젯
//   Widget showImage1() {
//     return Container(
//         color: Colors.white,
//         width: 30.w,
//         height: MediaQuery.of(context).size.width,
//         child: Center(
//             child: _image1 == null
//                 ? Container(
//                     color: Colors.white,
//                     child: Text("2"),
//                   )
//                 : Image.file(File(_image1!.path))));
//   }

//   // 이미지를 보여주는 위젯
//   Widget showImage2() {
//     return Container(
//         color: Colors.white,
//         width: 30.w,
//         height: MediaQuery.of(context).size.width,
//         child: Center(
//             child: _image2 == null
//                 ? Container(
//                     color: Colors.white,
//                     child: Text("3"),
//                   )
//                 : Image.file(File(_image2!.path))));
//   }

//   Future _uploadFile(BuildContext context) async {
//     try {
//       for (int i = 0; i < 3; i++) {
//         var subTitle;
//         if (i == 0) {
//           subTitle = "front";
//         } else if (i == 1) {
//           subTitle = "side";
//         } else {
//           subTitle = "back";
//         }
// // 스토리지에 업로드할 파일 경로
//         final firebaseStorageRef = FirebaseStorage.instance
//             .ref()
//             .child('post') //'post'라는 folder를 만들고
//             .child(orderNo + '_subTitle.png');
//         var uploadTask;
//         if (i == 0) {
//           // 파일 업로드
//           uploadTask = firebaseStorageRef.putFile(
//               _image!, SettableMetadata(contentType: 'image/png'));
//         } else if (i == 1) {
//           // 파일 업로드
//           uploadTask = firebaseStorageRef.putFile(
//               _image1!, SettableMetadata(contentType: 'image/png'));
//         } else {
//           // 파일 업로드
//           uploadTask = firebaseStorageRef.putFile(
//               _image2!, SettableMetadata(contentType: 'image/png'));
//         }

//         // 완료까지 기다림
//         await uploadTask.whenComplete(() => null);

//         // 업로드 완료 후 url
//         final downloadUrl = await firebaseStorageRef.getDownloadURL();
//         imagePathList[i] = downloadUrl;
//       }

//       // 문서 작성
//       await FirebaseFirestore.instance.collection('image').doc(orderNo).set({
//         // 'contents': textEditingController.text,
//         // 'displayName': widget.user.displayName,
//         //  'email': widget.user.email,
//         'customImgFront': imagePathList[0],
//         'customImgSide': imagePathList[1],
//         'customImgBack': imagePathList[2],
//         //  'userPhotoUrl': widget.user.photoURL
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   void saveImage() {}

//   @override
//   Widget build(BuildContext context) {
//     // 화면 세로 고정
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             '촬영 목록',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Text(
//             '수트 완성도를 높이기 위한 신체 특징 촬영입니다.',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//             child: showImage(),
//           ),
//           SizedBox(
//             height: 50.0,
//           ),
//           picCount < 3
//               ? Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//                   child: ElevatedButton(
//                       style: TextButton.styleFrom(
//                         primary: Colors.white, //글자색
//                         onSurface: Colors.white, //onpressed가 null일때 색상
//                         backgroundColor: HexColor('#172543'),
//                         shadowColor: Colors.white, //그림자 색상
//                         elevation: 10, // 버튼 입체감
//                         textStyle: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w700),
//                         //padding: EdgeInsets.all(16.0),
//                         minimumSize: Size(300, 60), //최소 사이즈
//                         side: BorderSide(
//                             color: HexColor('#172543'), width: 1.0), //선
//                         shape:
//                             StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
//                         alignment: Alignment.center,
//                       ), //글자위치 변경
//                       onPressed: () {
//                         try {
//                           getImage(ImageSource.camera);
//                           picCount++;
//                           print("picCount:" + picCount.toString());
//                         } catch (e) {
//                           print(e);
//                         }
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.add_a_photo),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text('촬영하기'),
//                         ],
//                       )),
//                 )

//               // Row(
//               //     mainAxisAlignment: MainAxisAlignment.center,
//               //     children: <Widget>[
//               //       // 카메라 촬영 버튼
//               //       // FloatingActionButton(
//               //       //   child: Icon(Icons.add_a_photo),
//               //       //   tooltip: 'pick Iamge',
//               //       //   onPressed: () {
//               //       //     getImage(ImageSource.camera);
//               //       //   },
//               //       // ),
//               //       //upload
//               //     ],
//               //   )
//               : ElevatedButton(
//                   style: TextButton.styleFrom(
//                     primary: HexColor('#172543'), //글자색
//                     onSurface: Colors.white, //onpressed가 null일때 색상
//                     backgroundColor: HexColor('#FFFFFF'),
//                     shadowColor: Colors.white, //그림자 색상
//                     elevation: 10, // 버튼 입체감
//                     textStyle:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                     //padding: EdgeInsets.all(16.0),
//                     minimumSize: Size(300, 60), //최소 사이즈
//                     side:
//                         BorderSide(color: HexColor('#172543'), width: 1.0), //선
//                     shape:
//                         StadiumBorder(), // : 각진버튼, CircleBorder : 동그라미버튼, StadiumBorder : 모서리가 둥근버튼,
//                     alignment: Alignment.center,
//                   ), //글자위치 변경
//                   onPressed: () {
//                     try {
//                       _uploadFile(context);
//                       Get.offAll(App());
//                     } catch (e) {
//                       print(e);
//                     }
//                   },
//                   child: Text('저장하기')),
//           // Container(
//           //     child: FloatingActionButton(
//           //       child: Icon(Icons.add_a_photo),
//           //       tooltip: 'Upload',
//           //       onPressed: () {
//           //         try {
//           //           setState(() {
//           //             picCount++;
//           //           });
//           //           _uploadFile(context);
//           //         } catch (e) {}
//           //       },
//           //     ),
//           //   ),
//         ],
//       ),
//     );
//   }
// }
