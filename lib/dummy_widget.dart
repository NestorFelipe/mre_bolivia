// import 'package:fix_store/base/resizer/fetch_pixels.dart';
// import 'package:flutter/material.dart';
//
// import 'base/color_data.dart';
// import 'base/constant.dart';
// import 'base/widget_utils.dart';
//
// class DummyWidget extends StatefulWidget
// {
//   @override
//   State<StatefulWidget> createState() {
//     return _DummyWidget();
//   }
//
// }
//
// class _DummyWidget extends State<DummyWidget>
// {
//
//   TextEditingController emailController=TextEditingController();
//   FocusNode myFocusNode = FocusNode();
//
//   bool minLines=false;
//   @override
//   Widget build(BuildContext context) {
//     FetchPixels(context);
//     final mqData = MediaQuery.of(context);
//     final mqDataNew = mqData.copyWith(textScaleFactor: FetchPixels.getTextScale());
//
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: backGroundColor,
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           padding: EdgeInsets.symmetric(horizontal: FetchPixels.getDefaultHorSpace(context)),
//           child: ListView(
//             primary: true,
//             shrinkWrap: true,
//             children: [
//               getVerSpace(FetchPixels.getPixelHeight(70)),
//               getCustomFont("Login", 24, Colors.black, 1,
//                   fontWeight: FontWeight.w900),
//               getVerSpace(FetchPixels.getPixelHeight(10)),
//               getCustomFont("Glad to meet you again! ", 16, Colors.black, 1,
//                   fontWeight: FontWeight.w400),
//               getVerSpace(FetchPixels.getPixelHeight(30)),
//               // getDefaultTextFiledWithLabel(
//               //   context,
//               //   "Email",
//               //   emailController,
//               //   Colors.grey,
//               //   function: () {},
//               //   height: FetchPixels.getPixelHeight(60),
//               //   isEnable: false,
//               //   withprefix: true,
//               //   image: "message.svg",
//               // ),
//               // TextField(
//               //   maxLines: (minLines) ? null : 1,
//               //   controller: emailController,
//               //   obscuringCharacter: "*",
//               //   autofocus: false,
//               //   obscureText: false,
//               //   showCursor: false,
//               //   onTap: () {
//               //     // function();
//               //   },
//               //   style: const TextStyle(
//               //       color: Colors.black,
//               //       fontWeight: FontWeight.w400,
//               //       fontSize: 16, fontFamily: Constant.fontsFamily),
//               //   decoration: InputDecoration(
//               //       contentPadding: EdgeInsets.zero,
//               //       border: InputBorder.none,
//               //       hintText: "hint",
//               //       hintStyle: TextStyle(
//               //           color: textColor,
//               //           fontWeight: FontWeight.w400,
//               //           fontSize: 16,
//               //           fontFamily: Constant.fontsFamily)),
//               // ),
//               // getVerSpace(FetchPixels.getPixelHeight(20)),
//               getDefaultTextFiledWithLabel(
//                   context, "Password", passwordController, Colors.grey,
//                   function: () {},
//                   height: FetchPixels.getPixelHeight(60),
//                   isEnable: false,
//                   withprefix: true,
//                   image: "lock.svg",
//                   isPass: ispass,
//                   withSufix: true,
//                   suffiximage: "eye.svg", imagefunction: () {
//                 setState(() {
//                   ispass = !ispass;
//                 });
//               }),
//               // getVerSpace(FetchPixels.getPixelHeight(19)),
//               // Align(
//               //     alignment: Alignment.topRight,
//               //     child: GestureDetector(
//               //       onTap: () {
//               //         Constant.sendToNext(context, Routes.forgotRoute);
//               //       },
//               //       child: getCustomFont("Forgot Password?", 16, blueColor, 1,
//               //           fontWeight: FontWeight.w900, fontFamily: "Bold"),
//               //     )),
//               // getVerSpace(FetchPixels.getPixelHeight(49)),
//               // getButton(context, blueColor, "Login", Colors.white, () {
//               //   PrefData.setLogIn(true);
//               //   Constant.sendToNext(context, Routes.homeScreenRoute);
//               // }, 18,
//               //     weight: FontWeight.w600,
//               //     buttonHeight: FetchPixels.getPixelHeight(60),
//               //     borderRadius:
//               //     BorderRadius.circular(FetchPixels.getPixelHeight(15))),
//               // getVerSpace(FetchPixels.getPixelHeight(30)),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               //   children: [
//               //     getCustomFont("Don’t have an account?", 14, Colors.black, 1,
//               //         fontWeight: FontWeight.w400, fontFamily: "Regular"),
//               //     GestureDetector(
//               //       onTap: () {
//               //         Constant.sendToNext(context, Routes.signupRoute);
//               //       },
//               //       child: getCustomFont(" Sign Up", 16, blueColor, 1,
//               //           fontWeight: FontWeight.w900, fontFamily: "Bold"),
//               //     )
//               //   ],
//               // ),
//               // getVerSpace(FetchPixels.getPixelHeight(50)),
//               // getDivider(dividerColor, FetchPixels.getPixelHeight(1), 1),
//               // getVerSpace(FetchPixels.getPixelHeight(50)),
//               // getButton(
//               //   context,
//               //   Colors.white,
//               //   "Login with Google",
//               //   Colors.black,
//               //       () {},
//               //   18,
//               //   weight: FontWeight.w600,
//               //   isIcon: true,
//               //   image: "google.svg",
//               //   buttonHeight: FetchPixels.getPixelHeight(60),
//               //   borderRadius:
//               //   BorderRadius.circular(FetchPixels.getPixelHeight(15)),
//               //   boxShadow: [
//               //     const BoxShadow(
//               //         color: Colors.black12,
//               //         blurRadius: 10,
//               //         offset: Offset(0.0, 4.0)),
//               //   ],
//               // ),
//               // getVerSpace(FetchPixels.getPixelHeight(20)),
//               // getButton(context, Colors.white, "Login with Facebook",
//               //     Colors.black, () {}, 18,
//               //     weight: FontWeight.w600,
//               //     isIcon: true,
//               //     image: "facebook.svg",
//               //     buttonHeight: FetchPixels.getPixelHeight(60),
//               //     borderRadius:
//               //     BorderRadius.circular(FetchPixels.getPixelHeight(15)),
//               //     boxShadow: [
//               //       const BoxShadow(
//               //           color: Colors.black12,
//               //           blurRadius: 10,
//               //           offset: Offset(0.0, 4.0)),
//               //     ]),
//             ],
//           ),
//         ),
//       ),
//     );
//     // return Container(
//     //   width: double.infinity,
//     //   height: double.infinity,
//     //   color: Colors.green,
//     // );
//   }
//
// }