import 'dart:io';
import 'dart:typed_data';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../custom/lang_text.dart';
import '../custom/useful_elements.dart';
import 'main.dart';

class OrderConfirmation extends StatefulWidget {
  OrderConfirmation(
      {super.key,
      required this.id,
      required this.name,
      required this.totalAmount});

  String name;
  String id;
  double? totalAmount;

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  List<String> ids = [];
  List<String> name = [];

  addfunction() {
    ids.add(widget.id);
    name.add(widget.name);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    addfunction();
    // Future.delayed(Duration(seconds: 3), () {
    //   setState(() {
    //
    //   });
    // });
    super.initState();
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // centerTitle: true,
      leading: UsefulElements.backButton(context),
      title: Text(
        'Order Confirmation',
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Container(
                child: Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: 150,
                    width: 160,
                    child: Lottie.asset('assets/success.json'),
                  ),
                  Padding(padding: EdgeInsets.only(top: 0.0)),
                  Text(
                    "Your Order was Placed",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.only(top: 180),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7.0),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: MyTheme.accent_color_shadow),
                    //   borderRadius: BorderRadius.circular(6),
                    //   color: MyTheme.white
                    // ),
                    child: Row(
                      children: [
                        Text(
                          'Order Value :',
                          style: TextStyle(
                              fontSize: 20,
                              color: MyTheme.accent_color,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold),
                        ),
                        // Icon(
                        //   Icons.currency_rupee,
                        //   color: MyTheme.accent_color,
                        //   size: 20,
                        // ),
                        Text(
                          'Rs.${widget.totalAmount?.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20,
                              color: MyTheme.accent_color,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * .31, left: 10),
                child: Text(
                  'Sellers Details',
                  style: TextStyle(
                      fontSize: 14,
                      color: MyTheme.accent_color,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.w600),
                )),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Container(
                  margin: EdgeInsets.only(top: 40, left: 10, right: 15),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.sizeOf(context).height / 2.65,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MyTheme.gigas.withOpacity(0.05),
                  ),
                  child: ListView.builder(
                      itemCount: ids.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Text(
                                '${name[index]}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSans'),
                              ),
                              Spacer(),
                              Text(
                                '${ids[index]}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSans'),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                width: MediaQuery.sizeOf(context).width,
                color: MyTheme.amber_medium,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Main();
                        }));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: MyTheme.accent_color,
                              borderRadius: BorderRadius.circular(25)),
                          height: 45,
                          width: MediaQuery.sizeOf(context).width / 3.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                size: 14,
                                color: Colors.white,
                              ),
                              // SizedBox(width: 5),
                              Text(
                                'HOME',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () async {
                        Future<Uint8List> generatePdf() async {
                          final pdf = pw.Document();
                          pdf.addPage(pw.Page(
                            pageFormat: PdfPageFormat.a4,
                            build: (context) {
                              return pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text('BUYTO ORDER DETAILS',
                                      style: pw.TextStyle(
                                        fontSize: 17,
                                        fontWeight: pw.FontWeight.bold,
                                      )),
                                  pw.SizedBox(height: 20),
                                  _buildDataRow('Seller Name', widget.name),
                                  pw.SizedBox(height: 10),
                                  _buildDataRow(
                                      'Order Id', widget.id.toString()),
                                ],
                              );
                            },
                          ));
                          return pdf.save();
                        }

                        final Uint8List pdfBytes = await generatePdf();

                        final tempDir = await getTemporaryDirectory();
                        final pdfFile =
                            File('${tempDir.path}/Order_Detail.pdf');
                        await pdfFile.writeAsBytes(pdfBytes);
                        // Share.shareXFiles([pdfFile.path], text: 'Order Details');
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 45,
                          width: MediaQuery.sizeOf(context).width / 3.5,
                          decoration: BoxDecoration(
                              color: MyTheme.accent_color,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share,
                                size: 14,
                                color: Colors.white,
                              ),
                              // SizedBox(width: 10),
                              Text(
                                ' SHARE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderList()));
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          height: 45,
                          // width: MediaQuery.sizeOf(context).width / 3.5,
                          decoration: BoxDecoration(
                              color: MyTheme.accent_color,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'MY ORDER ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.w600),
                              ),
                              // SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  pw.Widget _buildDataRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(label,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Spacer(),
        pw.Text(value, style: pw.TextStyle(fontSize: 15)),
      ],
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
