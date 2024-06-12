import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../custom/toast_component.dart';
import '../helpers/shared_value_helper.dart';
import '../repositories/wishlist_repository.dart';
import '../screens/auction_products_details.dart';

class WishlistCard extends StatefulWidget {
  var identifier;
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
  String? margin;
  int? mrp;
  int? moq;
  String? unit_name;
  String? gender;

  WishlistCard({
    Key? key,
    this.identifier,
    this.id,
    this.image,
    this.name,
    this.brand_name,
    this.category_name,
    this.main_price,
    this.is_wholesale = false,
    this.stroked_price,
    this.has_discount,
    this.discount,
    this.margin,
    this.mrp,
    this.moq,
    this.unit_name,
    this.gender,
  }) : super(key: key);

  @override
  _WishlistCardState createState() => _WishlistCardState();
}

class _WishlistCardState extends State<WishlistCard> {
  bool _isInWishList = true;
  int _inWishList = 0;
  List<dynamic> _wishlistItems = [];

  removeFromWishList() async {
    var wishListCheckResponse =
        await WishListRepository().remove(product_id: widget.id);
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  addToWishList() async {
    var wishListCheckResponse =
        await WishListRepository().add(product_id: widget.id);
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    _inWishList = wishListCheckResponse.product_id;
    setState(() {});
  }

  onWishTap() async {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.you_need_to_log_in,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    // var wishListCheckResponse =
    //     await WishListRepository().add(product_id: widget.id);
    // _isInWishList = wishListCheckResponse.is_in_wishlist;
    print("_isInWishList ${_isInWishList}");
    if (_isInWishList) {
      // _isInWishList = false;
      removeFromWishList();
      setState(() {});
    } else {
      // _isInWishList = true;
      addToWishList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //print((MediaQuery.of(context).size.width - 48 ) / 2);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return widget.identifier == 'auction'
                  ? AuctionProductsDetails(id: widget.id)
                  : ProductDetails(
                      id: widget.id,
                    );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1().copyWith(),
        child: Stack(
          children: [
            Column(children: <Widget>[
              AspectRatio(
                aspectRatio: 1.15,
                child: Container(
                  width: double.infinity,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(6), bottom: Radius.zero),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: widget.image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                // width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 16, 0),
                      child: Text(
                        widget.name!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 16, 0),
                      child: Text(
                        widget.gender.toString()!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontSize: 12,
                            height: 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 4, 0),
                              child: Text(
                                widget.category_name.toString()!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 12,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                              child: Text(
                                "| MOQ: " + widget.moq.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: MyTheme.font_grey,
                                    fontSize: 10,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                              child: Text(
                                widget.unit_name.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: MyTheme.font_grey,
                                    fontSize: 12,
                                    height: 1.2,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // widget.has_discount!
                    //     ? Padding(
                    //         padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                    //         child: Text(
                    //           SystemConfig.systemCurrency!.code != null
                    //               ? widget.stroked_price!.replaceAll(
                    //                   SystemConfig.systemCurrency!.code!,
                    //                   SystemConfig.systemCurrency!.symbol!)
                    //               : widget.stroked_price!,
                    //           textAlign: TextAlign.left,
                    //           overflow: TextOverflow.ellipsis,
                    //           maxLines: 1,
                    //           style: TextStyle(
                    //               decoration: TextDecoration.lineThrough,
                    //               color: MyTheme.medium_grey,
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w400),
                    //         ),
                    //       )
                    //     : Container(
                    //         height: 8.0,
                    //       ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 16, 0),
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
                            fontWeight: FontWeight.w700),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 8, 8, 8),
                            child: Text(
                              // "MRP: " + widget.mrp!.toString(),
                              "MRP: " + widget.mrp!.toStringAsFixed(0)!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: MyTheme.font_grey,
                                  fontSize: 10,
                                  height: 1.2,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: MyTheme.soft_accent_color,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Text(
                                  widget.margin.toString() + "% Margin"!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 8,
                                      height: 1.2,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Positioned(
              right: 5,
              top: 2,
              child: InkWell(
                onTap: () {
                  onWishTap();
                },
                child: Container(
                  // decoration: BoxDecorations.buildCircularButtonDecoration_1(),
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: !_isInWishList
                          ? MyTheme.dark_font_grey
                          : Color.fromRGBO(230, 46, 4, 1),
                      size: 16,
                    ),
                  ),
                ),
                // child: Container(
                //   height: 25,
                //   width: 25,
                //   child: LikeButton(
                //     onTap: (isLike) {
                //       setState(() {
                //         onWishTap();
                //       });
                //       return Future.value(_isInWishList);
                //     },
                //     size: 20,
                //     isLiked: _isInWishList,
                //   ),
                // ),
              ),
            ),

            // discount and wholesale
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.has_discount!)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xffe62e04),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x14000000),
                              offset: Offset(-1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.discount ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                            height: 1.8,
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    Visibility(
                      visible: whole_sale_addon_installed.$,
                      child: widget.is_wholesale != null && widget.is_wholesale!
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x14000000),
                                    offset: Offset(-1, 1),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                "Wholesale",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                  height: 1.8,
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                softWrap: false,
                              ),
                            )
                          : SizedBox.shrink(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
