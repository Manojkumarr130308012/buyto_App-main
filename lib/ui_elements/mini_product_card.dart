import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';
import '../custom/toast_component.dart';
import '../helpers/shared_value_helper.dart';
import '../repositories/wishlist_repository.dart';
import '../screens/wishlist.dart';

class MiniProductCard extends StatefulWidget {
  int? id;
  String? image;
  String? name;
  String? brand_name;
  String? category_name;
  String? main_price;
  String? stroked_price;
  bool? has_discount;
  bool? is_wholesale;
  var discount;
  String? margins;
  int? mrp;
  int? moq;
  String? unit_name;
  String? gender;
  String? color_code;

  MiniProductCard(
      {Key? key,
      this.id,
      this.image,
      this.name,
      this.brand_name,
      this.category_name,
      this.main_price,
      this.stroked_price,
      this.has_discount,
      this.is_wholesale = false,
      this.discount,
      this.margins,
      this.mrp,
      this.moq,
      this.gender,
      this.unit_name,
      this.color_code})
      : super(key: key);

  @override
  _MiniProductCardState createState() => _MiniProductCardState();
}

class _MiniProductCardState extends State<MiniProductCard> {
  bool _isInWishList = false;

  removeFromWishList() async {
    var wishListCheckResponse =
        await WishListRepository().remove(product_id: widget.id);
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  onWishTap() {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.you_need_to_log_in,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    addToWishList() async {
      var wishListCheckResponse =
          await WishListRepository().add(product_id: widget.id);
      _isInWishList = wishListCheckResponse.is_in_wishlist;
      setState(() {});
    }

    if (_isInWishList!) {
      _isInWishList = false;
      setState(() {});
      removeFromWishList();
    } else {
      _isInWishList = true;
      setState(() {});
      addToWishList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: widget.id,
          );
        }));
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width / 2.25,
        decoration: BoxDecorations.buildBoxDecoration_1(),
        child: Stack(children: [
          // SingleChildScrollView(
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6), bottom: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: widget.image!,
                          fit: BoxFit.cover,
                          width: MediaQuery.sizeOf(context).width / 2.25,
                          height: MediaQuery.sizeOf(context).height / 5.25,
                        ))),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: Text(
                    widget.name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSans'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    widget.gender!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSans'),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 4, 4, 0),
                        child: Text(
                          widget.category_name!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSans'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          "| MOQ: " + widget.moq.toString() + " ",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text(
                          widget.unit_name!.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text(
                        SystemConfig.systemCurrency!.code != null
                            ? widget.main_price!.replaceAll(
                                SystemConfig.systemCurrency!.code!,
                                SystemConfig.systemCurrency!.symbol! + " ")
                            : widget.main_price!,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Container(
                        width: 16,
                        height: 16,
                        child: Container(),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color_code != null
                              ? _parseColor(widget.color_code!)
                              : Colors.transparent,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Stack(
                    children: [
                      Container(
                        height: 30,
                        width: MediaQuery.sizeOf(context).width / 6,
                        decoration: BoxDecoration(
                          color: MyTheme.accent_color,
                          border: Border.all(color: Colors.white),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(0.0),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8, left: 8, right: 0, bottom: 8),
                            child: Text(
                              "MRP: ₹ " + widget.mrp!.toStringAsFixed(0),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontFamily: 'NotoSans',
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent.withOpacity(0.8),
                                border: Border.all(color: Colors.white),
                                // borderRadius: BorderRadius.circular(5.0),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(0.0),
                                  bottomLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8, left: 4, right: 4, bottom: 8),
                                child: Text(
                                  "Margin: " + widget.margins.toString() + "%"!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 9,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0)
                // ),
              ]),
          // ),
          Positioned(
            right: 5,
            top: 5,
            child: InkWell(
              onTap: () {
                onWishTap();
              },
              child: Container(
                decoration: BoxDecorations.buildCircularButtonDecoration_1(),
                width: 28,
                height: 28,
                child: Center(
                  child: Icon(
                    Icons.favorite,
                    color: _isInWishList
                        ? Color.fromRGBO(230, 46, 4, 1)
                        : MyTheme.dark_font_grey,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          // discount and wholesale
          // Positioned.fill(
          //   child: Align(
          //     alignment: Alignment.topRight,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         if (widget.has_discount!)
          //           Container(
          //             padding:
          //                 EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          //             margin: EdgeInsets.only(bottom: 5),
          //             decoration: BoxDecoration(
          //               color: const Color(0xffe62e04),
          //               borderRadius: BorderRadius.only(
          //                 topRight: Radius.circular(6.0),
          //                 bottomLeft: Radius.circular(6.0),
          //               ),
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: const Color(0x14000000),
          //                   offset: Offset(-1, 1),
          //                   blurRadius: 1,
          //                 ),
          //               ],
          //             ),
          //             child: Text(
          //               widget.discount ?? "",
          //               style: TextStyle(
          //                 fontSize: 10,
          //                 color: const Color(0xffffffff),
          //                 fontWeight: FontWeight.w700,
          //                 height: 1.8,
          //               ),
          //               textHeightBehavior:
          //                   TextHeightBehavior(applyHeightToFirstAscent: false),
          //               softWrap: false,
          //             ),
          //           ),
          //         // Visibility(
          //         //   visible: whole_sale_addon_installed.$,
          //         //   child: widget.is_wholesale!
          //         //       ? Container(
          //         //           padding: EdgeInsets.symmetric(
          //         //               horizontal: 12, vertical: 4),
          //         //           decoration: BoxDecoration(
          //         //             color: Colors.blueGrey,
          //         //             borderRadius: BorderRadius.only(
          //         //               topRight: Radius.circular(6.0),
          //         //               bottomLeft: Radius.circular(6.0),
          //         //             ),
          //         //             boxShadow: [
          //         //               BoxShadow(
          //         //                 color: const Color(0x14000000),
          //         //                 offset: Offset(-1, 1),
          //         //                 blurRadius: 1,
          //         //               ),
          //         //             ],
          //         //           ),
          //         //           child: Text(
          //         //             "Wholesale",
          //         //             style: TextStyle(
          //         //               fontSize: 10,
          //         //               color: const Color(0xffffffff),
          //         //               fontWeight: FontWeight.w700,
          //         //               height: 1.8,
          //         //             ),
          //         //             textHeightBehavior: TextHeightBehavior(
          //         //                 applyHeightToFirstAscent: false),
          //         //             softWrap: false,
          //         //           ),
          //         //         )
          //         //       : SizedBox.shrink(),
          //         // )
          //       ],
          //     ),
          //   ),
          // ),

          // whole sale
        ]),
      ),
    );
  }

  Color _parseColor(String colorString) {
    // Remove the '#' if it exists
    if (colorString.startsWith('#')) {
      colorString = colorString.substring(1);
    }

    // Add the '0xFF' prefix if it's a shorthand like 'FFFFFF'
    if (colorString.length == 6) {
      colorString = 'FF' + colorString;
    }

    // Parse the string to an integer
    int colorInt = int.parse(colorString, radix: 16);

    // Return the color
    return Color(colorInt);
  }
}
