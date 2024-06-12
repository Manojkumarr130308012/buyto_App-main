import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/aiz_image.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/price_category.dart';
import 'package:active_ecommerce_flutter/screens/products_category_id.dart';
import 'package:active_ecommerce_flutter/screens/sandles_category.dart';
import 'package:active_ecommerce_flutter/screens/seller_from_market.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_sellers.dart';
import 'package:active_ecommerce_flutter/ui_elements/mini_product_card.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../custom/common_functions.dart';
import '../presenter/cart_counter.dart';
import '../ui_sections/drawer.dart';
import 'cart.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
    this.title,
    this.show_back_button = false,
    go_back = true,
  }) : super(key: key);

  final String? title;
  bool show_back_button;
  late bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HomePresenter homeData = HomePresenter();
  static const List<String> list = <String>['Footwear', 'Apparel'];
  late String dropdownValue = "Footwear";

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      change();
    });
    // TODO: implement initState
    super.initState();
  }

  change() {
    homeData.onRefresh();
    homeData.mainScrollListener();
    homeData.initPiratedAnimation(this);
  }

  @override
  void dispose() {
    homeData.pirated_logo_controller.dispose();
    // ChangeNotifierProvider<HomePresenter>.value(value: value);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      key: _scaffoldKey,
      onWillPop: () async {
        CommonFunctions(context).appExitDialog();
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
            key: homeData.scaffoldKey,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.sizeOf(context).height / 6.5),
              child: AppBar(
                backgroundColor: MyTheme.accent_color,
                actions: [
                  Container(
                    width: MediaQuery.sizeOf(context).width / 2.15,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                          color: MyTheme.golden_shadow, // Set border color
                          width: 1.0), // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(25.0)), // Set rounded corner radius
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        dropdownColor: MyTheme.accent_color,
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'NotoSans'),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
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
                                height: MediaQuery.sizeOf(context).height / 2,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/buyto_without_bg.png",
                                          height: MediaQuery.sizeOf(context)
                                                  .height /
                                              16,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  6,
                                        ),
                                        Text(
                                          "Customer Support",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'NotoSans'),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            size: 24,
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            try {
                                              launch('tel:${8015027280}');
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 20.0,
                                                top: 20.0,
                                                bottom: 20),
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2.35,
                                            decoration: BoxDecorations
                                                .buildBoxDecoration_1(),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Container(
                                                      height: 48,
                                                      width: 48,
                                                      child: Image.asset(
                                                          "assets/phone.png")),
                                                ),
                                                Text("Call to Us",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: MyTheme
                                                            .accent_color,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                SizedBox(height: 20)
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        InkWell(
                                          onTap: () {
                                            var whatsappUrl = Uri.parse(
                                                "whatsapp://send?phone=${"+91" + "8015027280"}" +
                                                    "&text=${Uri.encodeComponent("Your Message Here")}");
                                            try {
                                              launchUrl(whatsappUrl);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 20.0,
                                                top: 20.0,
                                                bottom: 20),
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2.35,
                                            decoration: BoxDecorations
                                                .buildBoxDecoration_1(),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Container(
                                                      height: 48,
                                                      width: 48,
                                                      child: Image.asset(
                                                          "assets/whatsapp.png")),
                                                ),
                                                Text("Message to Us",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: MyTheme
                                                            .accent_color,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                SizedBox(height: 20)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 30.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              "Office Time : 10:00 AM to 07:00 PM",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
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
                      width: 40,
                      height: 45,
                      child: Container(
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
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/support.png",
                                  color: MyTheme.white,
                                  height: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print('Notification');
                    },
                    child: Container(
                      // decoration:
                      // BoxDecorations.buildCircularButtonDecoration_2(),
                      width: 45,
                      height: 45,
                      // padding: EdgeInsets.only(top:10, left: 8, right: 8, bottom: 8),
                      child: Center(
                        child: badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: MyTheme.accent_color,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          badgeAnimation: badges.BadgeAnimation.slide(
                            toAnimate: true,
                          ),
                          stackFit: StackFit.loose,
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/bell.png",
                                  color: MyTheme.white,
                                  height: 20,
                                ),
                              ),
                              Positioned(
                                  right: 6,
                                  child: Consumer<CartCounter>(
                                    builder: (context, cart, child) {
                                      return Column(
                                        children: [
                                          Text(
                                            // "${cart.cartCounter}",
                                            "0",
                                            textScaleFactor: 0.6,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: MyTheme.white,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Cart(has_bottomnav: false);
                        })).then((value) {
                          // onPopped(value);
                        });
                      },
                      child: Container(
                        // decoration:
                        //     BoxDecorations.buildCircularButtonDecoration_2(),
                        width: 45,
                        height: 45,
                        child: Center(
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
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.asset(
                                    "assets/cart.png",
                                    color: MyTheme.white,
                                    height: 20,
                                  ),
                                ),
                                Positioned(
                                    right: 3,
                                    child: Consumer<CartCounter>(
                                      builder: (context, cart, child) {
                                        return Column(
                                          children: [
                                            Text(
                                              "${cart.cartCounter}",
                                              textScaleFactor: 0.6,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: MyTheme.white,
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height / 8.5,
                        bottom: 10,
                        left: 10,
                        right: 15),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Filter();
                          }));
                        },
                        child: buildHomeSearchBox(context))),
                iconTheme: IconThemeData(
                    color: Colors.white, size: 30), //add this line here
              ),
            ),
            drawer: MainDrawer(),
            body: ListenableBuilder(
                listenable: homeData,
                builder: (context, child) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        color: MyTheme.accent_color,
                        backgroundColor: Colors.white,
                        onRefresh: homeData.onRefresh,
                        displacement: 0,
                        child: CustomScrollView(
                          controller: homeData.mainScrollController,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate([
                                AppConfig.purchase_code == ""
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          9.0,
                                          16.0,
                                          9.0,
                                          0.0,
                                        ),
                                        child: Container(
                                          height: 140,
                                          color: Colors.black,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  left: 20,
                                                  top: 0,
                                                  child: AnimatedBuilder(
                                                      animation: homeData
                                                          .pirated_logo_animation,
                                                      builder:
                                                          (context, child) {
                                                        return Image.asset(
                                                          "assets/pirated_square.png",
                                                          height: homeData
                                                              .pirated_logo_animation
                                                              .value,
                                                          color: Colors.white,
                                                        );
                                                      })),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                buildHomeCarouselSlider(context, homeData),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    0.0,
                                    18.0,
                                    0.0,
                                  ),
                                  child: buildHomeMenuRow1(context, homeData),
                                ),
                                buildHomeBannerOne(context, homeData),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    0.0,
                                    18.0,
                                    0.0,
                                  ),
                                  child: buildHomeMenuRow2(context),
                                ),
                              ]),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0,
                                      bottom: 20.0,
                                      left: 18.0,
                                      right: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .featured_categories_ucf,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NotoSans',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                // height: MediaQuery.sizeOf(context).height / 5.2,
                                child: buildHomeFeaturedCategories(
                                    context, homeData),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    20.0,
                                    18.0,
                                    0.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Seller From Market",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NotoSans',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                child: buildHomeSellerMarketCategories(
                                    context, homeData),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    20.0,
                                    18.0,
                                    0.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price Category",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NotoSans',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                child:
                                    buildHomePriceCategories(context, homeData),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    20.0,
                                    18.0,
                                    0.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Slipers Category",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NotoSans',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                child: buildHomeSliperCollectionCategories(
                                    context, homeData),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    20.0,
                                    18.0,
                                    0.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sandles Category",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NotoSans',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  color: MyTheme.light_grey.withOpacity(0.5),
                                  child: buildHomeSandlesCollectionCategories(
                                      context, homeData),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    20.0,
                                    18.0,
                                    0.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Shoes Category",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'NotoSans',
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                child: Container(
                                  color: MyTheme.light_grey,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: buildHomeShoesCollectionCategories(
                                      context, homeData),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  color: MyTheme.accent_color_shadow,
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0,
                                                right: 18.0,
                                                left: 18.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .featured_products_ucf,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          buildHomeFeatureProductHorizontalList(
                                              homeData)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18.0,
                                    18.0,
                                    20.0,
                                    0.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .all_products_ucf,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      buildHomeAllProducts2(context, homeData),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          color: Colors.white,
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  20,
                                          child: TextButton.icon(
                                            style: TextButton.styleFrom(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'NotoSans',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                              backgroundColor:
                                                  MyTheme.accent_color,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onPressed: () => {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return Filter();
                                              })).then((value) {
                                                // onPopped(value);
                                              }),
                                            },
                                            icon: Text(
                                              'View All',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'NotoSans',
                                              ),
                                            ),
                                            label: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 100),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  Widget buildHomeAllProducts(context, HomePresenter homeData) {
    if (homeData.isAllProductInitial && homeData.allProductList.length == 0) {
      // print(homeData.allProductList);
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.allProductScrollController));
    } else if (homeData.allProductList.length > 0) {
      //snapshot.hasData

      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: homeData.allProductList.length,
        controller: homeData.allProductScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.618),
        padding: EdgeInsets.all(16.0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
              id: homeData.allProductList[index].id,
              image: homeData.allProductList[index].thumbnail_image,
              category_name: homeData.allProductList[index].new_category_name,
              brand_name: homeData.allProductList[index].new_brand_name,
              name: homeData.allProductList[index].name,
              main_price: homeData.allProductList[index].main_price,
              stroked_price: homeData.allProductList[index].stroked_price,
              has_discount: homeData.allProductList[index].has_discount,
              discount: homeData.allProductList[index].discount,
              margin: homeData.allProductList[index].margin,
              mrp: homeData.allProductList[index].mrp,
              moq: homeData.allProductList[index].moq,
              unit_name: homeData.allProductList[index].unit_name,
              color_code: homeData.allProductList[index].color_code);
        },
      );
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeAllProducts2(context, HomePresenter homeData) {
    if (homeData.isAllProductInitial && homeData.allProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.allProductScrollController));
    } else if (homeData.allProductList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: homeData.allProductList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 10, left: 18, right: 18),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ProductCard(
                id: homeData.allProductList[index].id,
                image: homeData.allProductList[index].thumbnail_image,
                name: homeData.allProductList[index].name,
                brand_name: homeData.allProductList[index].new_brand_name,
                category_name: homeData.allProductList[index].new_category_name,
                main_price: homeData.allProductList[index].main_price,
                stroked_price: homeData.allProductList[index].stroked_price,
                has_discount: homeData.allProductList[index].has_discount,
                discount: homeData.allProductList[index].discount,
                margin: homeData.allProductList[index].margin,
                mrp: homeData.allProductList[index].mrp,
                moq: homeData.allProductList[index].moq,
                unit_name: homeData.allProductList[index].unit_name,
                is_wholesale: homeData.allProductList[index].isWholesale,
                gender: homeData.allProductList[index].gender,
                color_code: homeData.allProductList[index].color_code);
          });
    } else if (homeData.totalAllProductData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeFeaturedCategories(context, HomePresenter homeData) {
    if (homeData.isCategoryInitial &&
        homeData.featuredCategoryList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.featuredCategoryScrollController));
    } else if (homeData.featuredCategoryList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: homeData.featuredCategoryList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 0.0, bottom: 20, left: 15, right: 15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CategoryProducts(
                      category_id: homeData.featuredCategoryList[index].id,
                      category_name: homeData.featuredCategoryList[index].name,
                    );
                  }));
                },
                child: Container(
                    decoration:
                        BoxDecorations.buildCircularButtonDecoration_4(),
                    child: Column(
                      children: [
                        Row(children: <Widget>[
                          Container(
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.png',
                                    image: homeData
                                        .featuredCategoryList[index].banner,
                                    width: MediaQuery.sizeOf(context).width / 5,
                                    height:
                                        MediaQuery.sizeOf(context).height / 9,
                                    fit: BoxFit.cover,
                                  ))),
                        ]),
                        SizedBox(height: 10),
                        Text(
                          homeData.featuredCategoryList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                      ],
                    )));
          });
    } else if (homeData.featuredCategoryList == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeShoesCollectionCategories(context, HomePresenter homeData) {
    if (homeData.isShoesCategoryInitial &&
        homeData.shoesCollectionCategoryList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.shoesCollectionScrollController));
    } else if (homeData.shoesCollectionCategoryList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: homeData.shoesCollectionCategoryList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 15, right: 15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductCategoryById(
                      category_id:
                          homeData.shoesCollectionCategoryList[index].id,
                      category_name:
                          homeData.shoesCollectionCategoryList[index].name,
                    );
                  }));
                },
                child: Container(
                    decoration:
                        BoxDecorations.buildCircularButtonDecoration_4(),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/placeholder.png',
                                          image: homeData
                                              .shoesCollectionCategoryList[
                                                  index]
                                              .banner,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  4.5,
                                          height: MediaQuery.sizeOf(context)
                                                  .height /
                                              9.5,
                                          fit: BoxFit.cover,
                                        ))),
                              ),
                            ]),
                        SizedBox(height: 10),
                        Text(
                          homeData.shoesCollectionCategoryList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                      ],
                    )));
          });
    } else if (homeData.shoesCollectionCategoryList == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeSellerMarketCategories(context, HomePresenter homeData) {
    if (homeData.issellerMarketCategoryInitial &&
        homeData.sellerMarketCategoryList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.sellerMarketCategoryScrollController));
    } else if (homeData.sellerMarketCategoryList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: homeData.sellerMarketCategoryList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 15, right: 15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SellerFromMarket(
                        sellerId: homeData.sellerMarketCategoryList[index].id);
                  }));
                },
                child: Container(
                    decoration:
                        BoxDecorations.buildCircularButtonDecoration_4(),
                    child: Column(
                      children: [
                        Row(children: <Widget>[
                          Container(
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.png',
                                    image: homeData
                                        .sellerMarketCategoryList[index].logo,
                                    width:
                                        MediaQuery.sizeOf(context).width / 2.29,
                                    height:
                                        MediaQuery.sizeOf(context).height / 6,
                                    fit: BoxFit.cover,
                                  ))),
                        ]),
                        SizedBox(height: 10),
                        Text(
                          homeData.sellerMarketCategoryList[index].market_name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                      ],
                    )));
          });
    } else if (homeData.sellerMarketCategoryList == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomePriceCategories(context, HomePresenter homeData) {
    if (homeData.isPriceCategoryInitial &&
        homeData.priceCategoryList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.featuredCategoryScrollController));
    } else if (homeData.priceCategoryList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          itemCount: homeData.priceCategoryList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 15, right: 15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PriceCategory(
                        priceId: homeData.priceCategoryList[index].id);
                  }));
                },
                child: Container(
                    // decoration:
                    // BoxDecorations.buildCircularButtonDecoration_4(),
                    color: MyTheme.accent_color.withOpacity(0.1),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.png',
                                    image:
                                        homeData.priceCategoryList[index].logo,
                                    width:
                                        MediaQuery.sizeOf(context).width / 2.29,
                                    height:
                                        MediaQuery.sizeOf(context).height / 6,
                                    fit: BoxFit.cover,
                                  )),
                              // Image.asset(
                              //   homeData.priceCategoryList[index].logo,
                              //   width: MediaQuery.sizeOf(context).width / 3.5,
                              //   height:
                              //       MediaQuery.sizeOf(context).height / 6.25,
                              //   fit: BoxFit.contain,
                              //   color: MyTheme.accent_color_shadow
                              //       .withOpacity(0.95),
                              // ),
                              // Container(
                              //   padding: EdgeInsets.only(bottom: 20),
                              //   child: Column(
                              //     children: [
                              //       Text(
                              //         "Price ₹",
                              //         textAlign: TextAlign.left,
                              //         overflow: TextOverflow.ellipsis,
                              //         maxLines: 3,
                              //         softWrap: true,
                              //         style: TextStyle(
                              //             fontSize: 10,
                              //             color: MyTheme.white,
                              //             fontFamily: 'NotoSans',
                              //             fontWeight: FontWeight.w600),
                              //       ),
                              //       SizedBox(height: 10),
                              //       Text(
                              //         homeData.priceCategoryList[index]
                              //             .price_category,
                              //         textAlign: TextAlign.left,
                              //         overflow: TextOverflow.ellipsis,
                              //         maxLines: 3,
                              //         softWrap: true,
                              //         style: TextStyle(
                              //             fontSize: 13,
                              //             color: MyTheme.white,
                              //             fontFamily: 'NotoSans',
                              //             fontWeight: FontWeight.w700),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    )));
          });
    } else if (homeData.priceCategoryList == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeSandlesCollectionCategories(context, HomePresenter homeData) {
    if (homeData.issandlesCollectionCategoryInitial &&
        homeData.sandlesCollectionCategoryList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.sellerMarketCategoryScrollController));
    } else if (homeData.sandlesCollectionCategoryList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: homeData.sandlesCollectionCategoryList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 15, right: 15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductCategoryById(
                      category_id:
                          homeData.sandlesCollectionCategoryList[index].id,
                      category_name:
                          homeData.sandlesCollectionCategoryList[index].name,
                    );
                  }));
                },
                child: Container(
                    // color: Colors.red,
                    decoration:
                        BoxDecorations.buildCircularButtonDecoration_7(),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/placeholder.png',
                                          image: homeData
                                              .sandlesCollectionCategoryList[
                                                  index]
                                              .logo,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  4.5,
                                          height: MediaQuery.sizeOf(context)
                                                  .height /
                                              9.5,
                                          fit: BoxFit.cover,
                                        ))),
                              ),
                            ]),
                        SizedBox(height: 10),
                        Text(
                          homeData.sandlesCollectionCategoryList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                      ],
                    )));
          });
    } else if (homeData.sandlesCollectionCategoryList == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeSliperCollectionCategories(context, HomePresenter homeData) {
    if (homeData.isSliperCategoryInitial &&
        homeData.sliperCollectionCategoryList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData.sliperCategoryScrollController));
    } else if (homeData.sliperCollectionCategoryList.length > 0) {
      return MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: homeData.sliperCollectionCategoryList.length,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 15, right: 15),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductCategoryById(
                      category_id:
                          homeData.sliperCollectionCategoryList[index].id,
                      category_name:
                          homeData.sliperCollectionCategoryList[index].name,
                    );
                  }));
                },
                child: Container(
                    decoration:
                        BoxDecorations.buildCircularButtonDecoration_6(),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/placeholder.png',
                                          image: homeData
                                              .sliperCollectionCategoryList[
                                                  index]
                                              .banner,
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  4.5,
                                          height: MediaQuery.sizeOf(context)
                                                  .height /
                                              8.5,
                                          fit: BoxFit.cover,
                                        ))),
                              ),
                            ]),
                        SizedBox(height: 5),
                        Text(
                          homeData.sliperCollectionCategoryList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 5),
                      ],
                    )));
          });
    } else if (homeData.sliperCollectionCategoryList == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Widget buildHomeFeatureProductHorizontalList(HomePresenter homeData) {
    if (homeData.isFeaturedProductInitial == true &&
        homeData.featuredProductList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 200.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 200.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 200.0,
                  width: (MediaQuery.of(context).size.width - 160) / 3)),
        ],
      );
    } else if (homeData.featuredProductList.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height / 2.2,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                homeData.fetchFeaturedProducts();
              }
              return true;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(18.0),
              separatorBuilder: (context, index) => SizedBox(
                width: 14,
              ),
              itemCount: homeData.totalFeaturedProductData! >
                      homeData.featuredProductList.length
                  ? homeData.featuredProductList.length + 1
                  : homeData.featuredProductList.length,
              scrollDirection: Axis.horizontal,
              //itemExtent: 135,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return (index == homeData.featuredProductList.length)
                    ? SpinKitFadingFour(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    : MiniProductCard(
                        id: homeData.featuredProductList[index].id,
                        image:
                            homeData.featuredProductList[index].thumbnail_image,
                        name: homeData.featuredProductList[index].name,
                        brand_name:
                            homeData.featuredProductList[index].new_brand_name,
                        category_name: homeData
                            .featuredProductList[index].new_category_name,
                        margins: homeData.featuredProductList[index].margin,
                        mrp: homeData.featuredProductList[index].mrp,
                        moq: homeData.featuredProductList[index].moq,
                        unit_name:
                            homeData.featuredProductList[index].unit_name,
                        main_price:
                            homeData.featuredProductList[index].main_price,
                        stroked_price:
                            homeData.featuredProductList[index].stroked_price,
                        has_discount:
                            homeData.featuredProductList[index].has_discount,
                        is_wholesale:
                            homeData.featuredProductList[index].isWholesale,
                        discount: homeData.featuredProductList[index].discount,
                        gender: homeData.featuredProductList[index].gender,
                        color_code:
                            homeData.featuredProductList[index].color_code);
              },
            ),
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

  Widget buildHomeMenuRow1(BuildContext context, HomePresenter homeData) {
    return Row(
      children: [
        if (homeData.isTodayDeal)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TodaysDealProducts();
                }));
              },
              child: Container(
                height: 90,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/todays_deal.png")),
                    ),
                    Text(AppLocalizations.of(context)!.todays_deal_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          ),
        if (homeData.isTodayDeal && homeData.isFlashDeal) SizedBox(width: 14.0),
        if (homeData.isFlashDeal)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FlashDealList();
                }));
              },
              child: Container(
                height: 90,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/flash_deal.png")),
                    ),
                    Text(AppLocalizations.of(context)!.flash_deal_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget buildHomeMenuRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /* Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoryList(
                  is_top_category: true,
                );
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/top_categories.png")),
                  ),
                  Text(
                    AppLocalizations.of(context).home_screen_top_categories,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(132, 132, 132, 1),
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ),
        ),*/
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  selected_filter: "brands",
                );
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 28,
                        width: 28,
                        child: Image.asset("assets/brands.png")),
                  ),
                  Text(AppLocalizations.of(context)!.brands_ucf,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'NotoSans',
                          fontSize: 14)),
                ],
              ),
            ),
          ),
        ),
        if (vendor_system.$)
          SizedBox(
            width: 10,
          ),
        if (vendor_system.$)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TopSellers();
                }));
              },
              child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width / 3 - 4,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 28,
                          width: 28,
                          child: Image.asset("assets/top_sellers.png")),
                    ),
                    Text(AppLocalizations.of(context)!.top_sellers_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSans',
                            fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildHomeCarouselSlider(context, HomePresenter homeData) {
    if (homeData.isCarouselInitial && homeData.carouselImageList.length == 0) {
      return Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 20),
          child: ShimmerHelper().buildBasicShimmer(height: 110));
    } else if (homeData.carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 400 / 220,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInExpo,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              homeData.incrementCurrentSlider(index);
            }),
        items: homeData.carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 18, top: 10, bottom: 20),
                child: Stack(
                  children: <Widget>[
                    Container(
                        //color: Colors.amber,
                        width: double.infinity,
                        height: 180,
                        //decoration: BoxDecorations.buildBoxDecoration_1(),
                        child: AIZImage.radiusImage(i, 6)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: homeData.carouselImageList.map((url) {
                          int index = homeData.carouselImageList.indexOf(url);
                          return Container(
                            width: 7.0,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: homeData.current_slider == index
                                  ? MyTheme.white
                                  : Color.fromRGBO(112, 112, 112, .3),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      );
    } else if (!homeData.isCarouselInitial &&
        homeData.carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  Widget buildHomeBannerOne(context, HomePresenter homeData) {
    if (homeData.isBannerOneInitial &&
        homeData.bannerOneImageList.length == 0) {
      return Padding(
          padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
          child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (homeData.bannerOneImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$!
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 2.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: .85,
              initialPage: 0,
              padEnds: false,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              onPageChanged: (index, reason) {
                // setState(() {
                //   homeData.current_slider = index;
                // });
              }),
          items: homeData.bannerOneImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 0.0, bottom: 10),
                  child: Container(
                    //color: Colors.amber,
                    width: double.infinity,
                    child: AIZImage.radiusImage(i, 6),
                  ),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!homeData.isBannerOneInitial &&
        homeData.bannerOneImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  Widget buildHomeBannerTwo(context, HomePresenter homeData) {
    if (homeData.isBannerTwoInitial &&
        homeData.bannerTwoImageList.length == 0) {
      return Padding(
          padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
          child: ShimmerHelper().buildBasicShimmer(height: 110));
    } else if (homeData.bannerTwoImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$!
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: 0.7,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInExpo,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                // setState(() {
                //   homeData.current_slider = index;
                // });
              }),
          items: homeData.bannerTwoImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 20.0, bottom: 10),
                  child: Container(
                      width: double.infinity,
                      child: AIZImage.radiusImage(i, 6)),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!homeData.isCarouselInitial &&
        homeData.carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeSearchBox(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.sizeOf(context).width - 10,
      decoration: BoxDecorations.buildBoxDecoration_2(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.search_anything,
              style: TextStyle(
                fontSize: 14.0,
                color: MyTheme.textfield_grey,
                fontFamily: 'NotoSans',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.search,
                color: MyTheme.textfield_grey,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHomeSoleCategories(context, HomePresenter homeData) {
    if (homeData.isSoleCategoryInitial &&
        homeData.soleCategoryList.length == 0) {
      return ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 14.0,
          item_count: 10,
          mainAxisExtent: 170.0,
          controller: homeData.featuredCategoryScrollController);
    } else if (homeData.soleCategoryList.length > 0) {
      //snapshot.hasData
      return GridView.builder(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
          scrollDirection: Axis.horizontal,
          controller: homeData.featuredCategoryScrollController,
          itemCount: homeData.soleCategoryList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 170.0),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CategoryProducts(
                    category_id: homeData.featuredCategoryList[index].id,
                    category_name: homeData.soleCategoryList[index].name,
                    // logo: homeData.soleCategoryList[index].logo,
                  );
                }));
              },
              child: Container(
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Row(
                  children: <Widget>[
                    Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(6), right: Radius.zero),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image:
                                  homeData.featuredCategoryList[index].banner,
                              fit: BoxFit.cover,
                            ))),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          homeData.soleCategoryList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14,
                              color: MyTheme.font_grey,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else if (!homeData.isSoleCategoryInitial &&
        homeData.soleCategoryList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_category_found,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  Container buildProductLoadingContainer(HomePresenter homeData) {
    return Container(
      height: homeData.showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
            homeData.totalAllProductData == homeData.allProductList.length
                ? AppLocalizations.of(context)!.no_more_products_ucf
                : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }
}
