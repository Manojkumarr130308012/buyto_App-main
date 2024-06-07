import 'dart:async';
import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/quantity_input.dart';
import 'package:active_ecommerce_flutter/custom/text_styles.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_location_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_details_response.dart';
import 'package:active_ecommerce_flutter/helpers/color_helper.dart';
import 'package:active_ecommerce_flutter/helpers/main_helpers.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/wishlist_repository.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/chat.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/product_reviews.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:active_ecommerce_flutter/screens/video_description_screen.dart';
import 'package:active_ecommerce_flutter/ui_elements/list_product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/mini_product_card.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../data_model/quantity_response.dart';
import '../repositories/api-request.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';

class ProductDetails extends StatefulWidget {
  int? id;

  ProductDetails({Key? key, this.id}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  bool _showCopied = false;
  String? _appbarPriceString = ". . .";
  int _currentImage = 0;
  ScrollController _mainScrollController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController _colorScrollController = ScrollController();
  ScrollController _variantScrollController = ScrollController();
  ScrollController _imageScrollController = ScrollController();
  TextEditingController sellerChatTitleController = TextEditingController();
  TextEditingController sellerChatMessageController = TextEditingController();

  double _scrollPosition = 0.0;

  Animation? _colorTween;
  late AnimationController _ColorAnimationController;
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..enableZoom(false);
  double webViewHeight = 0.0;

  CarouselController _carouselController = CarouselController();
  late BuildContext loadingcontext;

  //init values

  bool _isInWishList = false;
  var _productDetailsFetched = false;
  DetailedProduct? _productDetails;
  var _productImageList = [];
  var _colorList = [];
  int _selectedColorIndex = 0;
  var _selectedChoices = [];
  var _choiceString = "";
  String? _variant = "";
  String? _totalPrice = "...";
  var _singlePrice;
  var _singlePriceString;
  double? _singlePriceCalculation;

  int? _quantity = 1;
  int? _stock = 0;
  int? price = 0;
  int? sum = 0;
  var _stock_txt;
  List<ProductDetailsResponse> _colorRelatedProducts = [];
  List<dynamic>? colorsProduct;
  List<dynamic>? _colorsProduct;
  double opacity = 0;
  List<dynamic> _relatedProducts = [];
  bool _relatedProductInit = false;
  List<dynamic> _topProducts = [];
  bool _topProductInit = false;

  // List<String> _quantitySize = [];
  String _quantityQty = '';
  bool _isSelected = false;
  bool _isApplied = false;
  String? selectedValue1;
  double totalPriceValue = 0.0;
  double? _totalValue = 0;

  late Function(GlobalKey) runAddToCartAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    quantityText.text = "${_quantity ?? 0}";
    controller;
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_ColorAnimationController);

    _mainScrollController.addListener(() {
      _scrollPosition = _mainScrollController.position.pixels;

      if (_mainScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (100 > _scrollPosition && _scrollPosition > 1) {
          opacity = _scrollPosition / 100;
        }
      }

      if (_mainScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (100 > _scrollPosition && _scrollPosition > 1) {
          opacity = _scrollPosition / 100;

          if (100 > _scrollPosition) {
            opacity = 1;
          }
        }
      }
      //print("opachity{} $_scrollPosition");

      setState(() {});
    });
    fetchRelatedColorProducts();
    fetchAll();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _mainScrollController.dispose();
  //   _variantScrollController.dispose();
  //   _imageScrollController.dispose();
  //   _colorScrollController.dispose();
  //   _ColorAnimationController.dispose();
  //   super.dispose();
  // }

  fetchAll() {
    fetchRelatedColorProducts();
    fetchProductDetails();
    fetchProductColorImage();
    // fetchProductColorDetails();
    if (is_logged_in.$ == true) {
      fetchWishListCheckInfo();
    }
    fetchRelatedProducts();
    fetchTopProducts();
    fetchQuantitySizes();
  }

  // fetchVariantPrice() async {
  //   var response = await ProductRepository()
  //       .getVariantPrice(id: widget.id, quantity: _quantity);
  //
  //   print(response);
  //   _totalPrice = response.data.price;
  //   setState(() {});
  // }
  var quantityResponse;
  late QuantityResponse response;
  List<int?>? selectedValue = [];
  List<int?>? selectedValue2 = [];
  List<int?>? selectedQty = [];
  List<int> selectId = [];
  List<int> selectId2 = [];

  fetchQuantitySizes() async {
    selectedValue?.clear();
    selectId.clear();
    quantityResponse =
        await WishListRepository().newQuantity(product_id: widget.id);
    response = quantityResponse;
    response.data.forEach((e) {
      selectedValue?.add(e.qty[0]);
      selectId.add(e.qty[0]);
    });
  }

  void clearSelectedValues() {
    setState(() {
      selectedValue?.clear();
    });
  }

  fetchRelatedColorProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/related-colors/" +
        widget.id.toString());
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    List<dynamic> product = responseData['data'];
    _colorsProduct = product;
    // print(product);
    // print(_colorsProduct);
  }

  fetchProductDetails() async {
    var productDetailsResponse =
        await ProductRepository().getProductDetails(id: widget.id);

    if (productDetailsResponse.detailed_products!.length > 0) {
      _productDetails = productDetailsResponse.detailed_products![0];
      sellerChatTitleController.text =
          productDetailsResponse.detailed_products![0].name!;
    }

    setProductDetailValues();

    setState(() {});
  }

  fetchProductColorDetails() async {
    var productDetailsResponse =
        await ProductRepository().getColorDetails(id: 38);
    setProductDetailValues();
    setState(() {});
  }

  fetchRelatedProducts() async {
    var relatedProductResponse =
        await ProductRepository().getRelatedProducts(id: widget.id);
    _relatedProducts.addAll(relatedProductResponse.products!);
    _relatedProductInit = true;

    setState(() {});
  }

  fetchTopProducts() async {
    var topProductResponse =
        await ProductRepository().getTopFromThisSellerProducts(id: widget.id);
    _topProducts.addAll(topProductResponse.products!);
    _topProductInit = true;
  }

  setProductDetailValues() {
    if (_productDetails != null) {
      print(widget.id);
      controller.loadHtmlString(makeHtml(_productDetails!.description!));
      _appbarPriceString = _productDetails!.price_high_low;
      _singlePrice = _productDetails!.mrp;
      _singlePriceString = _productDetails!.main_price;
      _singlePriceCalculation = _productDetails!.calculable_price?.toDouble();
      print("_singlePriceCalculation${_singlePriceCalculation}");
      // fetchVariantPrice();
      _stock = _productDetails!.current_stock;
      _productDetails!.photos!.forEach((photo) {
        _productImageList.add(photo.path);
      });

      _productDetails!.choice_options!.forEach((choice_opiton) {
        _selectedChoices.add(choice_opiton.options![0]);
      });
      _productDetails!.colors!.forEach((color) {
        _colorList.add(color);
      });

      setChoiceString();

      // if (_productDetails!.colors.length > 0 ||
      //     _productDetails!.choice_options.length > 0) {
      //   fetchAndSetVariantWiseInfo(change_appbar_string: true);
      // }
      // fetchAndSetVariantWiseInfo(change_appbar_string: true);
      _productDetailsFetched = true;

      setState(() {});
    }
  }

  setChoiceString() {
    _choiceString = _selectedChoices.join(",").toString();
    // print(_choiceString);
    setState(() {});
  }

  fetchWishListCheckInfo() async {
    var wishListCheckResponse =
        await WishListRepository().isProductInUserWishList(
      product_id: widget.id,
    );

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  addToWishList() async {
    var wishListCheckResponse =
        await WishListRepository().add(product_id: widget.id);

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  removeFromWishList() async {
    var wishListCheckResponse =
        await WishListRepository().remove(product_id: widget.id);

    //print("p&u:" + widget.id.toString() + " | " + _user_id.toString());
    _isInWishList = wishListCheckResponse.is_in_wishlist;
    setState(() {});
  }

  onWishTap() {
    if (is_logged_in.$ == false) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.you_need_to_log_in,
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
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

  setQuantity(quantity) {
    quantityText.text = "${quantity ?? 0}";
  }

  fetchAndSetVariantWiseInfo({bool change_appbar_string = true}) async {
    var color_string = _colorList.length > 0
        ? _colorList[_selectedColorIndex].toString().replaceAll("", "")
        : "";

    /*print("color string: "+color_string);
    return;*/

    var variantResponse = await ProductRepository().getVariantWiseInfo(
        id: widget.id,
        color: color_string,
        variants: _choiceString,
        qty: _quantity);
    // print("single price ${variantResponse.variantData!.price}");
    /*print("vr"+variantResponse.toJson().toString());
    return;*/

    // _singlePrice = variantResponse.price;
    _stock = variantResponse.variantData!.stock;
    _stock_txt = variantResponse.variantData!.stockTxt;
    if (_quantity! > _stock!) {
      _quantity = _stock;
    }

    _variant = variantResponse.variantData!.variant;

    //fetchVariantPrice();
    // _singlePriceString = variantResponse.price_string;
    _totalPrice = variantResponse.variantData!.price;

    // if (change_appbar_string) {
    //   _appbarPriceString = "${variantResponse.variant} ${_singlePriceString}";
    // }

    int pindex = 0;
    _productDetails!.photos?.forEach((photo) {
      //print('con:'+ (photo.variant == _variant && variantResponse.image != "").toString());
      if (photo.variant == _variant &&
          variantResponse.variantData!.image != "") {
        _currentImage = pindex;
        _carouselController.jumpToPage(pindex);
      }
      pindex++;
    });
    setQuantity(_quantity);
    setState(() {});
  }

  reset() {
    restProductDetailValues();
    _currentImage = 0;
    _productImageList.clear();
    _colorList.clear();
    _selectedChoices.clear();
    _relatedProducts.clear();
    _topProducts.clear();
    _choiceString = "";
    _variant = "";
    _selectedColorIndex = 0;
    _quantity = 1;
    _productDetailsFetched = false;
    _isInWishList = false;
    sellerChatTitleController.clear();
    setState(() {});
  }

  restProductDetailValues() {
    _appbarPriceString = " . . .";
    _productDetails = null;
    _productImageList.clear();
    _currentImage = 0;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  // calculateTotalPrice() {
  //   print("sing $_singlePrice");
  //
  //   _totalPrice = (_singlePrice * _quantity).toStringAsFixed(2);
  //   setState(() {});
  // }

  _onVariantChange(_choice_options_index, value) {
    _selectedChoices[_choice_options_index] = value;
    setChoiceString();
    setState(() {});
    // fetchAndSetVariantWiseInfo();
  }

  _onColorChange(index) {
    _selectedColorIndex = index;
    setState(() {});
    // fetchAndSetVariantWiseInfo();
  }

  ColorModel? colorModel;

  fetchProductColorImage() async {
    String url = ("${AppConfig.BASE_URL}/products/colors/${widget.id}");
    final response = await ApiRequest.get(url: url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$!
    });
    Map<String, dynamic> mapFromString = jsonDecode(response.body);

    colorModel = ColorModel.fromJson(mapFromString);
  }

  onPressAddToCart(context, snackbar) {
    addToCart(mode: "add_to_cart", context: context, snackbar: snackbar);
  }

  onPressBuyNow(context) {
    addToCart(mode: "buy_now", context: context);
  }

  addToCart({mode, context = null, snackbar = null}) async {
    if (is_logged_in.$ == false) {
      // ToastComponent.showDialog(AppLocalizations.of(context).common_login_warning, context,
      //     gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    var cartAddResponse = await CartRepository()
        .getCartAddNewResponse(widget.id, selectId, selectedValue);

    print(widget.id);

    if (cartAddResponse.result == false) {
      ToastComponent.showDialog(cartAddResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else {
      Provider.of<CartCounter>(context, listen: false).getCount();
      if (mode == "add_to_cart") {
        if (snackbar != null && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        reset();
        fetchAll();
      } else if (mode == 'buy_now') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Cart(has_bottomnav: false);
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  onCopyTap(setState) {
    setState(() {
      _showCopied = true;
    });
    Timer timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _showCopied = false;
      });
    });
  }

  onPressCheckQuantity(
    product_id,
    quantity,
  ) async {
    var cartCheckResponse =
        await CartRepository().getQuantityCheckResponse(product_id, quantity);
    setState(() {
      _isLoading = false;
    });
    if (cartCheckResponse.result == true) {
      // ToastComponent.showDialog(cartCheckResponse.message,
      //     gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(cartCheckResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);
    }
  }

  onPressShare(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 26,
                          color: Color.fromRGBO(253, 253, 253, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)!.copy_product_link_ucf,
                            style: TextStyle(
                              color: MyTheme.medium_grey,
                            ),
                          ),
                          onPressed: () {
                            onCopyTap(setState);
                            Clipboard.setData(ClipboardData(
                                text: _productDetails!.link ?? ""));
                            // SocialShare.copyToClipboard(
                            //     text: _productDetails!.link, image: "");
                          },
                        ),
                      ),
                      _showCopied
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.copied_ucf,
                                style: TextStyle(
                                    color: MyTheme.medium_grey, fontSize: 12),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 26,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)!.share_options_ucf,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            SocialShare.shareOptions(_productDetails!.link!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: app_language_rtl.$!
                          ? EdgeInsets.only(left: 8.0)
                          : EdgeInsets.only(right: 8.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.font_grey, width: 1.0)),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          });
        });
  }

  onTapSellerChat() {
    return showDialog(
        context: context,
        builder: (_) => Directionality(
              textDirection:
                  app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10),
                contentPadding: EdgeInsets.only(
                    top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
                content: Container(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(AppLocalizations.of(context)!.title_ucf,
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            height: 40,
                            child: TextField(
                              controller: sellerChatTitleController,
                              autofocus: false,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .enter_title_ucf,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.textfield_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                              "${AppLocalizations.of(context)!.message_ucf} *",
                              style: TextStyle(
                                  color: MyTheme.font_grey, fontSize: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            height: 55,
                            child: TextField(
                              controller: sellerChatMessageController,
                              autofocus: false,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .enter_message_ucf,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.textfield_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      right: 16.0,
                                      left: 8.0,
                                      top: 16.0,
                                      bottom: 16.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 30,
                          color: Color.fromRGBO(253, 253, 253, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: MyTheme.light_grey, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)!.close_all_capital,
                            style: TextStyle(
                              color: MyTheme.font_grey,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Btn.minWidthFixHeight(
                          minWidth: 75,
                          height: 30,
                          color: MyTheme.accent_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: MyTheme.light_grey, width: 1.0)),
                          child: Text(
                            AppLocalizations.of(context)!.send_all_capital,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                            onPressSendMessage();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  loading() {
    showDialog(
        context: context,
        builder: (context) {
          loadingcontext = context;
          return AlertDialog(
              content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("${AppLocalizations.of(context)!.please_wait_ucf}"),
            ],
          ));
        });
  }

  showLoginWarning() {
    return ToastComponent.showDialog(
        AppLocalizations.of(context)!.you_need_to_log_in,
        gravity: Toast.bottom,
        duration: Toast.lengthLong);
  }

  onPressSendMessage() async {
    if (!is_logged_in.$) {
      showLoginWarning();
      return;
    }
    loading();
    var title = sellerChatTitleController.text.toString();
    var message = sellerChatMessageController.text.toString();

    if (title == "" || message == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.title_or_message_empty_warning,
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
    }

    var conversationCreateResponse = await ChatRepository()
        .getCreateConversationResponse(
            product_id: widget.id, title: title, message: message);

    Navigator.of(loadingcontext).pop();

    if (conversationCreateResponse.result == false) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.could_not_create_conversation,
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
    }

    sellerChatTitleController.clear();
    sellerChatMessageController.clear();
    setState(() {});

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(
        conversation_id: conversationCreateResponse.conversation_id,
        messenger_name: conversationCreateResponse.shop_name,
        messenger_title: conversationCreateResponse.title,
        messenger_image: conversationCreateResponse.shop_logo,
      );
      ;
    })).then((value) {
      onPopped(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SnackBar _addedToCartSnackbar = SnackBar(
      content: Text(
        AppLocalizations.of(context)!.added_to_cart,
        style: TextStyle(color: MyTheme.accent_color),
      ),
      backgroundColor: MyTheme.amber_medium,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.show_cart_all_capital,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Cart(has_bottomnav: false);
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.accent_color,
        disabledTextColor: Colors.black,
      ),
    );

    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          extendBody: true,
          bottomNavigationBar: buildBottomAppBar(context, _addedToCartSnackbar),
          //appBar: buildAppBar(statusBarHeight, context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: !_isLoading
                ? CustomScrollView(
                    controller: _mainScrollController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverAppBar(
                        elevation: 0,
                        backgroundColor: Colors.white.withOpacity(opacity),
                        pinned: true,
                        automaticallyImplyLeading: false,
                        //titleSpacing: 0,
                        title: Row(
                          children: [
                            Builder(
                              builder: (context) => InkWell(
                                onTap: () {
                                  return Navigator.of(context).pop();
                                },
                                child: Container(
                                  decoration: BoxDecorations
                                      .buildCircularButtonDecoration_1(),
                                  width: 36,
                                  height: 36,
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.arrow_left,
                                      color: MyTheme.dark_font_grey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //Show product name in appbar
                            AnimatedOpacity(
                                opacity: _scrollPosition > 350 ? 1 : 0,
                                duration: Duration(milliseconds: 200),
                                child: Container(
                                    padding: EdgeInsets.only(left: 8),
                                    width: DeviceInfo(context).width! / 3,
                                    child: Text(
                                      "${_productDetails != null ? _productDetails!.name : ''}",
                                      style: TextStyle(
                                          color: MyTheme.dark_font_grey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'NotoSans'),
                                    ))),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                onPressShare(context);
                              },
                              child: Container(
                                decoration: BoxDecorations
                                    .buildCircularButtonDecoration_1(),
                                width: 36,
                                height: 36,
                                child: Center(
                                  child: Icon(
                                    Icons.share_outlined,
                                    color: MyTheme.dark_font_grey,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                // onWishTap();
                              },
                              child: Container(
                                decoration: BoxDecorations
                                    .buildCircularButtonDecoration_1(),
                                width: 36,
                                height: 36,
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
                              // child: Container(
                              //   height: 36,
                              //   width: 36,
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
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Cart(has_bottomnav: false);
                                })).then((value) {
                                  onPopped(value);
                                });
                              },
                              child: Container(
                                decoration: BoxDecorations
                                    .buildCircularButtonDecoration_1(),
                                width: 36,
                                height: 36,
                                padding: EdgeInsets.all(8),
                                child: badges.Badge(
                                  badgeStyle: badges.BadgeStyle(
                                    shape: badges.BadgeShape.circle,
                                    badgeColor: MyTheme.accent_color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  badgeAnimation: badges.BadgeAnimation.slide(
                                    toAnimate: true,
                                  ),
                                  stackFit: StackFit.loose,
                                  child: Image.asset(
                                    "assets/cart.png",
                                    color: MyTheme.dark_font_grey,
                                    height: 16,
                                  ),
                                  badgeContent: Consumer<CartCounter>(
                                    builder: (context, cart, child) {
                                      return Text(
                                        "${cart.cartCounter}",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        expandedHeight: 375.0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: buildProductSliderImageSection(),
                        ),
                      ),

                      // if (_productDetails!.video_link != '')
                      //   SliverToBoxAdapter(
                      //     child: Container(
                      //       child: Column(
                      //         children: [
                      //           InkWell(
                      //             onTap: () {
                      //               if (_productDetails!.video_link == "") {
                      //                 ToastComponent.showDialog(
                      //                     AppLocalizations.of(context)!
                      //                         .video_not_available,
                      //                     gravity: Toast.center,
                      //                     duration: Toast.lengthLong);
                      //                 return;
                      //               }
                      //
                      //               Navigator.push(context,
                      //                   MaterialPageRoute(builder: (context) {
                      //                 return VideoDescription(
                      //                   url: _productDetails!.video_link,
                      //                 );
                      //               })).then((value) {
                      //                 onPopped(value);
                      //               });
                      //             },
                      //             child: Container(
                      //               color: MyTheme.shimmer_highlighted,
                      //               height: 48,
                      //               child: Padding(
                      //                 padding: const EdgeInsets.fromLTRB(
                      //                   18.0,
                      //                   14.0,
                      //                   18.0,
                      //                   14.0,
                      //                 ),
                      //                 child: Row(
                      //                   children: [
                      //                     Text(
                      //                       AppLocalizations.of(context)!.video_ucf,
                      //                       style: TextStyle(
                      //                         color: MyTheme.dark_font_grey,
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.w500,
                      //                         fontFamily: 'NotoSans',
                      //                       ),
                      //                     ),
                      //                     Spacer(),
                      //                     Image.asset(
                      //                       "assets/arrow.png",
                      //                       height: 11,
                      //                       width: 20,
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //
                      //   ),

                      // SliverToBoxAdapter(
                      //   child: Container(
                      //     child: Column(
                      //       children: [
                      //         InkWell(
                      //           onTap: () {
                      //             if (_productDetails!.video_link == "") {
                      //               ToastComponent.showDialog(
                      //                   AppLocalizations.of(context)!
                      //                       .video_not_available,
                      //                   gravity: Toast.center,
                      //                   duration: Toast.lengthLong);
                      //               return;
                      //             }
                      //
                      //             Navigator.push(context,
                      //                 MaterialPageRoute(builder: (context) {
                      //               return VideoDescription(
                      //                 url: _productDetails!.video_link,
                      //               );
                      //             })).then((value) {
                      //               onPopped(value);
                      //             });
                      //           },
                      //           child: Container(
                      //             color: MyTheme.shimmer_highlighted,
                      //             height: 48,
                      //             child: Padding(
                      //               padding: const EdgeInsets.fromLTRB(
                      //                 18.0,
                      //                 14.0,
                      //                 18.0,
                      //                 14.0,
                      //               ),
                      //               child: Row(
                      //                 children: [
                      //                   Text(
                      //                     AppLocalizations.of(context)!.video_ucf,
                      //                     style: TextStyle(
                      //                       color: MyTheme.dark_font_grey,
                      //                       fontSize: 16,
                      //                       fontWeight: FontWeight.w500,
                      //                       fontFamily: 'NotoSans',
                      //                     ),
                      //                   ),
                      //                   Spacer(),
                      //                   Image.asset(
                      //                     "assets/arrow.png",
                      //                     height: 11,
                      //                     width: 20,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      SliverToBoxAdapter(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 14, left: 14, right: 14),
                                      child: _productDetails != null
                                          ? Text(
                                              _productDetails!.name!,
                                              style: TextStyles
                                                  .smallTitleTexStyle(),
                                              maxLines: 2,
                                            )
                                          : ShimmerHelper().buildBasicShimmer(
                                              height: 30.0,
                                            ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_productDetails!.video_link == "") {
                                        ToastComponent.showDialog(
                                            AppLocalizations.of(context)!
                                                .video_not_available,
                                            gravity: Toast.bottom,
                                            duration: Toast.lengthLong);
                                        return;
                                      }
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return VideoDescription(
                                          url: _productDetails!.video_link,
                                        );
                                      })).then((value) {
                                        onPopped(value);
                                      });
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0.0,
                                          20.0,
                                          10.0,
                                          0.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/youtube.png",
                                              height: 32,
                                              width: 32,
                                            ),
                                            Text(
                                              ' VIDEO ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'NotoSans'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5, left: 14),
                                child: _productDetails != null
                                    ? buildRatingAndWishButtonRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 14, right: 14),
                                child: Text(
                                  _productDetails == null
                                      ? ""
                                      : _productDetails!.gender.toString(),
                                  // _productDetails!.gender,
                                  // "Mens",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'NotoSans'),
                                ),
                              ),
                              if (_productDetails != null &&
                                  _productDetails!.estShippingTime != null &&
                                  _productDetails!.estShippingTime! > 0)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 14, left: 14, right: 14),
                                  child: _productDetails != null
                                      ? buildShippingTime()
                                      : ShimmerHelper().buildBasicShimmer(
                                          height: 30.0,
                                        ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 14, left: 14, right: 14),
                                child: _productDetails != null
                                    ? buildMainPriceRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 14, left: 14, right: 14),
                                child: _productDetails != null
                                    ? buildGstRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 14, left: 14, right: 14),
                                child: _productDetails != null
                                    ? buildMrpRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                              Visibility(
                                visible: club_point_addon_installed.$,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 14, left: 14, right: 14),
                                  child: _productDetails != null
                                      ? buildClubPointRow()
                                      : ShimmerHelper().buildBasicShimmer(
                                          height: 30.0,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 14, left: 14, right: 14),
                                child: _productDetails != null
                                    ? buildBrandRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 50.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 14),
                                child: _productDetails != null
                                    ? buildSellerRow(context)
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 50.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 14, left: 14, right: 14),
                                child: _productDetails != null
                                    ? (_colorList.length > 0
                                        ? buildColorRow()
                                        : Container())
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 14,
                                    left: app_language_rtl.$! ? 0 : 14,
                                    right: app_language_rtl.$! ? 14 : 0),
                                child: _productDetails != null
                                    ? buildChoiceOptionList()
                                    : buildVariantShimmers(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 14, left: 14, right: 14),
                                child: _productDetails != null
                                    ? buildQuantityRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 14, right: 14),
                                child: _productDetails != null
                                    ? buildSummaryRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 14),
                                child: _productDetails != null
                                    ? buildTotalPriceRow()
                                    : ShimmerHelper().buildBasicShimmer(
                                        height: 30.0,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: MyTheme.white,
                                margin: EdgeInsets.only(top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        15.0,
                                        0.0,
                                        0.0,
                                        15.0,
                                      ),
                                      child: Text(
                                        // AppLocalizations.of(context)!.description_ucf,
                                        "Product Details :",
                                        style: TextStyle(
                                            color: MyTheme.dark_font_grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NotoSans'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16.0,
                                        0.0,
                                        8.0,
                                        8.0,
                                      ),
                                      child: _productDetails != null
                                          ? buildExpandableDescription()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8.0),
                                              child: ShimmerHelper()
                                                  .buildBasicShimmer(
                                                height: 40.0,
                                              )),
                                    ),
                                  ],
                                ),
                              ),
                              if (_productDetails?.downloads != null)
                                // Column(
                                //   children: [
                                //     divider(),
                                //     InkWell(
                                //       onTap: () async {
                                //         // print(_productDetails?.downloads);
                                //         var url = Uri.parse(
                                //             _productDetails?.downloads ?? "");
                                //         // print(url);
                                //         launchUrl(url,
                                //             mode: LaunchMode.externalApplication);
                                //       },
                                //       child: Container(
                                //         color: MyTheme.white,
                                //         height: 48,
                                //         child: Padding(
                                //           padding: const EdgeInsets.fromLTRB(
                                //             18.0,
                                //             14.0,
                                //             18.0,
                                //             14.0,
                                //           ),
                                //           child: Row(
                                //             children: [
                                //               Text(
                                //                 AppLocalizations.of(context)!
                                //                     .downloads_ucf,
                                //                 style: TextStyle(
                                //                     color: MyTheme.dark_font_grey,
                                //                     fontSize: 13,
                                //                     fontWeight: FontWeight.w600),
                                //               ),
                                //               Spacer(),
                                //               Image.asset(
                                //                 "assets/arrow.png",
                                //                 height: 11,
                                //                 width: 20,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                divider(),
                              // InkWell(
                              //   onTap: () {
                              //     if (_productDetails!.video_link == "") {
                              //       ToastComponent.showDialog(
                              //           AppLocalizations.of(context)!
                              //               .video_not_available,
                              //           gravity: Toast.center,
                              //           duration: Toast.lengthLong);
                              //       return;
                              //     }
                              //
                              //     Navigator.push(context,
                              //         MaterialPageRoute(builder: (context) {
                              //       return VideoDescription(
                              //         url: _productDetails!.video_link,
                              //       );
                              //     })).then((value) {
                              //       onPopped(value);
                              //     });
                              //   },
                              //   child: Container(
                              //     color: MyTheme.white,
                              //     height: 48,
                              //     child: Padding(
                              //       padding: const EdgeInsets.fromLTRB(
                              //         18.0,
                              //         14.0,
                              //         18.0,
                              //         14.0,
                              //       ),
                              //       child: Row(
                              //         children: [
                              //           Text(
                              //             AppLocalizations.of(context)!.video_ucf,
                              //             style: TextStyle(
                              //                 color: MyTheme.dark_font_grey,
                              //                 fontSize: 13,
                              //                 fontWeight: FontWeight.w600),
                              //           ),
                              //           Spacer(),
                              //           Image.asset(
                              //             "assets/arrow.png",
                              //             height: 11,
                              //             width: 20,
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CommonWebviewScreen(
                                      url:
                                          "${AppConfig.RAW_BASE_URL}/mobile-page/return-policy",
                                      page_name: AppLocalizations.of(context)!
                                          .return_policy_ucf,
                                    );
                                  }));
                                },
                                child: Container(
                                  color: MyTheme.light_grey,
                                  height: 48,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      18.0,
                                      14.0,
                                      18.0,
                                      14.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Return Policy',
                                          style: TextStyle(
                                              color: MyTheme.dark_font_grey,
                                              fontSize: 14,
                                              fontFamily: 'NotoSans',
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          "assets/arrow.png",
                                          height: 11,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: MyTheme.light_grey,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, bottom: 15),
                                  child: Center(
                                    child: Container(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Card(
                                              elevation: 2,
                                              shadowColor: Colors.black,
                                              color: MyTheme.white,
                                              child: SizedBox(
                                                width: 80,
                                                height: 96,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 10.0),
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            MyTheme.light_grey,
                                                        child: Image.asset(
                                                          "assets/return.png",
                                                          height: 32,
                                                          width: 32,
                                                          color: MyTheme
                                                              .accent_color,
                                                        ),
                                                      ),
                                                      Text("Return Within",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                      Text("7 Days",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 2,
                                              shadowColor: Colors.black,
                                              color: MyTheme.white,
                                              child: SizedBox(
                                                width: 80,
                                                height: 96,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 10.0),
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            MyTheme.light_grey,
                                                        child: Image.asset(
                                                          "assets/wrong_product.png",
                                                          height: 32,
                                                          width: 32,
                                                          color: MyTheme
                                                              .accent_color,
                                                        ),
                                                      ),
                                                      Text("Wrong",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                      Text("Product",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 2,
                                              shadowColor: Colors.black,
                                              color: MyTheme.white,
                                              child: SizedBox(
                                                width: 80,
                                                height: 96,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 10.0),
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            MyTheme.light_grey,
                                                        child: Image.asset(
                                                          "assets/damage_product.png",
                                                          height: 32,
                                                          width: 32,
                                                          color: MyTheme
                                                              .accent_color,
                                                        ),
                                                      ),
                                                      Text("Damaged",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                      Text("Product",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              elevation: 2,
                                              shadowColor: Colors.black,
                                              color: MyTheme.white,
                                              child: SizedBox(
                                                width: 80,
                                                height: 96,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 10.0),
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            MyTheme.light_grey,
                                                        child: Image.asset(
                                                          "assets/quality_product.png",
                                                          height: 32,
                                                          width: 32,
                                                          color: MyTheme
                                                              .accent_color,
                                                        ),
                                                      ),
                                                      Text("Quality",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                      Text("Issue",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                              height: 2)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              divider(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProductReviews(id: widget.id);
                                  })).then((value) {
                                    onPopped(value);
                                  });
                                },
                                child: Container(
                                  color: MyTheme.white,
                                  height: 48,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      18.0,
                                      14.0,
                                      18.0,
                                      14.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .reviews_ucf,
                                          style: TextStyle(
                                              color: MyTheme.dark_font_grey,
                                              fontSize: 14,
                                              fontFamily: 'NotoSans',
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          "assets/arrow.png",
                                          height: 11,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              divider(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CommonWebviewScreen(
                                      url:
                                          "${AppConfig.RAW_BASE_URL}/mobile-page/seller-policy",
                                      page_name: AppLocalizations.of(context)!
                                          .seller_policy_ucf,
                                    );
                                  }));
                                },
                                child: Container(
                                  color: MyTheme.white,
                                  height: 48,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      18.0,
                                      14.0,
                                      18.0,
                                      14.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .seller_policy_ucf,
                                          style: TextStyle(
                                              color: MyTheme.dark_font_grey,
                                              fontSize: 14,
                                              fontFamily: 'NotoSans',
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          "assets/arrow.png",
                                          height: 11,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // divider(),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.push(context,
                              //         MaterialPageRoute(builder: (context) {
                              //       return CommonWebviewScreen(
                              //         url:
                              //             "${AppConfig.RAW_BASE_URL}/mobile-page/return-policy",
                              //         page_name: AppLocalizations.of(context)!
                              //             .return_policy_ucf,
                              //       );
                              //     }));
                              //   },
                              //   child: Container(
                              //     color: MyTheme.white,
                              //     height: 48,
                              //     child: Padding(
                              //       padding: const EdgeInsets.fromLTRB(
                              //         18.0,
                              //         14.0,
                              //         18.0,
                              //         14.0,
                              //       ),
                              //       child: Row(
                              //         children: [
                              //           Text(
                              //             AppLocalizations.of(context)!
                              //                 .return_policy_ucf,
                              //             style: TextStyle(
                              //                 color: MyTheme.dark_font_grey,
                              //                 fontSize: 13,
                              //                 fontWeight: FontWeight.w600),
                              //           ),
                              //           Spacer(),
                              //           Image.asset(
                              //             "assets/arrow.png",
                              //             height: 11,
                              //             width: 20,
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              divider(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CommonWebviewScreen(
                                      url:
                                          "${AppConfig.RAW_BASE_URL}/mobile-page/support-policy",
                                      page_name: AppLocalizations.of(context)!
                                          .support_policy_ucf,
                                    );
                                  }));
                                },
                                child: Container(
                                  color: MyTheme.white,
                                  height: 48,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      18.0,
                                      14.0,
                                      18.0,
                                      14.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .support_policy_ucf,
                                          style: TextStyle(
                                              color: MyTheme.dark_font_grey,
                                              fontSize: 14,
                                              fontFamily: 'NotoSans',
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          "assets/arrow.png",
                                          height: 11,
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              divider(),
                            ]),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              18.0,
                              24.0,
                              18.0,
                              0.0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .products_you_may_also_like,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          buildProductsMayLikeList()
                        ]),
                      ),

                      //Top selling product
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              20.0,
                              10.0,
                              18.0,
                              10.0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .top_selling_products_ucf,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              0.0,
                              16.0,
                              0.0,
                            ),
                            child: buildTopSellingProductList(),
                          ),
                          Container(
                            height: 83,
                          )
                        ]),
                      )
                    ],
                  )
                : Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          )),
    );
  }

  Widget buildSellerRow(BuildContext context) {
    // print(_productDetails!.id);
    return Container(
      color: MyTheme.light_grey,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          _productDetails!.added_by == "admin"
              ? Container()
              : InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SellerDetails(
                                  id: _productDetails!.shop_id,
                                )));
                  },
                  child: Padding(
                    padding: app_language_rtl.$!
                        ? EdgeInsets.only(left: 8.0)
                        : EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                            color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                        //shape: BoxShape.rectangle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: _productDetails!.shop_logo!.toString(),
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32),
                      ),
                    ),
                  ),
                ),
          Container(
            width: MediaQuery.of(context).size.width * (.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.seller_ucf,
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 14,
                      color: Colors.black,
                    )),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  _productDetails!.shop_name!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.w600),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Text(
                  'Minimum Order Value: ₹${_productDetails!.minimum_order_value}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Spacer(),
          Visibility(
            visible: conversation_system_status.$,
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecorations.buildCircularButtonDecoration_3(),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (is_logged_in == false) {
                            ToastComponent.showDialog("You need to log in",
                                gravity: Toast.bottom,
                                duration: Toast.lengthLong);
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellerDetails(
                                        id: _productDetails!.shop_id,
                                      )));
                        },
                        child: Text(
                          'Visit Store',
                          style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSans',
                          ),
                        )),
                    // child: Image.asset('assets/chat.png',
                    //     height: 16, width: 16, color: MyTheme.dark_grey)),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget buildTotalPriceRow() {
    return Center(
      child: Container(
        height: 50,
        // color: MyTheme.amber,
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.sizeOf(context).width - 20,
        decoration: BoxDecorations.buildCircularButtonDecoration_8(),
        child: Row(
          children: [
            Container(
              child: Padding(
                padding: app_language_rtl.$!
                    ? EdgeInsets.only(left: 8.0)
                    : EdgeInsets.only(right: 8.0),
                child: Container(
                  // width: 75,
                  child: Text(
                    // AppLocalizations.of(context)!.total_price_ucf,
                    "Total Price :",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                '₹ ${totalPriceValue.toStringAsFixed(2).toString()}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSans',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildSummaryRow() {
    return Row(
      children: [
        Text(
          "Summary :",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 15.0)),
        Text(
          '$sum Pairs x ₹ ${_singlePriceCalculation.toString()}',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSans',
              color: MyTheme.accent_color),
        ),
      ],
    );
  }

  Row buildQuantityRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$!
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              // AppLocalizations.of(context)!.quantity_ucf,
              "Quantity :",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NotoSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      )),
                      height: 350,
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Container(
                            height: 70,
                            width: MediaQuery.sizeOf(context).width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Row(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/placeholder.png',
                                      image: colorModel!.thumbnailImage,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: SingleChildScrollView(
                                            child: Text(
                                              _productDetails!.name!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: MyTheme.accent_color,
                                                  fontFamily: 'NotoSans',
                                                  fontWeight: FontWeight.w600),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          'Color : ${colorModel?.colorName}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'NotoSans',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
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
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 40,
                            color: Colors.blue.withOpacity(.1),
                            width: MediaQuery.sizeOf(context).width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' Availability Set Size',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Select Qty  ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'NotoSans',
                                      color: Colors.black,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 80,
                            child: ListView.builder(
                                itemCount: response.data.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              response.data[index].size,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'NotoSans',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2<int>(
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select Pairs',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'NotoSans',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  items: response
                                                      .data[index].qty
                                                      .map((int item) =>
                                                          DropdownMenuItem<int>(
                                                            value: item,
                                                            child: Text(
                                                              item.toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'NotoSans',
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: selectedValue?[index],
                                                  onChanged: (int? value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        selectedValue?[index] =
                                                            value;
                                                        selectId[index] =
                                                            response
                                                                .data[index].id;
                                                        _isSelected = true;
                                                      });
                                                    }
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
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
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigator.pop(context);
                                    setState(() {
                                      selectedValue?[0] = 0;
                                      selectId[0] = 0;
                                    });
                                    for (final (index, item)
                                        in response.data.indexed) {
                                      setState(() {
                                        selectedValue?[index] = 0;
                                        selectId[index] = 0;
                                      });
                                    }
                                    totalPriceValue = 0;
                                    sum = 0;
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.sizeOf(context).width / 3,
                                    margin:
                                        EdgeInsets.only(left: 18, right: 18),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: MyTheme.accent_color_shadow,
                                      boxShadow: [
                                        BoxShadow(
                                          color: MyTheme.accent_color_shadow,
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
                                            fontFamily: 'NotoSans',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    double? pricevalue =
                                        _singlePriceCalculation;
                                    sum = selectedValue?.fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue! + element!);
                                    totalPriceValue = pricevalue! * sum!;
                                    onPressCheckQuantity(widget.id, sum);

                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 18, right: 18),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: MyTheme.accent_color,
                                      boxShadow: [
                                        BoxShadow(
                                          color: MyTheme.grey_153,
                                          blurRadius: 20,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.0,
                                              10.0), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    height: 50,
                                    width: MediaQuery.sizeOf(context).width / 3,
                                    child: Center(
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'NotoSans',
                                            fontWeight: FontWeight.w600),
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
              border: Border.all(color: MyTheme.accent_color, width: 1.5),
            ),
            height: 30,
            width: MediaQuery.sizeOf(context).width - 160,
            child: Center(
                child: _isSelected
                    ? Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$sum',
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontFamily: 'NotoSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              ' Pairs',
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontFamily: 'NotoSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      )
                    : Text(
                        'Select Size & Pairs',
                        style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: MyTheme.accent_color),
                      )),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: Text(
        //     "(${_stock_txt})",
        //     style: TextStyle(
        //         color: Color.fromRGBO(152, 152, 153, 1), fontSize: 14),
        //   ),
        // ),
      ],
    );
  }

  TextEditingController quantityText = TextEditingController(text: "0");

  Padding buildVariantShimmers() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        0.0,
        8.0,
        0.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                ),
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 8.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 30.0, width: 60),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildChoiceOptionList() {
    return ListView.builder(
      itemCount: _productDetails!.choice_options!.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: buildChoiceOpiton(_productDetails!.choice_options, index),
        );
      },
    );
  }

  buildChoiceOpiton(choice_options, choice_options_index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        14.0,
        0.0,
        0.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: app_language_rtl.$!
                ? EdgeInsets.only(left: 8.0)
                : EdgeInsets.only(right: 8.0),
            child: Container(
              width: 75,
              child: Text(
                'Available Size :',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - (107 + 45),
            child: Scrollbar(
              controller: _variantScrollController,
              thumbVisibility: false,
              child: Wrap(
                children: List.generate(
                    choice_options[choice_options_index].options.length,
                    (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width / 1.5,
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: buildChoiceItem(
                              choice_options[choice_options_index]
                                  .options[index],
                              choice_options_index,
                              index),
                        ))),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildChoiceItem(option, choice_options_index, index) {
    return Padding(
      padding: app_language_rtl.$!
          ? EdgeInsets.only(left: 8.0)
          : EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          _onVariantChange(choice_options_index, option);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: MyTheme.noColor, width: 1.5),
            borderRadius: BorderRadius.circular(3.0),
            color: MyTheme.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                spreadRadius: 1,
                offset: Offset(0.0, 3.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 12.0,
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildColorRow() {
    return Row(
      children: [
        Padding(
          padding: app_language_rtl.$!
              ? EdgeInsets.only(left: 8.0)
              : EdgeInsets.only(right: 8.0),
          child: Container(
            width: 75,
            child: Text(
              'Color :',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
        ),
        Container(
          alignment: app_language_rtl.$!
              ? Alignment.centerRight
              : Alignment.centerLeft,
          height: 130,
          width: MediaQuery.of(context).size.width - (107 + 10),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            itemCount: _colorsProduct!.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductDetails(
                            id: _colorsProduct?[index]['id'],
                          );
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: _colorsProduct?[index]
                                          ['thumbnail_image'] ==
                                      _productDetails!.thumbnail_image
                                  ? MyTheme.accent_color
                                  : MyTheme.grey_153.withOpacity(.3),
                              width: _colorsProduct?[index]
                                          ['thumbnail_image'] ==
                                      _productDetails!.thumbnail_image
                                  ? 2
                                  : 1),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(4),
                                right: Radius.circular(4)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: _colorsProduct?[index]['thumbnail_image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )),
                      )),
                  Padding(padding: EdgeInsets.only(top: 5.0)),
                  Text(
                    _colorsProduct![index]['color_name'].toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans',
                        fontSize: 14),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  // buildColorRow() {
  //   return Row(
  //     children: [
  //       Padding(
  //         padding: app_language_rtl.$!
  //             ? EdgeInsets.only(left: 8.0)
  //             : EdgeInsets.only(right: 8.0),
  //         child: Container(
  //           width: 75,
  //           child: Text(
  //             AppLocalizations.of(context)!.color_ucf,
  //             style: TextStyle(
  //                 color: Color.fromRGBO(153, 153, 153, 1),
  //                 fontFamily: 'NotoSans',
  //                 fontSize: 14),
  //           ),
  //         ),
  //       ),
  //       Container(
  //         alignment: app_language_rtl.$!
  //             ? Alignment.centerRight
  //             : Alignment.centerLeft,
  //         height: 40,
  //         width: MediaQuery.of(context).size.width - (107 + 44),
  //         child: Scrollbar(
  //           controller: _colorScrollController,
  //           child: ListView.separated(
  //             separatorBuilder: (context, index) {
  //               return SizedBox(
  //                 width: 10,
  //               );
  //             },
  //             itemCount: _colorList.length,
  //             scrollDirection: Axis.horizontal,
  //             shrinkWrap: true,
  //             itemBuilder: (context, index) {
  //               return Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   buildColorItem(index),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget buildColorItem(index) {
    return InkWell(
      onTap: () {
        _onColorChange(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: _selectedColorIndex == index ? 30 : 25,
        height: _selectedColorIndex == index ? 30 : 25,
        decoration: BoxDecoration(
          // border: Border.all(
          //     color: _selectedColorIndex == index
          //         ? Colors.purple
          //         : Colors.white,
          //     width: 1),
          borderRadius: BorderRadius.circular(16.0),
          color: ColorHelper.getColorFromColorCode(_colorList[index]),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(_selectedColorIndex == index ? 0.25 : 0.12),
              blurRadius: 10,
              spreadRadius: 2.0,
              offset: Offset(0.0, 6.0), // shadow direction: bottom right
            )
          ],
        ),
        child: _selectedColorIndex == index
            ? buildColorCheckerContainer()
            : Container(
                height: 25,
              ),
        /*Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(222, 222, 222, 1), width: 1),
               // borderRadius: BorderRadius.circular(16.0),
                color: ColorHelper.getColorFromColorCode(_colorList[index])),
            child: _selectedColorIndex == index
                ? buildColorCheckerContainer()
                : Container(),
          ),
        ),*/
      ),
    );
  }

  buildColorCheckerContainer() {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: /*Icon(Icons.check, color: Colors.white, size: 16),*/
            Image.asset(
          "assets/white_tick.png",
          width: 16,
          height: 16,
        ));
  }

  Widget buildWholeSaleQuantityPrice() {
    return DataTable(
      // clipBehavior:Clip.antiAliasWithSaveLayer,
      columnSpacing: DeviceInfo(context).width! * 0.125,

      columns: [
        DataColumn(
            label: Text(LangText(context).local.min_qty_ucf,
                style: TextStyle(fontSize: 12, color: MyTheme.dark_grey))),
        DataColumn(
            label: Text(LangText(context).local.max_qty_ucf,
                style: TextStyle(fontSize: 12, color: MyTheme.dark_grey))),
        DataColumn(
            label: Text(LangText(context).local.unit_price_ucf,
                style: TextStyle(fontSize: 12, color: MyTheme.dark_grey))),
      ],
      rows: List<DataRow>.generate(
        _productDetails!.wholesale!.length,
        (index) {
          return DataRow(cells: <DataCell>[
            DataCell(
              Text(
                '${_productDetails!.wholesale![index].minQty.toString()}',
                style: TextStyle(
                    color: Color.fromRGBO(152, 152, 153, 1), fontSize: 12),
              ),
            ),
            DataCell(
              Text(
                '${_productDetails!.wholesale![index].maxQty.toString()}',
                style: TextStyle(
                    color: Color.fromRGBO(152, 152, 153, 1), fontSize: 12),
              ),
            ),
            DataCell(
              Text(
                convertPrice(
                    _productDetails!.wholesale![index].price.toString()),
                style: TextStyle(
                    color: Color.fromRGBO(152, 152, 153, 1), fontSize: 12),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Widget buildClubPointRow() {
    return Container(
      constraints: BoxConstraints(maxWidth: 130),
      //width: ,
      decoration: BoxDecoration(
          //border: Border.all(color: MyTheme.golden, width: 1),
          borderRadius: BorderRadius.circular(6.0),
          color:
              //Colors.red,),
              Color.fromRGBO(253, 235, 212, 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/clubpoint.png",
                  width: 18,
                  height: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.club_point_ucf,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 10),
                ),
              ],
            ),
            Text(
              _productDetails!.earn_point.toString(),
              style: TextStyle(color: MyTheme.golden, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Row buildMainPriceRow() {
    return Row(
      children: [
        Text(
          SystemConfig.systemCurrency != null
              ? _singlePriceString.replaceAll(SystemConfig.systemCurrency!.code,
                  SystemConfig.systemCurrency!.symbol)
              : _singlePriceString,
          // _singlePriceString,
          style: TextStyle(
              color: MyTheme.accent_color,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSans',
              letterSpacing: 1),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Text(
            "| MOQ: ${_productDetails!.moq.toString() + " " + _productDetails!.unit.toString()}",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Row buildGstRow() {
    return Row(
      children: [
        Container(
          child: Row(
            children: [
              Text(
                "₹${_productDetails!.buyto_rate.toString()}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NotoSans',
                    letterSpacing: 1),
              ),
              Text(
                " + ${_productDetails!.stroked_price.toString()}" + " GST",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NotoSans'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildMrpRow() {
    return Row(
      children: [
        Container(
          // margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: MyTheme.accent_color_shadow),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "MRP: ₹${_productDetails!.mrp.toString()}",
                style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSans',
                    letterSpacing: 1),
              ),
              Text(
                "| Margin: ${_productDetails!.margin.toString()}" + " %",
                // _singlePriceString,
                style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSans'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 32.0 : 16.0),
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child: Container(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text(
                _appbarPriceString!,
                style: TextStyle(fontSize: 16, color: MyTheme.font_grey),
              ),
            )),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.share_outlined, color: MyTheme.dark_grey),
            onPressed: () {
              onPressShare(context);
            },
          ),
        ),
      ],
    );
  }

  Widget buildBottomAppBar(BuildContext context, _addedToCartSnackbar) {
    return BottomNavigationBar(
      backgroundColor: MyTheme.white.withOpacity(0.9),
      items: [
        BottomNavigationBarItem(
          label: "",
          icon: InkWell(
            onTap: () {
              // onPressBuyNow(context);
              onWishTap();
            },
            child: Container(
              margin: EdgeInsets.only(left: 18, right: 18),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: MyTheme.accent_color_shadow,
                boxShadow: [
                  BoxShadow(
                    color: MyTheme.accent_color_shadow,
                    blurRadius: 20,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 10.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Center(
                child: Text(
                  // AppLocalizations.of(context)!.buy_now_ucf,
                  'Add Wishlist',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.transparent,
          label: '',
          icon: InkWell(
            onTap: () {
              onPressAddToCart(context, _addedToCartSnackbar);
              setState(() {
                sum = 0;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 18,
                right: 18,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: MyTheme.accent_color,
                boxShadow: [
                  BoxShadow(
                    color: MyTheme.accent_color_shadow,
                    blurRadius: 20,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 10.0), // shadow direction: bottom right
                  )
                ],
              ),
              height: 50,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.add_to_cart_ucf,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),

        /*Container(
          color: Colors.white.withOpacity(0.95),
          height: 83,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 18,
              ),

              SizedBox(
                width: 14,
              ),

              SizedBox(
                width: 18,
              ),
            ],
          ),
        )*/
      ],
    );
  }

  buildRatingAndWishButtonRow() {
    return Row(
      children: [
        RatingBar(
          itemSize: 15.0,
          ignoreGestures: true,
          initialRating: double.parse(_productDetails!.rating.toString()),
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Icon(Icons.star, color: Colors.amber),
            half: Icon(Icons.star_half, color: Colors.amber),
            empty: Icon(Icons.star, color: Color.fromRGBO(224, 224, 225, 1)),
          ),
          itemPadding: EdgeInsets.only(right: 1.0),
          onRatingUpdate: (rating) {
            //print(rating);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "(" + _productDetails!.rating_count.toString() + ")",
            style: TextStyle(
                color: Color.fromRGBO(152, 152, 153, 1), fontSize: 10),
          ),
        ),
      ],
    );
  }

  buildShippingTime() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Text(
            "Estimate Shipping Time :",
            style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Text(
            "${_productDetails!.estShippingTime} Days",
            style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  buildBrandRow() {
    return _productDetails!.brand!.id! > 0
        ? InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BrandProducts(
                  id: _productDetails!.brand!.id,
                  brand_name: _productDetails!.brand!.name,
                );
              }));
            },
            child: Row(
              children: [
                Padding(
                  padding: app_language_rtl.$!
                      ? EdgeInsets.only(left: 8.0)
                      : EdgeInsets.only(right: 0.0),
                  child: Container(
                    width: 50,
                    child: Text(
                      AppLocalizations.of(context)!.brand_ucf,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Text(
                    _productDetails!.brand!.name!,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'NotoSans'),
                  ),
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    '|  Category:',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'NotoSans'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Text(
                    _productDetails!.new_category_name!,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'NotoSans'),
                  ),
                ),
                // Container(
                //   width: 36,
                //   height: 36,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5),
                //     border: Border.all(
                //         color: Color.fromRGBO(112, 112, 112, .3), width: 1),
                //     //shape: BoxShape.rectangle,
                //   ),
                //   child: ClipRRect(
                //       borderRadius: BorderRadius.circular(5),
                //       child: FadeInImage.assetNetwork(
                //         placeholder: 'assets/placeholder.png',
                //         image: _productDetails!.brand.logo,
                //         fit: BoxFit.contain,
                //       )),
                // ),
              ],
            ),
          )
        : Container();
  }

  buildExpandableDescription() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(padding: EdgeInsets.only(top: 0.0)),
          Container(
            width: DeviceInfo(context).width,
            height: MediaQuery.sizeOf(context).height / 3.5,
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
    /*ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Container(
                height: 50, child: Html(data: _productDetails!.description)),
            expanded: Container(child: Html(
              data: _productDetails!.description,
            )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Builder(
                builder: (context) {
                  var controller = ExpandableController.of(context)!;
                  return Btn.basic(
                    child: Text(
                      !controller.expanded
                          ? AppLocalizations.of(context)!.view_more_ucf
                          : AppLocalizations.of(context)!.show_less_ucf,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 11),
                    ),
                    onPressed: () {
                      controller.toggle();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ));*/
  }

  buildTopSellingProductList() {
    if (_topProductInit == false && _topProducts.length == 0) {
      return Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 75.0,
              )),
        ],
      );
    } else if (_topProducts.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 14,
          ),
          itemCount: _topProducts.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: 14),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListProductCard(
                id: _topProducts[index].id,
                image: _topProducts[index].thumbnail_image,
                name: _topProducts[index].name,
                main_price: _topProducts[index].main_price,
                stroked_price: _topProducts[index].stroked_price,
                category_name: _topProducts[index].new_category_name,
                brand_name: _topProducts[index].new_brand_name,
                margin: _topProducts[index].margin,
                mrp: _topProducts[index].mrp,
                moq: _topProducts[index].moq,
                unit_name: _topProducts[index].unit_name,
                has_discount: _topProducts[index].has_discount);
          },
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                  AppLocalizations.of(context)!
                      .no_top_selling_products_from_this_seller,
                  style: TextStyle(color: MyTheme.font_grey))));
    }
  }

  buildProductsMayLikeList() {
    if (_relatedProductInit == false && _relatedProducts.length == 0) {
      return Row(
        children: [
          Padding(
              padding: app_language_rtl.$!
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: app_language_rtl.$!
                  ? EdgeInsets.only(left: 8.0)
                  : EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_relatedProducts.length > 0) {
      // print(_relatedProducts);
      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height / 2.45,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 16,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: _relatedProducts.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return MiniProductCard(
                id: _relatedProducts[index].id,
                image: _relatedProducts[index].thumbnail_image,
                name: _relatedProducts[index].name,
                main_price: _relatedProducts[index].main_price,
                stroked_price: _relatedProducts[index].stroked_price,
                is_wholesale: _relatedProducts[index].isWholesale,
                discount: _relatedProducts[index].discount,
                has_discount: _relatedProducts[index].has_discount,
                brand_name: _relatedProducts[index].new_brand_name,
                category_name: _relatedProducts[index].new_category_name,
                margins: _relatedProducts[index].margin,
                mrp: _relatedProducts[index].mrp,
                moq: _relatedProducts[index].moq,
                unit_name: _relatedProducts[index].unit_name,
                gender: _relatedProducts[index].gender,
              );
            },
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_related_product,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  buildQuantityUpButton() => Container(
        decoration: BoxDecorations.buildCircularButtonDecoration_1(),
        width: 36,
        child: IconButton(
            icon: Icon(Icons.add, size: 16, color: MyTheme.dark_grey),
            onPressed: () {
              if (_quantity! < _stock!) {
                _quantity = (_quantity!) + 1;
                setState(() {});
                //fetchVariantPrice();

                // fetchAndSetVariantWiseInfo();
                // calculateTotalPrice();
              }
            }),
      );

  buildQuantityDownButton() => Container(
      decoration: BoxDecorations.buildCircularButtonDecoration_1(),
      width: 36,
      child: IconButton(
          icon: Icon(Icons.remove, size: 16, color: MyTheme.dark_grey),
          onPressed: () {
            if (_quantity! > 1) {
              _quantity = _quantity! - 1;
              setState(() {});
              // calculateTotalPrice();
              // fetchVariantPrice();
              // fetchAndSetVariantWiseInfo();
            }
          }));

  openPhotoDialog(BuildContext context, path) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                child: Stack(
              children: [
                PhotoView(
                  enableRotation: true,
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                  imageProvider: NetworkImage(path),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: MyTheme.medium_grey_50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: Icon(Icons.clear, color: MyTheme.white),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      );

  buildProductImageSection() {
    if (_productImageList.length == 0) {
      return Row(
        children: [
          Container(
            width: 40,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ShimmerHelper()
                      .buildBasicShimmer(height: 40.0, width: 40.0),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                height: 190.0,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            width: 64,
            child: Scrollbar(
              controller: _imageScrollController,
              thumbVisibility: false,
              thickness: 4.0,
              child: Padding(
                padding: app_language_rtl.$!
                    ? EdgeInsets.only(left: 8.0)
                    : EdgeInsets.only(right: 8.0),
                child: ListView.builder(
                    itemCount: _productImageList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int itemIndex = index;
                      return GestureDetector(
                        onTap: () {
                          _currentImage = itemIndex;
                          // print(_currentImage);
                          setState(() {});
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: _currentImage == itemIndex
                                    ? MyTheme.accent_color
                                    : Color.fromRGBO(112, 112, 112, .3),
                                width: _currentImage == itemIndex ? 2 : 1),
                            //shape: BoxShape.rectangle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  /*Image.asset(
                                        singleProduct.product_images[index])*/
                                  FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: _productImageList[index],
                                fit: BoxFit.contain,
                              )),
                        ),
                      );
                    }),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              openPhotoDialog(context, _productImageList[_currentImage]);
            },
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width - 96,
              // child: Container(
              //     child: FadeInImage.assetNetwork(
              //   placeholder: 'assets/placeholder_rectangle.png',
              //   image: _productImageList[_currentImage],
              //   fit: BoxFit.scaleDown,
              // )),
            ),
          ),
        ],
      );
    }
  }

  Widget buildProductSliderImageSection() {
    if (_productImageList.length == 0) {
      return ShimmerHelper().buildBasicShimmer(
        height: 190.0,
      );
    } else {
      return CarouselSlider(
        carouselController: _carouselController,
        options: CarouselOptions(
            aspectRatio: 355 / 375,
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInExpo,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              // print(index);
              setState(() {
                _currentImage = index;
              });
            }),
        items: _productImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        openPhotoDialog(
                            context, _productImageList[_currentImage]);
                      },
                      child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.fitHeight,
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              _productImageList.length,
                              (index) => Container(
                                    width: 7.0,
                                    height: 7.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentImage == index
                                          ? MyTheme.font_grey
                                          : Colors.grey.withOpacity(0.2),
                                    ),
                                  ))),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      );
    }
  }

  Widget divider() {
    return Container(
      color: MyTheme.light_grey,
      height: 5,
    );
  }

  String makeHtml(String string) {
    return """
<!DOCTYPE html>
<html>

<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="${AppConfig.RAW_BASE_URL}/public/assets/css/vendors.css">
  <style>
  *{
  margin:0 !important;
  padding:0 !important;
  }

    #scaled-frame {
    }
  </style>
</head>

<body id="main_id">
  <div id="scaled-frame">
$string
  </div>
</body>

</html>
""";
  }
}
