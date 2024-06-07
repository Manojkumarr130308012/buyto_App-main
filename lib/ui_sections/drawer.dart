import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';

import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';

import '../custom/toast_component.dart';
import '../data_model/user_info_response.dart';
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';
import '../screens/common_webview_screen.dart';
import '../screens/filter.dart';
import '../screens/followed_sellers.dart';
import '../screens/top_selling_products.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  void initState() {
    super.initState();
    fetchCustomerInfo();
  }

  UserInfoResponse? userInfoResponse;
  bool _isLoading = false;
  String? _profileName = 'User Name';
  String? _profileMobile = 'Mobile Number';
  String? _profileImage;

  fetchCustomerInfo() async {
    setState(() {
      _isLoading = true;
    });

    userInfoResponse = await ProfileRepository().getUserInfoResponse();
    _profileName = userInfoResponse?.data?[0].name;
    _profileMobile = userInfoResponse?.data?[0].phone;
    _profileImage = userInfoResponse?.data?[0].avatar;


    setState(() {
      _isLoading = false;
    });
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();

    var logoutResponse = await AuthRepository().getLogoutResponse();

    if (logoutResponse.result == true) {
      // ToastComponent.showDialog(logoutResponse.message, context,
      //     gravity: Toast.center, duration: Toast.lengthLong);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.only(top: 40),
          color: MyTheme.white.withOpacity(0.1),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                is_logged_in.$ == true
                    ? ListTile(
                        tileColor: MyTheme.accent_color,
                        leading: CircleAvatar(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: "${_profileImage?? 'https://buyto.in/admin/public/assets/img/placeholder.jpg'}",
                              fit: BoxFit.fill,
                            )),
                        title: Text(
                          "${_profileName}",
                          style: (TextStyle(
                              color: MyTheme.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSans',
                              fontSize: 13)),
                        ),
                        subtitle: Text(
                          "${_profileMobile}",
                          style: (TextStyle(
                              color: MyTheme.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSans',
                              fontSize: 13)),
                          //if user email is not available then check user phone if user phone is not available use empty string
                          // "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                        ))
                    : Text(
                        AppLocalizations.of(context)!.not_logged_in_ucf,
                        style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ListTile(
                    visualDensity: VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    leading: Image.asset("assets/home.png",
                        height: 20, color: MyTheme.accent_color),
                    title: Text(AppLocalizations.of(context)!.home_ucf,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                    }),
                Divider(),
                is_logged_in.$ == true
                    ? Column(
                        children: [
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/profile.png",
                                  height: 20, color: MyTheme.accent_color),
                              title: Text(
                                  AppLocalizations.of(context)!.profile_ucf,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Profile(show_back_button: true);
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/order.png",
                                  height: 20, color: MyTheme.accent_color),
                              title: Text(
                                  AppLocalizations.of(context)!.orders_ucf,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return OrderList(from_checkout: false);
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/heart.png",
                                  height: 20, color: MyTheme.accent_color),
                              title: Text(
                                  AppLocalizations.of(context)!.my_wishlist_ucf,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Wishlist();
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/products.png",
                                  height: 20, color: MyTheme.accent_color),
                              title: Text(
                                  AppLocalizations.of(context)!
                                      .top_selling_products_ucf,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return TopSellingProducts();
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/shop.png",
                                  height: 20, color: MyTheme.accent_color),
                              title: Text(
                                  AppLocalizations.of(context)!
                                      .browse_all_sellers_ucf,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Filter(
                                    selected_filter: "sellers",
                                  );
                                }));
                              }),
                          Divider(),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/follow_seller.png",
                                  height: 20, color: MyTheme.accent_color),
                              title: Text(
                                  AppLocalizations.of(context)!
                                      .followed_sellers_ucf,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FollowedSellers();
                                }));
                              }),
                          Divider(),
                          wallet_system_status.$
                              ? ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  leading: Image.asset("assets/wallet.png",
                                      height: 20, color: MyTheme.accent_color),
                                  title: Text(
                                      AppLocalizations.of(context)!.wallet_ucf,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'NotoSans',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Wallet();
                                    }));
                                  })
                              : Container(),
                        ],
                      )
                    : Container(),
                Divider(height: 24),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/terms.png",
                        height: 20, color: MyTheme.accent_color),
                    title: Text('Terms & Conditions',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommonWebviewScreen(
                                    page_name: "Terms Conditions",
                                    url:
                                        "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                  )));
                    }),
                Divider(),
                is_logged_in.$ == false
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/login.png",
                            height: 20, color: MyTheme.accent_color),
                        title: Text(AppLocalizations.of(context)!.login_ucf,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'NotoSans')),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                      )
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/logout.png",
                            height: 20, color: MyTheme.accent_color),
                        title: Text(AppLocalizations.of(context)!.logout_ucf,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 14)),
                        onTap: () {
                          onTapLogout(context);
                        })
                    : Container(),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
