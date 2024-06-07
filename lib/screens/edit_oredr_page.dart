import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:toast/toast.dart';
import '../custom/box_decorations.dart';
import '../custom/btn.dart';
import '../custom/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../custom/toast_component.dart';
import '../custom/useful_elements.dart';
import '../data_model/edit_order_response.dart';
import '../helpers/system_config.dart';
import 'cart.dart';
import 'edit_product.dart';

class EditOrder extends StatefulWidget {
  EditOrder(
      {super.key, required this.owner_id, this.minimumvalue, this.shopId});

  int owner_id;
  int? minimumvalue;
  int? shopId;

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  ScrollController _mainScrollController = ScrollController();
  var _shopList = [];
  EditCartOrder? _shopResponse;
  bool _isInitial = true;
  double _totalAmountPrice = 0.0;

  var _shopName = '';

  fetchEditOrderData() async {
    EditCartOrder cartResponseList =
        await CartRepository().getEditOrderCartPage(user_id.$, widget.owner_id);

    if (cartResponseList != null || cartResponseList.data!.length > 0) {
      _shopList = cartResponseList.data!;
      // print(_shopList);
      _shopResponse = cartResponseList;
      getSetCartTotal();
    }
    _shopList.forEach((shop) {
      _totalAmountPrice += double.tryParse(shop.subTotal.replaceAll(
            SystemConfig.systemCurrency!.code,
            '',
          )) ??
          0.0;
      _shopName = shop.name;
    });

    _isInitial = false;
    setState(() {});
  }

  var _cartTotalString = "0.0";

  getSetCartTotal() {
    _cartTotalString = _shopResponse!.grandTotal!.replaceAll(
        SystemConfig.systemCurrency!.code!,
        SystemConfig.systemCurrency!.symbol!);

    setState(() {});
  }

