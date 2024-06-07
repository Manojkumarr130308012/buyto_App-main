import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/style.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/followed_sellers_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/shop_repository.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../presenter/cart_counter.dart';
import '../ui_elements/product_card.dart';
import 'package:badges/badges.dart' as badges;

class PriceCategory extends StatefulWidget {
  PriceCategory({Key? key, this.priceId}) : super(key: key);

  int? priceId;
  @override
  State<PriceCategory> createState() => _PriceCategoryState();
}

class _PriceCategoryState extends State<PriceCategory> {
  ScrollController _scrollController = ScrollController();
  List<dynamic> _productList = [];
  int? _totalData = 0;
  bool _isInWishList = false;
  int _page = 1;

  Future fetchPriceCategoryData() async {
    var ProductCategoryResponse = await ProductRepository()
        .getPriceCategory(id: widget.priceId, page: _page);

    setState(() {
      _productList.addAll(ProductCategoryResponse.products!);
    });

    print("nandhakumar");
  }

  @override
  void initState() {
    fetchPriceCategoryData();
    super.initState();

    _scrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        // _showLoadingContainer = true;
        fetchPriceCategoryData();
      }
    });
  }

  Future<void> _onRefresh() async {
    // reset();
    fetchPriceCategoryData();
  }

  onPopped(value) async {
    fetchPriceCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Price Category",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: MyTheme.white),
        ),
        backgroundColor: MyTheme.accent_color,
        iconTheme: IconThemeData(color: MyTheme.white),
        actions: [
          SizedBox(width: 15),
          InkWell(
            onTap: () {
              // onWishTap();
            },
            child: Container(
              width: 36,
              height: 36,
              child: Center(
                child: Icon(
                  Icons.favorite,
                  color: _isInWishList
                      ? Color.fromRGBO(230, 46, 4, 1)
                      : MyTheme.white,
                  size: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Cart(has_bottomnav: false);
              })).then((value) {
                onPopped(value);
              });
            },
            child: Container(
              width: 36,
              height: 36,
              padding: EdgeInsets.all(8),
              child: badges.Badge(
                badgeAnimation: badges.BadgeAnimation.slide(
                  toAnimate: true,
                ),
                stackFit: StackFit.loose,
                child: Image.asset(
                  "assets/cart.png",
                  color: MyTheme.white,
                  height: 24,
                ),
                badgeContent: Consumer<CartCounter>(
                  builder: (context, cart, child) {
                    return Text(
                      "${cart.cartCounter}",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 15)
        ],
      ),
      // body: RefreshIndicator(
      //   onRefresh: () {
      //     //  clearData();
      //     return reset();
      //   },
      //   child: SingleChildScrollView(
      //     physics: AlwaysScrollableScrollPhysics(),
      //     child: bodyContainer(),
      //   ),
      // ),
      body: buildProductList(),
    );
  }

  buildProductList() {
    if (_productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            itemCount: _productList.length,
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // 3
              return ProductCard(
                  id: _productList[index].id,
                  image: _productList[index].thumbnail_image,
                  name: _productList[index].name,
                  main_price: _productList[index].main_price,
                  stroked_price: _productList[index].stroked_price,
                  discount: _productList[index].discount,
                  is_wholesale: _productList[index].isWholesale,
                  category_name: _productList[index].new_category_name,
                  brand_name: _productList[index].new_brand_name,
                  margin: _productList[index].margin,
                  mrp: _productList[index].mrp,
                  moq: _productList[index].moq,
                  unit_name: _productList[index].unit_name,
                  gender: _productList[index].gender,
                  has_discount: _productList[index].has_discount,
                  color_code: _productList[index].color_code);
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_data_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  // Widget bodyContainer() {
  //   if (_isShopsInitial) {
  //     if (sellers.isNotEmpty)
  //       return GridView.builder(
  //         // 2
  //         //addAutomaticKeepAlives: true,
  //         itemCount: sellers.length,
  //         controller: _scrollController,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             crossAxisSpacing: 14,
  //             mainAxisSpacing: 14,
  //             childAspectRatio: 0.7),
  //         padding: EdgeInsets.only(top: 20, bottom: 10, left: 18, right: 18),
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         itemBuilder: (context, index) {
  //           // 3
  //           return shopModel(sellers[index]);
  //         },
  //       );
  //     else
  //       return Container(
  //         height: DeviceInfo(context).height,
  //         child: Center(
  //           child: Text(LangText(context).local!.no_data_is_available),
  //         ),
  //       );
  //   } else {
  //     return buildShimmer();
  //   }
  // }

  // Widget shopModel(SellerInfo sellerInfo) {
  //   return Container(
  //     decoration: BoxDecorations.buildBoxDecoration_1(),
  //     child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           InkWell(
  //             onTap: () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                 return SellerDetails(
  //                   id: sellerInfo.shopId,
  //                 );
  //               }));
  //             },
  //             child: Container(
  //                 width: double.infinity,
  //                 height: 100,
  //                 child: ClipRRect(
  //                     borderRadius: BorderRadius.vertical(
  //                         top: Radius.circular(16), bottom: Radius.zero),
  //                     child: FadeInImage.assetNetwork(
  //                       placeholder: 'assets/placeholder.png',
  //                       image: sellerInfo.shopLogo!,
  //                       fit: BoxFit.scaleDown,
  //                       imageErrorBuilder: (BuildContext errorContext,
  //                           Object obj, StackTrace? st) {
  //                         return Image.asset('assets/placeholder.png');
  //                       },
  //                     ))),
  //           ),
  //           Container(
  //             child: Padding(
  //               padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
  //               child: Text(
  //                 sellerInfo.shopName!,
  //                 textAlign: TextAlign.left,
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 2,
  //                 style: TextStyle(
  //                     color: MyTheme.dark_font_grey,
  //                     fontSize: 13,
  //                     height: 1.6,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(bottom: 8.0),
  //             child: Container(
  //               height: 15,
  //               child: RatingBar(
  //                   ignoreGestures: true,
  //                   initialRating:
  //                       double.parse(sellerInfo.shopRating.toString()),
  //                   maxRating: 5,
  //                   direction: Axis.horizontal,
  //                   itemSize: 15.0,
  //                   itemCount: 5,
  //                   ratingWidget: RatingWidget(
  //                     full: Icon(
  //                       Icons.star,
  //                       color: Colors.amber,
  //                     ),
  //                     half: Icon(Icons.star_half),
  //                     empty: Icon(Icons.star,
  //                         color: Color.fromRGBO(224, 224, 225, 1)),
  //                   ),
  //                   onRatingUpdate: (newValue) {}),
  //             ),
  //           ),
  //           InkWell(
  //             onTap: () {
  //               removedFollow(sellerInfo.shopId);
  //             },
  //             child: Container(
  //               child: Padding(
  //                 padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
  //                 child: Text(
  //                   LangText(context).local!.unfollow_ucf,
  //                   textAlign: TextAlign.left,
  //                   overflow: TextOverflow.ellipsis,
  //                   maxLines: 2,
  //                   style: TextStyle(
  //                       color: Color.fromRGBO(230, 46, 4, 1),
  //                       fontSize: 13,
  //                       height: 1.6,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           InkWell(
  //             onTap: () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                 return SellerDetails(
  //                   id: sellerInfo.shopId,
  //                 );
  //               }));
  //             },
  //             child: Container(
  //                 height: 23,
  //                 width: 103,
  //                 alignment: Alignment.center,
  //                 decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.amber),
  //                     color: MyTheme.amber,
  //                     borderRadius: BorderRadius.circular(6)),
  //                 child: Text(
  //                   "Visit Store",
  //                   style: TextStyle(
  //                       fontSize: 10,
  //                       color: Colors.amber.shade700,
  //                       fontWeight: FontWeight.w500),
  //                 )),
  //           )
  //         ]),
  //   );
  // }

  Widget buildShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
      itemCount: 18,
      padding: EdgeInsets.only(left: 18, right: 18),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecorations.buildBoxDecoration_1(),
          child: ShimmerHelper().buildBasicShimmer(),
        );
      },
    );
  }
}
