import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../custom/box_decorations.dart';
import '../custom/btn.dart';
import '../custom/text_styles.dart';
import '../custom/toast_component.dart';
import '../custom/useful_elements.dart';
import '../data_model/edit_order_response.dart';
import '../data_model/quantity_response.dart';
import '../helpers/system_config.dart';
import '../repositories/wishlist_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProduct extends StatefulWidget {
  EditProduct(
      {super.key,
      required this.owner_id,
      required this.card_id,
      required this.productId,
      this.minimumValue});

  int owner_id;
  int card_id;
  int productId;
  int? minimumValue;

  List<double> value1 = [];
  List<double> value2 = [];
  List<double> value3 = [];

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ScrollController _mainScrollController = ScrollController();
  var _shopList = [];
  EditCartOrder? _shopResponse;
  bool _isInitial = true;
  bool _isApplied = false;
  double _totalAmountPrice = 0.0;
  double totalPriceValue = 0.0;
  double totalSumPriceValue = 0.0;
  double testvalue = 0.0;
  double productRate = 0.0;

  int? sum = 0;
  int? sumValue = 0;

  var _shopName = '';
  bool _isSelected = false;
  var _singlePrice;
  var quantityResponse;
  late QuantityResponse response;
  List<int?>? selectedValue = [];
  List<int?>? selectedValue2 = [];
  String? selectedValue1;
  List<int> selectId = [];
  List<int> selectId2 = [];
  List<int> selectId3 = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchQuantitySizes();
    fetchEditOrderData();
    super.initState();
  }

  fetchQuantitySizes() async {
    selectedValue?.clear();
    selectId.clear();
    quantityResponse =
        await WishListRepository().newQuantity(product_id: widget.productId);
    response = quantityResponse;
    response.data.forEach((e) {
      selectedValue?.add(e.qty[0]);
      selectId.add(e.qty[0]);
      selectId2.add(e.id);
    });
  }

  onPressCheckQuantity(
    product_id,
    quantity,
  ) async {
    var cartCheckResponse =
        await CartRepository().getQuantityCheckResponse(product_id, quantity);
    if (cartCheckResponse.result == true) {
      ToastComponent.showDialog(cartCheckResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(cartCheckResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);
    }
  }

  fetchEditOrderData() async {
    EditCartOrder cartResponseList = await CartRepository()
        .getEditOrderProductPage(widget.owner_id, widget.productId);

    if (cartResponseList != null || cartResponseList.data.length > 0) {
      _shopList = cartResponseList.data;
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

  var _cartTotalString = ". . .";

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

  onPressUpdateQuantity(id, variant, quantity) async {
    // print(id);
    // print(variant);
    // print(quantity);
    var cartDeleteResponse =
        await CartRepository().getQuantityUpdateResponse(id, variant, quantity);
    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      reset();
      fetchEditOrderData();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Cart(
                    has_bottomnav: true,
                  )));
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  onPressColorAdd() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ProductDetails(
            id: widget.productId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          // fetchQuantitySizes();
        },
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Container(
                    //   height: 100,
                    //   width: MediaQuery.sizeOf(context).width,
                    //   padding: EdgeInsets.all(10.0),
                    //   decoration: BoxDecorations.buildBoxDecoration_1(),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(_shopName,
                    //               style: TextStyle(
                    //                   color: MyTheme.dark_font_grey,
                    //                   fontWeight: FontWeight.w500,
                    //                   fontFamily: 'NotoSans',
                    //                   fontSize: 14)),
                    //         ],
                    //       ),
                    //       Text('Min. Order Value: Rs.${widget.minimumValue}/-',
                    //           style: TextStyle(
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.w500,
                    //               fontFamily: 'NotoSans',
                    //               fontSize: 13)),
                    //       Text(_cartTotalString,
                    //           style: TextStyle(
                    //               color: MyTheme.accent_color,
                    //               fontWeight: FontWeight.w600,
                    //               fontFamily: 'NotoSans',
                    //               fontSize: 14)),
                    //     ],
                    //   ),
                    // ),
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
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 15.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Min. Order Value: Rs.${widget.minimumValue}/-',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'NotoSans',
                                      fontSize: 12)),
                              Text(
                                _cartTotalString,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'NotoSans',
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(bottom: 2),
                      child: ListView.builder(
                          itemCount: _shopList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildCartSellerItemList(index),
                              ],
                            );
                          }),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 45,
                      width: MediaQuery.sizeOf(context).width - 30,
                      child: Btn.basic(
                        minWidth: MediaQuery.of(context).size.width,
                        color: MyTheme.accent_color.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.color_lens_outlined,
                              size: 18,
                              color: MyTheme.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "ADD NEW COLOR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'NotoSans'),
                            ),
                          ],
                        ),
                        onPressed: () {
                          onPressColorAdd();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]))
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        width: MediaQuery.sizeOf(context).width - 30,
        decoration: BoxDecorations.buildBoxDecoration_1(),
        child: Row(
          children: [
            Container(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL ORDER VALUE',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSans',
                          fontSize: 14)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      _isSelected
                          ? (testvalue * productRate).toStringAsFixed(2)
                          : _cartTotalString,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'NotoSans',
                          fontSize: 17))
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 45,
              width: 120,
              color: MyTheme.accent_color,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: MyTheme.accent_color),
                onPressed: () async {
                  onPressUpdateQuantity(
                      widget.productId, selectId2, selectedValue);
                },
                child: const Center(
                  child: Row(
                    children: [
                      Icon(
                        Icons.save,
                        size: 18,
                        color: MyTheme.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'SAVE',
                        style: TextStyle(
                            color: MyTheme.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'NotoSans',
                            fontSize: 14),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward, size: 18, color: MyTheme.white),
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
      leading: UsefulElements.backButton(context),
      title: Text(
        'Edit Product',
        style: TextStyles.buildAppBarTexStyle(),
      ),
      elevation: 0.0,
      titleSpacing: 0,
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

  _onPressSingleSizeDelete(ownerid, productid, variation) async {
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
                  },
                ),
                Btn.basic(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context)!.confirm_ucf,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    var cartSingleSizeDeleteResponse = await CartRepository()
                        .getCartSingleSizeDeleteResponse(
                            ownerid, productid, variation);
                    if (cartSingleSizeDeleteResponse.result == true) {
                      ToastComponent.showDialog(
                          cartSingleSizeDeleteResponse.message,
                          gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                      fetchEditOrderData();
                    } else {
                      ToastComponent.showDialog(
                          cartSingleSizeDeleteResponse.message,
                          gravity: Toast.bottom,
                          duration: Toast.lengthLong);
                    }
                  },
                ),
              ],
            ));
  }

  buildCartSellerItemCard(seller_index, item_index) {
    double _subtotalValue =
        ((_shopList[seller_index].cartItems[item_index].buytoPrice) *
            (_shopList[seller_index].cartItems[item_index].quantity));
    productRate = _shopList[0].cartItems[0].buytoPrice;
    return Container(
      margin: new EdgeInsets.symmetric(vertical: 2.5),
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: 110,
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
                SizedBox(width: 20),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('Select the Pairs',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSans',
                              fontSize: 13)),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            testvalue = 0.0;
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30.0),
                                        topLeft: Radius.circular(30.0),
                                      )),
                                      height: 500,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5),
                                          Container(
                                            height: 70,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 80,
                                                      width: 80,
                                                      child: FadeInImage.assetNetwork(
                                                          placeholder:
                                                              'assets/placeholder.png',
                                                          image:
                                                              '${_shopList[seller_index].cartItems[item_index].productThumbnailImage}')),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width /
                                                                  1.65,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Text(
                                                              '${_shopList[seller_index].cartItems[item_index].productName}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: MyTheme
                                                                      .accent_color,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          'Color : ${_shopList[seller_index].cartItems[item_index].colorName}',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.clear,
                                                      size: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 40,
                                            color: Colors.blue.withOpacity(.1),
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Availability Set Size',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'NotoSans',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  'Select Qty  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'NotoSans',
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            height: 120,
                                            child: ListView.builder(
                                                itemCount: response.data.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(response
                                                                .data[index]
                                                                .size),
                                                            Container(
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton2<
                                                                        int>(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: Text(
                                                                    "Select Pairs",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .hintColor,
                                                                    ),
                                                                  ),
                                                                  items: response
                                                                      .data[
                                                                          index]
                                                                      .qty
                                                                      .map((int
                                                                              item) =>
                                                                          DropdownMenuItem<
                                                                              int>(
                                                                            value:
                                                                                item,
                                                                            child:
                                                                                Text(
                                                                              item.toString(),
                                                                              style: const TextStyle(
                                                                                fontSize: 14,
                                                                              ),
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                                  // value:selectedValue?[index],
                                                                  value: selectedValue?[
                                                                              index] ==
                                                                          0
                                                                      ? response
                                                                          .data[
                                                                              index]
                                                                          .select_qty
                                                                      : selectedValue?[
                                                                          index],
                                                                  onChanged: (int?
                                                                      value) {
                                                                    if (value !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        selectedValue?[index] =
                                                                            value;
                                                                        selectId[index] = response
                                                                            .data[index]
                                                                            .id;
                                                                      });
                                                                    }
                                                                  },
                                                                  buttonStyleData:
                                                                      const ButtonStyleData(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    height: 40,
                                                                    width: 140,
                                                                  ),
                                                                  menuItemStyleData:
                                                                      const MenuItemStyleData(
                                                                    height: 40,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 10,
                                                      )
                                                    ],
                                                  );
                                                }),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedValue?[0] = 0;
                                                      selectId[0] = 0;
                                                    });
                                                    for (final (index, item)
                                                        in response
                                                            .data.indexed) {
                                                      setState(() {
                                                        selectedValue?[index] =
                                                            0;
                                                        selectId[index] = 0;
                                                      });
                                                    }
                                                    totalPriceValue = 0;
                                                    sum = 0;
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        3,
                                                    margin: EdgeInsets.only(
                                                        left: 18, right: 18),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      color: MyTheme
                                                          .accent_color_shadow,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: MyTheme
                                                              .accent_color_shadow,
                                                          blurRadius: 20,
                                                          spreadRadius: 0.0,
                                                          offset: Offset(0.0,
                                                              10.0), // shadow direction: bottom right
                                                        )
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Clear selection',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'NotoSans',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    selectedValue2 = [];
                                                    sum = selectedValue?.fold(
                                                        0,
                                                        (previousValue,
                                                                element) =>
                                                            previousValue! +
                                                            element!);
                                                    totalPriceValue =
                                                        (_shopList[seller_index]
                                                                .cartItems[
                                                                    item_index]
                                                                .buytoPrice) *
                                                            sum!;
                                                    for (var i = 0;
                                                        i <
                                                            _shopList[
                                                                    seller_index]
                                                                .cartItems
                                                                .length;
                                                        i++) {
                                                      sumValue =
                                                          selectedValue?[i] == 0
                                                              ? response.data[i]
                                                                  .select_qty
                                                              : selectedValue?[
                                                                  i];

                                                      testvalue = (testvalue +
                                                          sumValue!);
                                                    }
                                                    _isSelected = true;
                                                    fetchEditOrderData();

                                                    for (var h = 0;
                                                        h <
                                                            response
                                                                .data.length;
                                                        h++) {
                                                      selectedValue2?.add(
                                                          selectedValue?[h] == 0
                                                              ? response.data[h]
                                                                  .select_qty
                                                              : selectedValue?[
                                                                  h]);
                                                    }
                                                    onPressUpdateQuantity(
                                                        widget.productId,
                                                        selectId2,
                                                        selectedValue2);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 18, right: 18),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      color:
                                                          MyTheme.accent_color,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              MyTheme.grey_153,
                                                          blurRadius: 20,
                                                          spreadRadius: 0.0,
                                                          offset: Offset(0.0,
                                                              10.0), // shadow direction: bottom right
                                                        )
                                                      ],
                                                    ),
                                                    height: 50,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        3,
                                                    child: Center(
                                                      child: Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color: MyTheme.grey_153, width: .8),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: 40,
                            width: MediaQuery.sizeOf(context).width - 230,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                    child: _isSelected
                                        ? Text(
                                            (selectedValue?[item_index] == 0
                                                        ? response
                                                            .data[item_index]
                                                            .select_qty
                                                        : selectedValue?[
                                                            item_index])
                                                    .toString() +
                                                " Pairs",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))
                                        : Text(
                                            '${_shopList[seller_index].cartItems[item_index].quantity.toString() + " " + _shopList[seller_index].cartItems[item_index].unitName}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: MyTheme.accent_color,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                          children: [
                            Text("Size: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                            Text(
                                _shopList[seller_index]
                                    .cartItems[item_index]
                                    .variation,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    // '${(_shopList[seller_index].cartItems[item_index].buytoPrice)} x ${_isSelected?selectedValue![item_index]:(_shopList[seller_index].cartItems[item_index].quantity)} = ',
                                    'Rs. ${(_shopList[seller_index].cartItems[item_index].buytoPrice)} x ${selectedValue!?[item_index] == 0 ? response.data[item_index].select_qty : selectedValue!?[item_index]} = ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSans',
                                    fontSize: 14)),
                            TextSpan(
                                // text: '₹ ${_subtotalValue.toStringAsFixed(2)}',
                                text:
                                    'Rs. ${((_shopList[seller_index].cartItems[item_index].buytoPrice) * (selectedValue!?[item_index] == 0 ? response.data[item_index].select_qty : selectedValue!?[item_index])).toStringAsFixed(2)} ',
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'NotoSans',
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Color : " +
                        _shopList[seller_index].cartItems[item_index].colorName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Btn.basic(
                      minWidth: 60,
                      onPressed: () {
                        _onPressSingleSizeDelete(
                            _shopList[seller_index]
                                .cartItems[item_index]
                                .ownerId,
                            _shopList[seller_index]
                                .cartItems[item_index]
                                .productId,
                            _shopList[seller_index]
                                .cartItems[item_index]
                                .variation);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: MyTheme.light_grey)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            // Text(
                            //   "",
                            //   style: TextStyle(
                            //       color: MyTheme.grey_153, fontSize: 14),
                            // ),
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