  reset() {
    _shopList = [];
    _isInitial = true;
    _cartTotalString = ". . .";
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchEditOrderData();
    reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchEditOrderData();
        },
        // child: Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: CustomScrollView(
        //     controller: _mainScrollController,
        //     physics: const BouncingScrollPhysics(
        //         parent: AlwaysScrollableScrollPhysics()),
        //     slivers: [
        //       SliverList(
        //           delegate: SliverChildListDelegate([
        //
        //         SizedBox(
        //           height: 50,
        //         )
        //       ]))
        //     ],
        //   ),
        // ),
        child: CustomScrollView(
          controller: _mainScrollController,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: MediaQuery.sizeOf(context).width,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecorations.buildBoxDecoration_1(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _shopName,
                                  style: TextStyle(
                                      color: MyTheme.dark_font_grey,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'NotoSans',
                                      fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SellerDetails(id: widget.shopId);
                                    }));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyTheme.accent_color),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.shopping_cart,
                                              size: 18,
                                              color: MyTheme.accent_color,
                                            ),
                                            Text(' Add Products',
                                                style: TextStyle(
                                                    color: MyTheme.accent_color,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'NotoSans',
                                                    fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 15.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _cartTotalString,
                                  style: TextStyle(
                                      color: MyTheme.accent_color,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'NotoSans',
                                      letterSpacing: 1,
                                      fontSize: 15),
                                ),
                                Text(
                                    'Min. Order Value: Rs.${widget.minimumvalue}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'NotoSans',
                                        fontSize: 12)),
                              ],
                            ),
                            // Text(
                            //   _cartTotalString,
                            //   style: TextStyle(
                            //       color: MyTheme.accent_color,
                            //       fontWeight: FontWeight.w700,
                            //       fontFamily: 'NotoSans',
                            //       letterSpacing: 1,
                            //       fontSize: 15),
                            // ),
                            // Padding(padding: EdgeInsets.only(top: 10.0)),
                            // Text('Min. Order Value: Rs.${widget.minimumvalue}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: MediaQuery.sizeOf(context).height / 1.4,
                        padding: EdgeInsets.only(
                            top: 10, left: 5, right: 5, bottom: 5),
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.08),
                              blurRadius: 10,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  0.0, 10.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  children: [
                                    Text(
                                      // _shopName,
                                      "ORDER VALUE",
                                      style: TextStyle(
                                          color: MyTheme.dark_font_grey,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'NotoSans',
                                          fontSize: 14),
                                    ),
                                    Spacer(),
                                    Text(
                                      _cartTotalString,
                                      style: TextStyle(
                                          color: MyTheme.accent_color,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'NotoSans',
                                          fontSize: 15),
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: ListView.builder(
                                    itemCount: _shopList.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildCartSellerItemList(index),
                                          SizedBox(height: 5),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            height: 40,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => EditProduct(
                                                                card_id: _shopList[
                                                                        index]
                                                                    .cartItems[
                                                                        0]
                                                                    .id,
                                                                owner_id:
                                                                    _shopList[
                                                                            index]
                                                                        .ownerId,
                                                                productId: _shopList[
                                                                        index]
                                                                    .cartItems[
                                                                        index]
                                                                    .productId,
                                                                minimumValue: widget
                                                                    .minimumvalue)));
                                                    // print(
                                                    //     '${_shopList[seller_index].cartItems[item_index].productId}');
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        1.35,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(.08),
                                                          blurRadius: 20,
                                                          spreadRadius: 0.0,
                                                          offset: Offset(0.0,
                                                              5.0), // shadow direction: bottom right
                                                        )
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('EDIT ORDER',
                                                            style: TextStyle(
                                                                color: MyTheme
                                                                    .accent_color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'NotoSans',
                                                                fontSize: 14)),
                                                        SizedBox(width: 10),
                                                        Icon(
                                                          Icons.pin_end,
                                                          size: 25,
                                                          color: MyTheme
                                                              .accent_color,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    onPressDelete(
                                                        user_id.$,
                                                        _shopList[0].ownerId,
                                                        _shopList[0]
                                                            .cartItems[0]
                                                            .productId);
                                                    // print(
                                                    //     '${user_id.$}, ${_shopList[seller_index].ownerId} ,${_shopList[seller_index].cartItems[item_index].id}');
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        9,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(.08),
                                                          blurRadius: 20,
                                                          spreadRadius: 0.0,
                                                          offset: Offset(0.0,
                                                              5.0), // shadow direction: bottom right
                                                        )
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          size: 18,
                                                          color:
                                                              MyTheme.brick_red,
                                                        ),
                                                        // Text('Remove Product ',
                                                        //     style: TextStyle(
                                                        //         color: MyTheme.brick_red,
                                                        //         fontWeight: FontWeight.w600,
                                                        //         fontFamily: 'NotoSans',
                                                        //         fontSize: 14)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 0,
        ),
        itemCount: _shopList[seller_index].cartItems.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildCartSellerItemCard(seller_index, index);
        },
      ),
    );
  }

  buildCartSellerItemCard(seller_index, item_index) {
    double _subtotalValue =
        ((_shopList[seller_index].cartItems[item_index].buytoPrice) *
            (_shopList[seller_index].cartItems[item_index].quantity));
    return Container(
      margin: new EdgeInsets.symmetric(vertical: 2.5),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 5, right: 0),
                child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: MyTheme.medium_grey.withOpacity(.6)),
                        borderRadius: BorderRadius.circular(5)),
                    height: 105,
                    child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(6),
                            right: Radius.circular(6)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: _shopList[seller_index]
                              .cartItems[item_index]
                              .productThumbnailImage,
                          fit: BoxFit.cover,
                        ))),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width / 1.75,
                padding: EdgeInsets.only(top: 15, left: 10, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 2,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Product Name: ',
                              style: TextStyle(
                                  color: MyTheme.dark_font_grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                          TextSpan(
                              text: _shopList[seller_index]
                                  .cartItems[item_index]
                                  .productName,
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Color Name: ',
                              style: TextStyle(
                                  color: MyTheme.dark_font_grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                          TextSpan(
                              text: _shopList[seller_index]
                                  .cartItems[item_index]
                                  .colorName,
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 180,
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Product Size: ',
                                style: TextStyle(
                                    color: MyTheme.dark_font_grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSans',
                                    fontSize: 12)),
                            TextSpan(
                                text: _shopList[seller_index]
                                    .cartItems[item_index]
                                    .variation,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSans',
                                    fontSize: 12)),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Quantity: ',
                              style: TextStyle(
                                  color: MyTheme.dark_font_grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                          TextSpan(
                              text: _shopList[seller_index]
                                      .cartItems[item_index]
                                      .quantity
                                      .toString() +
                                  " " +
                                  _shopList[seller_index]
                                      .cartItems[item_index]
                                      .unitName
                                      .toString(),
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${(_shopList[seller_index].cartItems[item_index].buytoPrice)} x ${(_shopList[seller_index].cartItems[item_index].quantity)} = ',
                              style: TextStyle(
                                  color: MyTheme.dark_font_grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                          TextSpan(
                              text: '${_subtotalValue.toStringAsFixed(2)} ',
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NotoSans',
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Container(
                    //   height: 40,
                    //   width: MediaQuery.sizeOf(context).width,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => EditProduct(
                    //                       card_id: _shopList[seller_index].cartItems[seller_index].id,
                    //                       owner_id: _shopList[seller_index].ownerId,
                    //                       productId: _shopList[seller_index]
                    //                           .cartItems[seller_index]
                    //                           .productId,
                    //                       minimumValue: widget.minimumvalue)));
                    //           // print(
                    //           //     '${_shopList[seller_index].cartItems[item_index].productId}');
                    //         },
                    //         child: Container(
                    //           height: 45,
                    //           width: MediaQuery.sizeOf(context).width / 2,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.all(Radius.circular(5)),
                    //             color: Colors.white,
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: Colors.black.withOpacity(.08),
                    //                 blurRadius: 20,
                    //                 spreadRadius: 0.0,
                    //                 offset: Offset(
                    //                     0.0, 5.0), // shadow direction: bottom right
                    //               )
                    //             ],
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Icon(
                    //                 Icons.edit,
                    //                 size: 18,
                    //                 color: MyTheme.accent_color,
                    //               ),
                    //               SizedBox(width: 10),
                    //               Text('Edit Product',
                    //                   style: TextStyle(
                    //                       color: MyTheme.accent_color,
                    //                       fontWeight: FontWeight.w600,
                    //                       fontFamily: 'NotoSans',
                    //                       fontSize: 14)),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       InkWell(
                    //         onTap: () {
                    //           onPressDelete(
                    //               user_id.$,
                    //               _shopList[seller_index].ownerId,
                    //               _shopList[seller_index]
                    //                   .cartItems[item_index]
                    //                   .productId);
                    //           // print(
                    //           //     '${user_id.$}, ${_shopList[seller_index].ownerId} ,${_shopList[seller_index].cartItems[item_index].id}');
                    //         },
                    //         child: Container(
                    //           height: 45,
                    //           width: MediaQuery.sizeOf(context).width / 9,
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.all(Radius.circular(5)),
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 color: Colors.black.withOpacity(.08),
                    //                 blurRadius: 20,
                    //                 spreadRadius: 0.0,
                    //                 offset: Offset(
                    //                     0.0, 5.0), // shadow direction: bottom right
                    //               )
                    //             ],
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Icon(
                    //                 Icons.delete,
                    //                 size: 18,
                    //                 color: MyTheme.brick_red,
                    //               ),
                    //               // Text('Remove Product ',
                    //               //     style: TextStyle(
                    //               //         color: MyTheme.brick_red,
                    //               //         fontWeight: FontWeight.w600,
                    //               //         fontFamily: 'NotoSans',
                    //               //         fontSize: 14)),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onPressDelete(user_id, owner_id, product_id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context)!
                      .are_you_sure_to_remove_this_item,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                Btn.basic(
                  child: Text(
                    AppLocalizations.of(context)!.cancel_ucf,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cart(
                                  has_bottomnav: true,
                                )));
                  },
                ),
                Btn.basic(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context)!.confirm_ucf,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(user_id, owner_id, product_id);
                    // print('$user_id $owner_id ${product_id}');
                  },
                ),
              ],
            ));
  }

  confirmDelete(user_id, owner_id, product_id) async {
    var cartDeleteResponse = await CartRepository()
        .getEditOrderSellerDeleteResponse(user_id, owner_id, product_id);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      reset();
      fetchEditOrderData();
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  // AppBar buildAppBar(BuildContext context) {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     title: Text(
  //       'Edit Order',
  //       style: TextStyles.buildAppBarTexStyle(),
  //     ),
  //     elevation: 0.0,
  //     titleSpacing: 0,
  //   );
  // }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
      leading: UsefulElements.backButton(context),
      title: Text(
        'Edit Order',
        style: TextStyles.buildAppBarTexStyle(),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
