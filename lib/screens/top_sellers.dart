import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/shop_repository.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';
import 'package:active_ecommerce_flutter/ui_elements/shop_square_card.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../custom/box_decorations.dart';
import '../data_model/shop_response.dart';
import '../presenter/cart_counter.dart';

class TopSellers extends StatefulWidget {
  const TopSellers({super.key});

  @override
  State<TopSellers> createState() => _TopSellersState();
}

class _TopSellersState extends State<TopSellers> {
  ScrollController? _scrollController;
  List<Shop> topSellers = [];
  bool isInit = false;
  bool _isInWishList = false;

  getTopSellers() async {
    ShopResponse response = await ShopRepository().topSellers();
    isInit = true;
    if (response.shops != null) {
      topSellers.addAll(response.shops!);
    }

    setState(() {});
  }

  clearAll() {
    isInit = false;
    topSellers.clear();
    setState(() {});
  }

  Future<void> onRefresh() async {
    clearAll();

    return await getTopSellers();
  }

  onPopped(value) async {
    onRefresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    getTopSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: buildTopSellerList(context)),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
      // centerTitle: true,
      leading: UsefulElements.backButton(context),
      title: Text(
        LangText(context).local.top_sellers_ucf,
        style: TextStyle(
            fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        SizedBox(width: 15),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Wishlist();
            }));
          },
          child: Container(
            decoration: BoxDecorations.buildCircularButtonDecoration_1(),
            width: 36,
            height: 36,
            child: Center(
              child: Icon(
                Icons.favorite,
                color: _isInWishList
                    ? Color.fromRGBO(230, 46, 4, 1)
                    : MyTheme.accent_color,
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
            decoration: BoxDecorations.buildCircularButtonDecoration_1(),
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
                color: MyTheme.accent_color,
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
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildTopSellerList(context) {
    if (isInit) {
      //print(productResponse.toString());
      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: topSellers.length,
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.7),
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 18, right: 18),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ShopSquareCard(
            id: topSellers[index].id,
            image: topSellers[index].logo,
            name: topSellers[index].name,
            stars: double.parse(topSellers[index].rating.toString()),
          );
        },
      );
    } else {
      return ShimmerHelper()
          .buildSquareGridShimmer(scontroller: _scrollController);
    }
  }
}
