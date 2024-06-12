// import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
// import 'package:active_ecommerce_flutter/custom/btn.dart';
// import 'package:active_ecommerce_flutter/custom/enum_classes.dart';
// import 'package:active_ecommerce_flutter/custom/lang_text.dart';
// import 'package:active_ecommerce_flutter/custom/toast_component.dart';
// import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/system_config.dart';
// import 'package:active_ecommerce_flutter/my_theme.dart';
// import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
// import 'package:active_ecommerce_flutter/repositories/coupon_repository.dart';
// import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
// import 'package:active_ecommerce_flutter/screens/order_list.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/amarpay_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/bkash_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/flutterwave_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/iyzico_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/khalti_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/nagad_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/offline_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/online_pay.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/payfast_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/paypal_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/paystack_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/paytm_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/razorpay_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/sslcommerz_screen.dart';
// import 'package:active_ecommerce_flutter/screens/payment_method_screen/stripe_screen.dart';
// import 'package:active_ecommerce_flutter/screens/seller_details.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:toast/toast.dart';
//
// import '../custom/device_info.dart';
// import '../custom/my_separator.dart';
// import '../helpers/main_helpers.dart';
// import 'coupon_products.dart';
// import 'inhouse_products.dart';
// import 'order_detail_page.dart';
//
// class Checkout extends StatefulWidget {
//   int? order_id; // only need when making manual payment from order details
//   String list;
//   //final OffLinePaymentFor offLinePaymentFor;
//   final PaymentFor? paymentFor;
//   final double rechargeAmount;
//   final String? title;
//   var packageId;
//
//   Checkout(
//       {Key? key,
//       this.order_id = 0,
//       this.paymentFor,
//       this.list = "both",
//       //this.offLinePaymentFor,
//       this.rechargeAmount = 0.0,
//       this.title,
//       this.packageId = 0})
//       : super(key: key);
//
//   @override
//   _CheckoutState createState() => _CheckoutState();
// }
//
// class _CheckoutState extends State<Checkout> {
//   var _selected_payment_method_index = 0;
//   String? _selected_payment_method = "";
//   String? _selected_payment_method_key = "";
//
//   ScrollController _mainScrollController = ScrollController();
//   TextEditingController _couponController = TextEditingController();
//   var _paymentTypeList = [];
//   bool _isInitial = true;
//   String? _totalString = ". . .";
//   double? _grandTotalValue = 0.00;
//   String? _subTotalString = ". . .";
//   String? _taxString = ". . .";
//   String _shippingCostString = ". . .";
//   String? _discountString = ". . .";
//   String _used_coupon_code = "";
//   bool? _coupon_applied = false;
//   late BuildContext loadingcontext;
//   String payment_type = "cart_payment";
//   String? _title;
//   bool _dataFetch = false;
//   List<dynamic> _couponsList = [];
//   int? _totalData = 0;
//   bool _showLoadingContainer = false;
//   int _page = 1;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     /*print("user data");
//     print(is_logged_in.$);
//     print(access_token.value);
//     print(user_id.$);
//     print(user_name.$);*/
// fetchData();
//     fetchAll();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _mainScrollController.dispose();
//   }
//
//   fetchAll() {
//     fetchList();
//
//     if (is_logged_in.$ == true) {
//       if (widget.paymentFor != PaymentFor.Order) {
//         _grandTotalValue = widget.rechargeAmount;
//         payment_type = widget.paymentFor == PaymentFor.WalletRecharge
//             ? "wallet_payment"
//             : "customer_package_payment";
//       } else {
//         fetchSummary();
//       }
//     }
//   }
//
//   _selectGradient(index) {
//     if (index == 0 || (index + 1 > 3 && ((index + 1) % 3) == 1)) {
//       return MyTheme.buildLinearGradient1();
//     } else if (index == 1 || (index + 1 > 3 && ((index + 1) % 3) == 2)) {
//       return MyTheme.buildLinearGradient2();
//     } else if (index == 2 || (index + 1 > 3 && ((index + 1) % 3) == 0)) {
//       return MyTheme.buildLinearGradient3();
//     }
//   }
//
//   fetchData() async {
//     var couponRes = await CouponRepository().getCouponResponseList(page: _page);
//     _couponsList.addAll(couponRes.data!);
//     _totalData = couponRes.meta!.total;
//     _dataFetch = true;
//     _showLoadingContainer = false;
//     setState(() {});
//   }
//
//   RichText richText(BuildContext context, int index) {
//     return RichText(
//       text: TextSpan(
//         text: '${LangText(context).local.min_spend_ucf} ',
//         style: TextStyle(
//           fontSize: 12,
//         ),
//         children: [
//           TextSpan(
//             text:
//             '${convertPrice(_couponsList[index].couponDiscountDetails!.minBuy)}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//           ),
//           TextSpan(
//             text: ' ${LangText(context).local.from}',
//             style: TextStyle(
//               fontSize: 12,
//             ),
//           ),
//           TextSpan(
//             text: ' ${_couponsList[index].shopName}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//           ),
//           TextSpan(
//             text: ' ${LangText(context).local.store_to_get}',
//             style: TextStyle(
//               fontSize: 12,
//             ),
//           ),
//           TextSpan(
//             text:
//             ' ${_couponsList[index].discountType == "percent" ? _couponsList[index].discount.toString() + "%" : convertPrice(_couponsList[index].discount.toString())}',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           TextSpan(
//             text: ' ${LangText(context).local.off_on_total_orders}',
//             style: TextStyle(
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   itemSpacer({height = 15.0}) {
//     return SizedBox(
//       height: height,
//     );
//   }
//
//   fetchList() async {
//     var paymentTypeResponseList = await PaymentRepository()
//         .getPaymentResponseList(
//             list: widget.list,
//             mode: widget.paymentFor != PaymentFor.Order &&
//                     widget.paymentFor != PaymentFor.ManualPayment
//                 ? "wallet"
//                 : "order");
//     _paymentTypeList.addAll(paymentTypeResponseList);
//     if (_paymentTypeList.length > 0) {
//       _selected_payment_method = _paymentTypeList[0].payment_type;
//       _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
//     }
//     _isInitial = false;
//     setState(() {});
//   }
//
//   fetchSummary() async {
//     var cartSummaryResponse = await CartRepository().getCartSummaryResponse();
//
//     if (cartSummaryResponse != null) {
//       _subTotalString = cartSummaryResponse.sub_total;
//       _taxString = cartSummaryResponse.tax;
//       _shippingCostString = cartSummaryResponse.shipping_cost;
//       _discountString = cartSummaryResponse.discount;
//       _totalString = cartSummaryResponse.grand_total;
//       _grandTotalValue = cartSummaryResponse.grand_total_value;
//       _used_coupon_code = cartSummaryResponse.coupon_code ?? _used_coupon_code;
//       _couponController.text = _used_coupon_code;
//       _coupon_applied = cartSummaryResponse.coupon_applied;
//       setState(() {});
//     }
//   }
//
//   reset() {
//     _paymentTypeList.clear();
//     _isInitial = true;
//     _selected_payment_method_index = 0;
//     _selected_payment_method = "";
//     _selected_payment_method_key = "";
//     setState(() {});
//
//     reset_summary();
//   }
//
//   reset_summary() {
//     _totalString = ". . .";
//     _grandTotalValue = 0.00;
//     _subTotalString = ". . .";
//     _taxString = ". . .";
//     _shippingCostString = ". . .";
//     _discountString = ". . .";
//     _used_coupon_code = "";
//     _couponController.text = _used_coupon_code!;
//     _coupon_applied = false;
//
//     setState(() {});
//   }
//
//   Future<void> _onRefresh() async {
//     reset();
//     fetchAll();
//   }
//
//   onPopped(value) {
//     reset();
//     fetchAll();
//   }
//
//   onCouponApply() async {
//     var coupon_code = _couponController.text.toString();
//     if (coupon_code == "") {
//       ToastComponent.showDialog(AppLocalizations.of(context)!.enter_coupon_code,
//           gravity: Toast.center, duration: Toast.lengthLong);
//       return;
//     }
//
//     var couponApplyResponse =
//         await CouponRepository().getCouponApplyResponse(coupon_code);
//     if (couponApplyResponse.result == false) {
//       ToastComponent.showDialog(couponApplyResponse.message,
//           gravity: Toast.center, duration: Toast.lengthLong);
//       return;
//     }
//
//     reset_summary();
//     fetchSummary();
//   }
//
//   onCouponRemove() async {
//     var couponRemoveResponse =
//         await CouponRepository().getCouponRemoveResponse();
//
//     if (couponRemoveResponse.result == false) {
//       ToastComponent.showDialog(couponRemoveResponse.message,
//           gravity: Toast.center, duration: Toast.lengthLong);
//       return;
//     }
//
//     reset_summary();
//     fetchSummary();
//   }
//
//   onPressPlaceOrderOrProceed() {
//     if (_selected_payment_method == "") {
//       ToastComponent.showDialog(
//           AppLocalizations.of(context)!.please_choose_one_option_to_pay,
//           gravity: Toast.center,
//           duration: Toast.lengthLong);
//       return;
//     }
//     if (_grandTotalValue == 0.00) {
//       ToastComponent.showDialog(AppLocalizations.of(context)!.nothing_to_pay,
//           gravity: Toast.center, duration: Toast.lengthLong);
//       return;
//     }
//
//     if (_selected_payment_method == "stripe_payment") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return StripeScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     }
//     if (_selected_payment_method == "aamarpay") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return AmarpayScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "paypal_payment") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return PaypalScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "razorpay") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return RazorpayScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "paystack") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return PaystackScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "iyzico") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return IyzicoScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "bkash") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return BkashScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "nagad") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return NagadScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "sslcommerz_payment") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return SslCommerzScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "flutterwave") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return FlutterwaveScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "paytm") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return PaytmScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "khalti") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return KhaltiScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "instamojo_payment") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return OnlinePay(
//           title: LangText(context).local.pay_with_instamojo,
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "payfast") {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return PayfastScreen(
//           amount: _grandTotalValue,
//           payment_type: payment_type,
//           payment_method_key: _selected_payment_method_key,
//           package_id: widget.packageId.toString(),
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     } else if (_selected_payment_method == "wallet_system") {
//       pay_by_wallet();
//     } else if (_selected_payment_method == "cash_payment") {
//       pay_by_cod();
//     } else if (_selected_payment_method == "manual_payment" &&
//         widget.paymentFor == PaymentFor.Order) {
//       pay_by_manual_payment();
//     } else if (_selected_payment_method == "manual_payment" &&
//         (widget.paymentFor == PaymentFor.ManualPayment ||
//             widget.paymentFor == PaymentFor.WalletRecharge ||
//             widget.paymentFor == PaymentFor.PackagePay)) {
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return OfflineScreen(
//           order_id: widget.order_id,
//           paymentInstruction:
//               _paymentTypeList[_selected_payment_method_index].details,
//           offline_payment_id: _paymentTypeList[_selected_payment_method_index]
//               .offline_payment_id,
//           rechargeAmount: widget.rechargeAmount,
//           offLinePaymentFor: widget.paymentFor,
//           paymentMethod: _paymentTypeList[_selected_payment_method_index].name,
//           packageId: widget.packageId,
// //          offLinePaymentFor: widget.offLinePaymentFor,
//         );
//       })).then((value) {
//         onPopped(value);
//       });
//     }
//   }
//
//   pay_by_wallet() async {
//     var orderCreateResponse = await PaymentRepository()
//         .getOrderCreateResponseFromWallet(
//             _selected_payment_method_key, _grandTotalValue);
//
//     if (orderCreateResponse.result == false) {
//       ToastComponent.showDialog(orderCreateResponse.message,
//           gravity: Toast.center, duration: Toast.lengthLong);
//       return;
//     }
//
//     String sellerName = orderCreateResponse.seller_name;
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => OrderDetail(
//               id: orderCreateResponse.code,
//               name: sellerName,
//               totalAmount: _grandTotalValue,
//             )));
//
//     // Navigator.push(context, MaterialPageRoute(builder: (context) {
//     //   return OrderList(from_checkout: true);
//     // }));
//   }
//
//   pay_by_cod() async {
//     loading();
//     var orderCreateResponse = await PaymentRepository()
//         .getOrderCreateResponseFromCod(_selected_payment_method_key);
//     Navigator.of(loadingcontext).pop();
//     if (orderCreateResponse.result == false) {
//       ToastComponent.showDialog(orderCreateResponse.message,
//           gravity: Toast.center, duration: Toast.lengthLong);
//       Navigator.of(context).pop();
//       return;
//     }
//     String sellerName = orderCreateResponse.seller_name;
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => OrderDetail(
//               id: orderCreateResponse.code,
//               name: sellerName,
//               totalAmount: _grandTotalValue,
//             )));
//     // Navigator.push(context, MaterialPageRoute(builder: (context) {
//     //   return OrderList(from_checkout: true);
//     // }));
//   }
//
//   pay_by_manual_payment() async {
//     loading();
//     var orderCreateResponse = await PaymentRepository()
//         .getOrderCreateResponseFromManualPayment(_selected_payment_method_key);
//     Navigator.pop(loadingcontext);
//     if (orderCreateResponse.result == false) {
//       ToastComponent.showDialog(orderCreateResponse.message,
//           gravity: Toast.center, duration: Toast.lengthLong);
//       Navigator.of(context).pop();
//       return;
//     }
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return OrderList(from_checkout: true);
//     }));
//   }
//
//   onPaymentMethodItemTap(index) {
//     if (_selected_payment_method_key !=
//         _paymentTypeList[index].payment_type_key) {
//       setState(() {
//         _selected_payment_method_index = index;
//         _selected_payment_method = _paymentTypeList[index].payment_type;
//         _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
//       });
//     }
//
//     //print(_selected_payment_method);
//     //print(_selected_payment_method_key);
//   }
//
//   onPressDetails() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         contentPadding:
//             EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
//         content: Padding(
//           padding: const EdgeInsets.only(left: 8.0, right: 16.0),
//           child: Container(
//             height: 175,
//             child: Column(
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 120,
//                           child: Text(
//                             AppLocalizations.of(context)!.subtotal_all_capital,
//                             textAlign: TextAlign.end,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           SystemConfig.systemCurrency != null
//                               ? _subTotalString!.replaceAll(
//                                   SystemConfig.systemCurrency!.code!,
//                                   SystemConfig.systemCurrency!.symbol!)
//                               : _subTotalString!,
//                           style: TextStyle(
//                               color: MyTheme.font_grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     )),
//                 Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 120,
//                           child: Text(
//                             AppLocalizations.of(context)!.tax_all_capital,
//                             textAlign: TextAlign.end,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           SystemConfig.systemCurrency != null
//                               ? _taxString!.replaceAll(
//                                   SystemConfig.systemCurrency!.code!,
//                                   SystemConfig.systemCurrency!.symbol!)
//                               : _taxString!,
//                           style: TextStyle(
//                               color: MyTheme.font_grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     )),
//                 Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 120,
//                           child: Text(
//                             AppLocalizations.of(context)!
//                                 .shipping_cost_all_capital,
//                             textAlign: TextAlign.end,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           SystemConfig.systemCurrency != null
//                               ? _shippingCostString!.replaceAll(
//                                   SystemConfig.systemCurrency!.code!,
//                                   SystemConfig.systemCurrency!.symbol!)
//                               : _shippingCostString!,
//                           style: TextStyle(
//                               color: MyTheme.font_grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     )),
//                 Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 120,
//                           child: Text(
//                             AppLocalizations.of(context)!.discount_all_capital,
//                             textAlign: TextAlign.end,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           SystemConfig.systemCurrency != null
//                               ? _discountString!.replaceAll(
//                                   SystemConfig.systemCurrency!.code!,
//                                   SystemConfig.systemCurrency!.symbol!)
//                               : _discountString!,
//                           style: TextStyle(
//                               color: MyTheme.font_grey,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     )),
//                 Divider(),
//                 Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 120,
//                           child: Text(
//                             AppLocalizations.of(context)!
//                                 .grand_total_all_capital,
//                             textAlign: TextAlign.end,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           SystemConfig.systemCurrency != null
//                               ? _totalString!.replaceAll(
//                                   SystemConfig.systemCurrency!.code!,
//                                   SystemConfig.systemCurrency!.symbol!)
//                               : _totalString!,
//                           style: TextStyle(
//                               color: MyTheme.accent_color,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           Btn.basic(
//             child: Text(
//               AppLocalizations.of(context)!.close_all_lower,
//               style: TextStyle(color: MyTheme.medium_grey),
//             ),
//             onPressed: () {
//               Navigator.of(context, rootNavigator: true).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection:
//           app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: buildAppBar(context),
//           bottomNavigationBar: buildBottomAppBar(context),
//           body: Stack(
//             children: [
//               RefreshIndicator(
//                 color: MyTheme.accent_color,
//                 backgroundColor: Colors.white,
//                 onRefresh: _onRefresh,
//                 displacement: 0,
//                 child: CustomScrollView(
//                   controller: _mainScrollController,
//                   physics: const BouncingScrollPhysics(
//                       parent: AlwaysScrollableScrollPhysics()),
//                   slivers: [
//                     SliverList(
//                       delegate: SliverChildListDelegate([
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: buildPaymentMethodList(),
//                         ),
//                         Container(
//                           height: 10,
//                         ),
//                         Container(
//                           height: 500,
//                           child: ListView.separated(
//                             itemCount: _couponsList.length,
//                             shrinkWrap: true,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 15),
//                             physics: NeverScrollableScrollPhysics(),
//                             separatorBuilder:
//                                 (BuildContext context, int index) =>
//                                 itemSpacer(),
//                             itemBuilder: (context, index) {
//                               return Stack(
//                                 alignment: AlignmentDirectional.centerStart,
//                                 children: [
//                                   Material(
//                                     elevation: 8,
//                                     borderRadius: const BorderRadius.all(
//                                       const Radius.circular(30.0),
//                                     ),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         gradient: _selectGradient(index),
//                                         borderRadius: const BorderRadius.all(
//                                           const Radius.circular(30.0),
//                                         ),
//                                       ),
//                                       padding: EdgeInsets.only(
//                                           left: 30,
//                                           right: 30,
//                                           top: 30,
//                                           bottom: 20),
//                                       height: 200,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment
//                                                     .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     '${_couponsList[index].shopName}',
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                       FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       // print(_couponsList[index].userType);
//                                                       // print(_couponsList[index].shopId);
//
//                                                       if (_couponsList[index]
//                                                           .userType ==
//                                                           'seller') {
//                                                         Navigator.push(context,
//                                                             MaterialPageRoute(
//                                                                 builder:
//                                                                     (context) {
//                                                                   return SellerDetails(
//                                                                       id: _couponsList[
//                                                                       index]
//                                                                           .shopId);
//                                                                 }));
//                                                       } else {
//                                                         Navigator.push(context,
//                                                             MaterialPageRoute(
//                                                                 builder:
//                                                                     (context) {
//                                                                   return InhouseProducts();
//                                                                 }));
//                                                       }
//                                                     },
//                                                     child: Text(
//                                                       LangText(context)
//                                                           .local
//                                                           .visit_store_ucf,
//                                                       style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontWeight:
//                                                         FontWeight.w600,
//                                                         fontSize: 12,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               itemSpacer(),
//                                               _couponsList[index]
//                                                   .discountType ==
//                                                   "percent"
//                                                   ? Text(
//                                                 "${_couponsList[index].discount}% ${LangText(context).local.off}",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 14,
//                                                   fontWeight:
//                                                   FontWeight.bold,
//                                                 ),
//                                               )
//                                                   : Text(
//                                                 "${convertPrice(_couponsList[index].discount.toString())} ${LangText(context).local.off}",
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 14,
//                                                   fontWeight:
//                                                   FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           itemSpacer(
//                                               height:
//                                               DeviceInfo(context).width! /
//                                                   16),
//                                           MySeparator(color: Colors.white),
//                                           Spacer(),
//                                           Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                 const EdgeInsets.symmetric(
//                                                     horizontal: 12.0),
//                                                 child: _couponsList[index]
//                                                     .couponDiscountDetails !=
//                                                     null
//                                                     ? richText(context, index)
//                                                     : GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder:
//                                                                 (context) {
//                                                               return CouponProducts(
//                                                                   code: _couponsList[
//                                                                   index]
//                                                                       .code!,
//                                                                   id: _couponsList[
//                                                                   index]
//                                                                       .id!);
//                                                             }));
//                                                   },
//                                                   child: Text(
//                                                     LangText(context)
//                                                         .local
//                                                         .view_products_ucf,
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                       FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               itemSpacer(height: 10.0),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                                 children: [
//                                                   Text(
//                                                     "${LangText(context).local.code}: ${_couponsList[index].code}",
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 12,
//                                                       fontWeight:
//                                                       FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                   Spacer(),
//                                                   InkWell(
//                                                     onTap: () {},
//                                                     child: Container(
//                                                       height: 30,
//                                                       width: 90,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                         BorderRadius
//                                                             .circular(5),
//                                                         color: MyTheme
//                                                             .accent_color,
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           'Apply Now',
//                                                           style: TextStyle(
//                                                               color: MyTheme
//                                                                   .white),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                   // IconButton(
//                                                   //   padding: EdgeInsets.zero,
//                                                   //   constraints:
//                                                   //       BoxConstraints(),
//                                                   //   onPressed: () {
//                                                   //     Clipboard.setData(
//                                                   //             ClipboardData(
//                                                   //                 text: _couponsList[
//                                                   //                         index]
//                                                   //                     .code!))
//                                                   //         .then((_) {
//                                                   //       ToastComponent
//                                                   //           .showDialog(
//                                                   //               LangText(
//                                                   //                       context)
//                                                   //                   .local
//                                                   //                   .copied_ucf,
//                                                   //               gravity: Toast
//                                                   //                   .center,
//                                                   //               duration: 1);
//                                                   //     });
//                                                   //   },
//                                                   //   icon: Icon(
//                                                   //     color: Colors.white,
//                                                   //     Icons.copy,
//                                                   //     size: 18.0,
//                                                   //   ),
//                                                   // )
//                                                 ],
//                                               )
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         height: 40,
//                                         width: 20,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: const BorderRadius.only(
//                                             topRight:
//                                             const Radius.circular(30.0),
//                                             bottomRight:
//                                             const Radius.circular(30.0),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: 40,
//                                         width: 20,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: const BorderRadius.only(
//                                             topLeft:
//                                             const Radius.circular(30.0),
//                                             bottomLeft:
//                                             const Radius.circular(30.0),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                         Container(
//                           height: 180,
//                           margin: EdgeInsets.symmetric(horizontal: 15),
//                           decoration: BoxDecoration(
//                             color: MyTheme.green_light,
//                             borderRadius: const BorderRadius.all(
//                               const Radius.circular(20.0),
//                             ),
//                             // gradient: MyTheme.buildLinearGradient3(),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           child: Column(
//                             children: [
//                               Padding(
//                                   padding:
//                                   const EdgeInsets.only(bottom: 8, top: 8),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 120,
//                                         child: Text(
//                                           AppLocalizations.of(context)!
//                                               .subtotal_all_capital,
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                               color: MyTheme.white,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Text(
//                                         SystemConfig.systemCurrency != null
//                                             ? _subTotalString!.replaceAll(
//                                             SystemConfig
//                                                 .systemCurrency!.code!,
//                                             SystemConfig
//                                                 .systemCurrency!.symbol!)
//                                             : _subTotalString!,
//                                         style: TextStyle(
//                                             color: MyTheme.white,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ],
//                                   )),
//                               Padding(
//                                   padding: const EdgeInsets.only(bottom: 8),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 120,
//                                         child: Text(
//                                           AppLocalizations.of(context)!
//                                               .tax_all_capital,
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                               color: MyTheme.white,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Text(
//                                         SystemConfig.systemCurrency != null
//                                             ? _taxString!.replaceAll(
//                                             SystemConfig
//                                                 .systemCurrency!.code!,
//                                             SystemConfig
//                                                 .systemCurrency!.symbol!)
//                                             : _taxString!,
//                                         style: TextStyle(
//                                             color: MyTheme.white,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ],
//                                   )),
//                               Padding(
//                                   padding: const EdgeInsets.only(bottom: 8),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 120,
//                                         child: Text(
//                                           AppLocalizations.of(context)!
//                                               .shipping_cost_all_capital,
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                               color: MyTheme.white,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Text(
//                                         SystemConfig.systemCurrency != null
//                                             ? _shippingCostString!.replaceAll(
//                                             SystemConfig
//                                                 .systemCurrency!.code!,
//                                             SystemConfig
//                                                 .systemCurrency!.symbol!)
//                                             : _shippingCostString!,
//                                         style: TextStyle(
//                                             color: MyTheme.white,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ],
//                                   )),
//                               Padding(
//                                   padding: const EdgeInsets.only(bottom: 8),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 120,
//                                         child: Text(
//                                           AppLocalizations.of(context)!
//                                               .discount_all_capital,
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                               color: MyTheme.white,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Text(
//                                         SystemConfig.systemCurrency != null
//                                             ? _discountString!.replaceAll(
//                                             SystemConfig
//                                                 .systemCurrency!.code!,
//                                             SystemConfig
//                                                 .systemCurrency!.symbol!)
//                                             : _discountString!,
//                                         style: TextStyle(
//                                             color: MyTheme.white,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ],
//                                   )),
//                               Divider(
//                                 color: MyTheme.white,
//                               ),
//                               Padding(
//                                   padding: const EdgeInsets.only(bottom: 8),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 120,
//                                         child: Text(
//                                           AppLocalizations.of(context)!
//                                               .grand_total_all_capital,
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                               color: MyTheme.white,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       Spacer(),
//                                       Text(
//                                         SystemConfig.systemCurrency != null
//                                             ? _totalString!.replaceAll(
//                                             SystemConfig
//                                                 .systemCurrency!.code!,
//                                             SystemConfig
//                                                 .systemCurrency!.symbol!)
//                                             : _totalString!,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   )),
//                             ],
//                           ),
//                         )
//                       ]),
//                     )
//                   ],
//                 ),
//               ),
//
//               //Apply Coupon and order details container
//               // Align(
//               //   alignment: Alignment.bottomCenter,
//               //   child: widget.paymentFor == PaymentFor.WalletRecharge ||
//               //           widget.paymentFor == PaymentFor.PackagePay
//               //       ? Container()
//               //       : Container(
//               //           decoration: BoxDecoration(
//               //             color: Colors.white,
//               //
//               //             /*border: Border(
//               //         top: BorderSide(color: MyTheme.light_grey,width: 1.0),
//               //       )*/
//               //           ),
//               //           height: widget.paymentFor == PaymentFor.ManualPayment
//               //               ? 80
//               //               : 140,
//               //           //color: Colors.white,
//               //           child: Padding(
//               //             padding: const EdgeInsets.all(16.0),
//               //             child: Column(
//               //               children: [
//               //                 widget.paymentFor == PaymentFor.Order
//               //                     ? Padding(
//               //                         padding:
//               //                             const EdgeInsets.only(bottom: 16.0),
//               //                         child: buildApplyCouponRow(context),
//               //                       )
//               //                     : Container(),
//               //                 grandTotalSection(),
//               //               ],
//               //             ),
//               //           ),
//               //         ),
//               // )
//             ],
//           )),
//     );
//   }
//
//   Row buildApplyCouponRow(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           height: 42,
//           width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
//           child: TextFormField(
//             controller: _couponController,
//             readOnly: _coupon_applied!,
//             autofocus: false,
//             decoration: InputDecoration(
//                 hintText: AppLocalizations.of(context)!.enter_coupon_code,
//                 hintStyle:
//                     TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
//                 enabledBorder: app_language_rtl.$!
//                     ? OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: MyTheme.textfield_grey, width: 0.5),
//                         borderRadius: const BorderRadius.only(
//                           topRight: const Radius.circular(8.0),
//                           bottomRight: const Radius.circular(8.0),
//                         ),
//                       )
//                     : OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: MyTheme.textfield_grey, width: 0.5),
//                         borderRadius: const BorderRadius.only(
//                           topLeft: const Radius.circular(8.0),
//                           bottomLeft: const Radius.circular(8.0),
//                         ),
//                       ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide:
//                       BorderSide(color: MyTheme.medium_grey, width: 0.5),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: const Radius.circular(8.0),
//                     bottomLeft: const Radius.circular(8.0),
//                   ),
//                 ),
//                 contentPadding: EdgeInsets.only(left: 16.0)),
//           ),
//         ),
//         !_coupon_applied!
//             ? Container(
//                 width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
//                 height: 42,
//                 child: Btn.basic(
//                   minWidth: MediaQuery.of(context).size.width,
//                   color: MyTheme.accent_color,
//                   shape: app_language_rtl.$!
//                       ? RoundedRectangleBorder(
//                           borderRadius: const BorderRadius.only(
//                           topLeft: const Radius.circular(8.0),
//                           bottomLeft: const Radius.circular(8.0),
//                         ))
//                       : RoundedRectangleBorder(
//                           borderRadius: const BorderRadius.only(
//                           topRight: const Radius.circular(8.0),
//                           bottomRight: const Radius.circular(8.0),
//                         )),
//                   child: Text(
//                     AppLocalizations.of(context)!.apply_coupon_all_capital,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   onPressed: () {
//                     onCouponApply();
//                   },
//                 ),
//               )
//             : Container(
//                 width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
//                 height: 42,
//                 child: Btn.basic(
//                   minWidth: MediaQuery.of(context).size.width,
//                   color: MyTheme.accent_color,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: const BorderRadius.only(
//                     topRight: const Radius.circular(8.0),
//                     bottomRight: const Radius.circular(8.0),
//                   )),
//                   child: Text(
//                     AppLocalizations.of(context)!.remove_ucf,
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   onPressed: () {
//                     onCouponRemove();
//                   },
//                 ),
//               )
//       ],
//     );
//   }
//
//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       centerTitle: true,
//       leading: Builder(
//         builder: (context) => IconButton(
//           icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       title: Text(
//         widget.title!,
//         style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
//       ),
//       elevation: 0.0,
//       titleSpacing: 0,
//     );
//   }
//
//   buildPaymentMethodList() {
//     if (_isInitial && _paymentTypeList.length == 0) {
//       return SingleChildScrollView(
//           child: ShimmerHelper()
//               .buildListShimmer(item_count: 5, item_height: 100.0));
//     } else if (_paymentTypeList.length > 0) {
//       return SingleChildScrollView(
//         child: ListView.separated(
//           separatorBuilder: (context, index) {
//             return SizedBox(
//               height: 14,
//             );
//           },
//           itemCount: _paymentTypeList.length,
//           scrollDirection: Axis.vertical,
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: buildPaymentMethodItemCard(index),
//             );
//           },
//         ),
//       );
//     } else if (!_isInitial && _paymentTypeList.length == 0) {
//       return Container(
//           height: 100,
//           child: Center(
//               child: Text(
//             AppLocalizations.of(context)!.no_payment_method_is_added,
//             style: TextStyle(color: MyTheme.font_grey),
//           )));
//     }
//   }
//
//   GestureDetector buildPaymentMethodItemCard(index) {
//     return GestureDetector(
//       onTap: () {
//         onPaymentMethodItemTap(index);
//       },
//       child: Stack(
//         children: [
//           AnimatedContainer(
//             duration: Duration(milliseconds: 400),
//             decoration: BoxDecorations.buildBoxDecoration_1().copyWith(
//                 border: Border.all(
//                     color: _selected_payment_method_key ==
//                             _paymentTypeList[index].payment_type_key
//                         ? MyTheme.accent_color
//                         : MyTheme.light_grey,
//                     width: _selected_payment_method_key ==
//                             _paymentTypeList[index].payment_type_key
//                         ? 2.0
//                         : 0.0)),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                       width: 100,
//                       height: 100,
//                       child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child:
//                               /*Image.asset(
//                           _paymentTypeList[index].image,
//                           fit: BoxFit.fitWidth,
//                         ),*/
//                               FadeInImage.assetNetwork(
//                             placeholder: 'assets/placeholder.png',
//                             image: _paymentTypeList[index].payment_type ==
//                                     "manual_payment"
//                                 ? _paymentTypeList[index].image
//                                 : _paymentTypeList[index].image,
//                             fit: BoxFit.fitWidth,
//                           ))),
//                   Container(
//                     width: 150,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 8.0),
//                           child: Text(
//                             _paymentTypeList[index].title,
//                             textAlign: TextAlign.left,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey,
//                                 fontSize: 14,
//                                 height: 1.6,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ]),
//           ),
//           Positioned(
//             right: 16,
//             top: 16,
//             child: buildPaymentMethodCheckContainer(
//                 _selected_payment_method_key ==
//                     _paymentTypeList[index].payment_type_key),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget buildPaymentMethodCheckContainer(bool check) {
//     return AnimatedOpacity(
//       duration: Duration(milliseconds: 400),
//       opacity: check ? 1 : 0,
//       child: Container(
//         height: 16,
//         width: 16,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16.0), color: Colors.green),
//         child: Padding(
//           padding: const EdgeInsets.all(3),
//           child: Icon(Icons.check, color: Colors.white, size: 10),
//         ),
//       ),
//     );
//     /* Visibility(
//       visible: check,
//       child: Container(
//         height: 16,
//         width: 16,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16.0), color: Colors.green),
//         child: Padding(
//           padding: const EdgeInsets.all(3),
//           child: Icon(Icons.check, color: Colors.white, size: 10),
//         ),
//       ),
//     );*/
//   }
//
//   BottomAppBar buildBottomAppBar(BuildContext context) {
//     return BottomAppBar(
//       child: Container(
//         color: Colors.transparent,
//         height: 50,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Btn.minWidthFixHeight(
//               minWidth: MediaQuery.of(context).size.width,
//               height: 50,
//               color: MyTheme.accent_color,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(0.0),
//               ),
//               child: Text(
//                 widget.paymentFor == PaymentFor.WalletRecharge
//                     ? AppLocalizations.of(context)!.recharge_wallet_ucf
//                     : widget.paymentFor == PaymentFor.ManualPayment
//                         ? AppLocalizations.of(context)!.proceed_all_caps
//                         : widget.paymentFor == PaymentFor.PackagePay
//                             ? AppLocalizations.of(context)!.buy_package_ucf
//                             : AppLocalizations.of(context)!
//                                 .place_my_order_all_capital,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600),
//               ),
//               onPressed: () {
//                 onPressPlaceOrderOrProceed();
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget grandTotalSection() {
//     return Container(
//       height: 40,
//       width: double.infinity,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.0),
//           color: MyTheme.soft_accent_color),
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Text(
//                 AppLocalizations.of(context)!.total_amount_ucf,
//                 style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
//               ),
//             ),
//             Visibility(
//               visible: widget.paymentFor != PaymentFor.ManualPayment,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: InkWell(
//                   onTap: () {
//                     onPressDetails();
//                   },
//                   child: Text(
//                     AppLocalizations.of(context)!.see_details_all_lower,
//                     style: TextStyle(
//                       color: MyTheme.font_grey,
//                       fontSize: 12,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Text(
//                   widget.paymentFor == PaymentFor.ManualPayment
//                       ? widget.rechargeAmount.toString()
//                       : SystemConfig.systemCurrency != null
//                           ? _totalString!.replaceAll(
//                               SystemConfig.systemCurrency!.code!,
//                               SystemConfig.systemCurrency!.symbol!)
//                           : _totalString!,
//                   style: TextStyle(
//                       color: MyTheme.accent_color,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   loading() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           loadingcontext = context;
//           return AlertDialog(
//               content: Row(
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(
//                 width: 10,
//               ),
//               Text("${AppLocalizations.of(context)!.please_wait_ucf}"),
//             ],
//           ));
//         });
//   }
// }

import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/enum_classes.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/cart_count_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_summary_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/repositories/coupon_repository.dart';
import 'package:active_ecommerce_flutter/repositories/gst_repository.dart';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/screens/order_details.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/amarpay_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/bkash_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/flutterwave_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/iyzico_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/khalti_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/nagad_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/offline_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/online_pay.dart';

// import 'package:active_ecommerce_flutter/screens/payment_method_screen/order_details.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/payfast_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paypal_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paystack_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/paytm_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/razorpay_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/sslcommerz_screen.dart';
import 'package:active_ecommerce_flutter/screens/payment_method_screen/stripe_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';
import '../helpers/main_helpers.dart';
import 'coupon_list_page.dart';
import 'order_detail_page.dart';

class Checkout extends StatefulWidget {
  int? order_id; // only need when making manual payment from order details
  String list;

  //final OffLinePaymentFor offLinePaymentFor;
  final PaymentFor? paymentFor;
  final double rechargeAmount;
  final String? title;
  CartSummaryResponse? cart;
  var packageId;

  Checkout(
      {Key? key,
      this.order_id = 0,
      this.paymentFor,
      this.list = "both",
      this.cart,
      //this.offLinePaymentFor,
      this.rechargeAmount = 0.0,
      this.title,
      this.packageId = 0})
      : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var _selected_payment_method_index = 0;
  String? _selected_payment_method = "";
  String? _selected_payment_method_key = "";

  ScrollController _mainScrollController = ScrollController();
  TextEditingController _couponController = TextEditingController();
  TextEditingController _gstController = TextEditingController();
  var _paymentTypeList = [];
  bool _isInitial = true;
  String? _totalString = ". . .";
  double? _grandTotalValue = 0.00;
  String? _subTotalString = ". . .";
  String? _taxString = ". . .";
  int? _taxPercentage = 0;
  String _shippingCostString = ". . .";
  String? _discountString = ". . .";
  String _used_coupon_code = "";
  bool? _coupon_applied = false;
  late BuildContext loadingcontext;
  String payment_type = "cart_payment";
  String? _title;
  int? _selectedValue = 1;

  bool _isWithGST = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/
    fetchData();
    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchAll() {
    fetchList();
    if (is_logged_in.$ == true) {
      if (widget.paymentFor != PaymentFor.Order) {
        _grandTotalValue = widget.rechargeAmount;
        payment_type = widget.paymentFor == PaymentFor.WalletRecharge
            ? "wallet_payment"
            : "customer_package_payment";
      } else {
        fetchSummary();
      }
    }
  }

  fetchList() async {
    var paymentTypeResponseList = await PaymentRepository()
        .getPaymentResponseList(
            list: widget.list,
            mode: widget.paymentFor != PaymentFor.Order &&
                    widget.paymentFor != PaymentFor.ManualPayment
                ? "wallet"
                : "order");
    _paymentTypeList.addAll(paymentTypeResponseList);
    if (_paymentTypeList.length > 0) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    }

    if (_selected_payment_method_key == "razorpay") {
      var couponRes =
          await CouponRepository().getCouponResponseList(page: _page);
      _couponsList.addAll(couponRes.data!);
      for (int i = 0; i < _couponsList.length; i++) {
        if (_couponsList[i].code == "ONLINE") {
          onCouponApply(_couponsList[i].code);
        }
      }
    } else {}
    _isInitial = false;
    setState(() {});
  }

  fetchSummary() async {
    var cartSummaryResponse = await CartRepository().getCartSummaryResponse();

    if (cartSummaryResponse != null) {
      _subTotalString = cartSummaryResponse.sub_total;
      _taxString = cartSummaryResponse.tax;
      _taxPercentage = cartSummaryResponse.tax_percentage;
      _shippingCostString = cartSummaryResponse.shipping_cost;
      _discountString = cartSummaryResponse.discount;
      _totalString = cartSummaryResponse.grand_total;
      _grandTotalValue = cartSummaryResponse.grand_total_value;
      _used_coupon_code = cartSummaryResponse.coupon_code ?? _used_coupon_code;
      _couponController.text = _used_coupon_code;
      _coupon_applied = cartSummaryResponse.coupon_applied;
      setState(() {});
    }
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method_index = 0;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    setState(() {});

    reset_summary();
  }

  reset_summary() {
    _totalString = ". . .";
    _grandTotalValue = 0.00;
    _subTotalString = ". . .";
    _taxString = ". . .";
    _shippingCostString = ". . .";
    _discountString = ". . .";
    _used_coupon_code = "";
    _couponController.text = _used_coupon_code!;
    _coupon_applied = false;

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) {
    reset();
    fetchAll();
  }

  onCouponApply(var coupon_code) async {
    // var coupon_code = _couponController.text.toString();
    // var coupon_code = id;
    if (coupon_code == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_coupon_code,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var couponApplyResponse =
        await CouponRepository().getCouponApplyResponse(coupon_code);
    if (couponApplyResponse.result == false) {
      ToastComponent.showDialog(couponApplyResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onGstNumberPress(gst_number) async {
    var cartDeleteResponse =
        await GstRepository().getGstInvoiceResponse(gst_number: gst_number);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  onCouponRemove() async {
    var couponRemoveResponse =
        await CouponRepository().getCouponRemoveResponse();

    if (couponRemoveResponse.result == false) {
      ToastComponent.showDialog(couponRemoveResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onPressPlaceOrderOrProceed() {
    if (_selected_payment_method == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.please_choose_one_option_to_pay,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    if (_grandTotalValue == 0.00) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.nothing_to_pay,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_payment_method == "stripe_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StripeScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    }
    if (_selected_payment_method == "aamarpay") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AmarpayScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paypal_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaypalScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "razorpay") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RazorpayScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paystack") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaystackScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "iyzico") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return IyzicoScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "bkash") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BkashScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "nagad") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NagadScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "sslcommerz_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SslCommerzScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "flutterwave") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FlutterwaveScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "paytm") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaytmScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "khalti") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return KhaltiScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "instamojo_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OnlinePay(
          title: LangText(context).local.pay_with_instamojo,
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "payfast") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PayfastScreen(
          amount: _grandTotalValue,
          payment_type: payment_type,
          payment_method_key: _selected_payment_method_key,
          package_id: widget.packageId.toString(),
        );
      })).then((value) {
        onPopped(value);
      });
    } else if (_selected_payment_method == "wallet_system") {
      pay_by_wallet();
    } else if (_selected_payment_method == "cash_payment") {
      pay_by_cod();
    } else if (_selected_payment_method == "manual_payment" &&
        widget.paymentFor == PaymentFor.Order) {
      pay_by_manual_payment();
    } else if (_selected_payment_method == "manual_payment" &&
        (widget.paymentFor == PaymentFor.ManualPayment ||
            widget.paymentFor == PaymentFor.WalletRecharge ||
            widget.paymentFor == PaymentFor.PackagePay)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OfflineScreen(
          order_id: widget.order_id,
          paymentInstruction:
              _paymentTypeList[_selected_payment_method_index].details,
          offline_payment_id: _paymentTypeList[_selected_payment_method_index]
              .offline_payment_id,
          rechargeAmount: widget.rechargeAmount,
          offLinePaymentFor: widget.paymentFor,
          paymentMethod: _paymentTypeList[_selected_payment_method_index].name,
          packageId: widget.packageId,
//          offLinePaymentFor: widget.offLinePaymentFor,
        );
      })).then((value) {
        onPopped(value);
      });
    }
  }

  pay_by_wallet() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromWallet(
            _selected_payment_method_key, _grandTotalValue);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    String sellerName = orderCreateResponse.seller_name;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderConfirmation(
                  id: orderCreateResponse.combined_order_id,
                  name: sellerName,
                  totalAmount: _grandTotalValue,
                )));

    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return OrderList(from_checkout: true);
    // }));
  }

  pay_by_cod() async {
    loading();
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromCod(_selected_payment_method_key);
    Navigator.of(loadingcontext).pop();
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }
    String sellerName = orderCreateResponse.seller_name;
    print('888888888888888888888888-----$_grandTotalValue');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderConfirmation(
                  id: orderCreateResponse.code,
                  name: sellerName,
                  totalAmount: _grandTotalValue,
                )));
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return OrderList(from_checkout: true);
    // }));
  }

  pay_by_manual_payment() async {
    loading();
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromManualPayment(_selected_payment_method_key);
    Navigator.pop(loadingcontext);
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  bool _dataFetch = false;
  List<dynamic> _couponsList = [];
  int? _totalData = 0;
  bool _showLoadingContainer = false;
  int _page = 1;

  _selectGradient(index) {
    if (index == 0 || (index + 1 > 3 && ((index + 1) % 3) == 1)) {
      return MyTheme.buildLinearGradient1();
    } else if (index == 1 || (index + 1 > 3 && ((index + 1) % 3) == 2)) {
      return MyTheme.buildLinearGradient2();
    } else if (index == 2 || (index + 1 > 3 && ((index + 1) % 3) == 0)) {
      return MyTheme.buildLinearGradient3();
    }
  }

  fetchData() async {
    var couponRes = await CouponRepository().getCouponResponseList(page: _page);
    _couponsList.addAll(couponRes.data!);
    _totalData = couponRes.meta!.total;
    _dataFetch = true;
    _showLoadingContainer = false;
    setState(() {});
  }

  RichText richText(BuildContext context, int index) {
    return RichText(
      text: TextSpan(
        text: '${LangText(context).local.min_spend_ucf} ',
        style: TextStyle(
          fontSize: 12,
        ),
        children: [
          TextSpan(
            text:
                '${convertPrice(_couponsList[index].couponDiscountDetails!.minBuy)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: ' ${LangText(context).local.from}',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: ' ${_couponsList[index].shopName}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: ' ${LangText(context).local.store_to_get}',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          TextSpan(
            text:
                ' ${_couponsList[index].discountType == "percent" ? _couponsList[index].discount.toString() + "%" : convertPrice(_couponsList[index].discount.toString())}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: ' ${LangText(context).local.off_on_total_orders}',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  itemSpacer({height = 15.0}) {
    return SizedBox(
      height: height,
    );
  }

  onPaymentMethodItemTap(index) async {
    if (_selected_payment_method_key !=
        _paymentTypeList[index].payment_type_key) {
      if (_paymentTypeList[index].payment_type == "razorpay") {
        var couponRes =
            await CouponRepository().getCouponResponseList(page: _page);
        _couponsList.addAll(couponRes.data!);

        for (int i = 0; i < _couponsList.length; i++) {
          for (int i = 0; i < _couponsList.length; i++) {
            if (_couponsList[i].code == "ONLINE") {
              onCouponApply(_couponsList[i].code);
            }
          }
        }

        print("object ${_couponsList}");
      } else {
        onCouponRemove();
      }

      setState(() {
        _selected_payment_method_index = index;
        _selected_payment_method = _paymentTypeList[index].payment_type;
        _selected_payment_method_key = _paymentTypeList[index].payment_type_key;

        print(
            "_selected_payment_method_index ${_selected_payment_method_index}");
        print("_selected_payment_method ${_selected_payment_method}");
        print("_selected_payment_method_key ${_selected_payment_method_key}");
      });
    }

    //print(_selected_payment_method);
    //print(_selected_payment_method_key);
  }

  onPressDetails() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
        content: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: Container(
            height: 175,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.subtotal_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          SystemConfig.systemCurrency != null
                              ? _subTotalString!.replaceAll(
                                  SystemConfig.systemCurrency!.code!,
                                  SystemConfig.systemCurrency!.symbol!)
                              : _subTotalString!,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.tax_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          SystemConfig.systemCurrency != null
                              ? _taxString!.replaceAll(
                                  SystemConfig.systemCurrency!.code!,
                                  SystemConfig.systemCurrency!.symbol!)
                              : _taxString!,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!
                                .shipping_cost_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          SystemConfig.systemCurrency != null
                              ? _shippingCostString!.replaceAll(
                                  SystemConfig.systemCurrency!.code!,
                                  SystemConfig.systemCurrency!.symbol!)
                              : _shippingCostString!,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.discount_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          SystemConfig.systemCurrency != null
                              ? _discountString!.replaceAll(
                                  SystemConfig.systemCurrency!.code!,
                                  SystemConfig.systemCurrency!.symbol!)
                              : _discountString!,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!
                                .grand_total_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          SystemConfig.systemCurrency != null
                              ? _totalString!.replaceAll(
                                  SystemConfig.systemCurrency!.code!,
                                  SystemConfig.systemCurrency!.symbol!)
                              : _totalString!,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        actions: [
          Btn.basic(
            child: Text(
              AppLocalizations.of(context)!.close_all_lower,
              style: TextStyle(color: MyTheme.medium_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          bottomNavigationBar: buildBottomAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: EdgeInsets.only(left: 18),
                          child: Text(
                            'PAYMENT MODE',
                            style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSans',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildPaymentMethodList(),
                        ),
                        Container(
                          height: 10,
                        ),
                        // Expanded(
                        //   child: ListView.separated(
                        //     scrollDirection: Axis.vertical,
                        //     itemCount: _couponsList.length,
                        //     shrinkWrap: true,
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 15, vertical: 15),
                        //     // physics: NeverScrollableScrollPhysics(),
                        //     separatorBuilder:
                        //         (BuildContext context, int index) =>
                        //             itemSpacer(),
                        //     itemBuilder: (context, index) {
                        //       return Stack(
                        //         alignment: AlignmentDirectional.centerStart,
                        //         children: [
                        //           Material(
                        //             elevation: 8,
                        //             borderRadius: const BorderRadius.all(
                        //               const Radius.circular(30.0),
                        //             ),
                        //             child: Container(
                        //               decoration: BoxDecoration(
                        //                 gradient: _selectGradient(index),
                        //                 borderRadius: const BorderRadius.all(
                        //                   const Radius.circular(30.0),
                        //                 ),
                        //               ),
                        //               padding: EdgeInsets.only(
                        //                   left: 30,
                        //                   right: 30,
                        //                   top: 30,
                        //                   bottom: 20),
                        //               height: 200,
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                 children: [
                        //                   Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment
                        //                                 .spaceBetween,
                        //                         children: [
                        //                           Text(
                        //                             '${_couponsList[index].shopName}',
                        //                             style: TextStyle(
                        //                               color: Colors.white,
                        //                               fontSize: 12,
                        //                               fontWeight:
                        //                                   FontWeight.w600,
                        //                             ),
                        //                           ),
                        //                           SizedBox(
                        //                             width: 5,
                        //                           ),
                        //                           GestureDetector(
                        //                             onTap: () {
                        //                               // print(_couponsList[index].userType);
                        //                               // print(_couponsList[index].shopId);
                        //
                        //                               if (_couponsList[index]
                        //                                       .userType ==
                        //                                   'seller') {
                        //                                 Navigator.push(
                        //                                     context,
                        //                                     MaterialPageRoute(
                        //                                         builder:
                        //                                             (context) {
                        //                                   return SellerDetails(
                        //                                       id: _couponsList[
                        //                                               index]
                        //                                           .shopId);
                        //                                 }));
                        //                               } else {
                        //                                 Navigator.push(
                        //                                     context,
                        //                                     MaterialPageRoute(
                        //                                         builder:
                        //                                             (context) {
                        //                                   return InhouseProducts();
                        //                                 }));
                        //                               }
                        //                             },
                        //                             child: Text(
                        //                               LangText(context)
                        //                                   .local
                        //                                   .visit_store_ucf,
                        //                               style: TextStyle(
                        //                                 color: Colors.white,
                        //                                 fontWeight:
                        //                                     FontWeight.w600,
                        //                                 fontSize: 12,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       itemSpacer(),
                        //                       _couponsList[index]
                        //                                   .discountType ==
                        //                               "percent"
                        //                           ? Text(
                        //                               "${_couponsList[index].discount}% ${LangText(context).local.off}",
                        //                               style: TextStyle(
                        //                                 color: Colors.white,
                        //                                 fontSize: 14,
                        //                                 fontWeight:
                        //                                     FontWeight.bold,
                        //                               ),
                        //                             )
                        //                           : Text(
                        //                               "${convertPrice(_couponsList[index].discount.toString())} ${LangText(context).local.off}",
                        //                               style: TextStyle(
                        //                                 color: Colors.white,
                        //                                 fontSize: 14,
                        //                                 fontWeight:
                        //                                     FontWeight.bold,
                        //                               ),
                        //                             ),
                        //                     ],
                        //                   ),
                        //                   itemSpacer(
                        //                       height:
                        //                           DeviceInfo(context).width! /
                        //                               16),
                        //                   MySeparator(color: Colors.white),
                        //                   Spacer(),
                        //                   Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       Padding(
                        //                         padding: const EdgeInsets
                        //                             .symmetric(
                        //                             horizontal: 12.0),
                        //                         child: _couponsList[index]
                        //                                     .couponDiscountDetails !=
                        //                                 null
                        //                             ? richText(context, index)
                        //                             : GestureDetector(
                        //                                 onTap: () {
                        //                                   Navigator.push(
                        //                                       context,
                        //                                       MaterialPageRoute(
                        //                                           builder:
                        //                                               (context) {
                        //                                     return CouponProducts(
                        //                                         code: _couponsList[
                        //                                                 index]
                        //                                             .code!,
                        //                                         id: _couponsList[
                        //                                                 index]
                        //                                             .id!);
                        //                                   }));
                        //                                 },
                        //                                 child: Text(
                        //                                   LangText(context)
                        //                                       .local
                        //                                       .view_products_ucf,
                        //                                   style: TextStyle(
                        //                                     color:
                        //                                         Colors.white,
                        //                                     fontSize: 12,
                        //                                     fontWeight:
                        //                                         FontWeight
                        //                                             .w600,
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                       ),
                        //                       itemSpacer(height: 10.0),
                        //                       Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.end,
                        //                         children: [
                        //                           Text(
                        //                             "${LangText(context).local.code}: ${_couponsList[index].code}",
                        //                             style: TextStyle(
                        //                               color: Colors.white,
                        //                               fontSize: 12,
                        //                               fontWeight:
                        //                                   FontWeight.bold,
                        //                             ),
                        //                           ),
                        //                           Spacer(),
                        //                           InkWell(
                        //                             onTap: () {
                        //                               onCouponApply(
                        //                                   _couponsList[index]
                        //                                       .code!);
                        //                               print(
                        //                                   _couponsList[index]
                        //                                       .code);
                        //                             },
                        //                             child: Container(
                        //                               height: 30,
                        //                               width: 90,
                        //                               decoration:
                        //                                   BoxDecoration(
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(5),
                        //                                 color: MyTheme
                        //                                     .accent_color,
                        //                               ),
                        //                               child: Center(
                        //                                 child: Text(
                        //                                   'Apply Now',
                        //                                   style: TextStyle(
                        //                                       color: MyTheme
                        //                                           .white),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           )
                        //                           // IconButton(
                        //                           //   padding: EdgeInsets.zero,
                        //                           //   constraints:
                        //                           //       BoxConstraints(),
                        //                           //   onPressed: () {
                        //                           //     Clipboard.setData(
                        //                           //             ClipboardData(
                        //                           //                 text: _couponsList[
                        //                           //                         index]
                        //                           //                     .code!))
                        //                           //         .then((_) {
                        //                           //       ToastComponent
                        //                           //           .showDialog(
                        //                           //               LangText(
                        //                           //                       context)
                        //                           //                   .local
                        //                           //                   .copied_ucf,
                        //                           //               gravity: Toast
                        //                           //                   .center,
                        //                           //               duration: 1);
                        //                           //     });
                        //                           //   },
                        //                           //   icon: Icon(
                        //                           //     color: Colors.white,
                        //                           //     Icons.copy,
                        //                           //     size: 18.0,
                        //                           //   ),
                        //                           // )
                        //                         ],
                        //                       )
                        //                     ],
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Container(
                        //                 height: 40,
                        //                 width: 20,
                        //                 decoration: BoxDecoration(
                        //                   color: Colors.white,
                        //                   borderRadius:
                        //                       const BorderRadius.only(
                        //                     topRight:
                        //                         const Radius.circular(30.0),
                        //                     bottomRight:
                        //                         const Radius.circular(30.0),
                        //                   ),
                        //                 ),
                        //               ),
                        //               Container(
                        //                 height: 40,
                        //                 width: 20,
                        //                 decoration: BoxDecoration(
                        //                   color: Colors.white,
                        //                   borderRadius:
                        //                       const BorderRadius.only(
                        //                     topLeft:
                        //                         const Radius.circular(30.0),
                        //                     bottomLeft:
                        //                         const Radius.circular(30.0),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           )
                        //         ],
                        //       );
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Container(
                            decoration: BoxDecorations.buildBoxDecoration_1(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Text(
                                    'GST DETAIL',
                                    style: TextStyle(
                                      color: MyTheme.accent_color,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'NotoSans',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: _selectedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value!;
                                            });
                                          },
                                          activeColor: MyTheme.accent_color,
                                        ),
                                        Text(
                                          'I don\'t have GST',
                                          style: TextStyle(
                                            color: MyTheme.grey_153,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'NotoSans',
                                          ),
                                        ),
                                        Radio(
                                          value: 2,
                                          groupValue: _selectedValue,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value!;
                                            });
                                          },
                                          activeColor: MyTheme.accent_color,
                                        ),
                                        Text(
                                          'I want GST invoice',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'NotoSans',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _selectedValue == 2
                                    ? Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 10),
                                              child: Text(
                                                'GST Number',
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'NotoSans',
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 5, right: 5),
                                              child: Container(
                                                height: 45,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    20,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: MyTheme.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: MyTheme.grey_153
                                                          .withOpacity(0.2),
                                                      offset:
                                                          const Offset(0, 2),
                                                      blurRadius: 2.0,
                                                      spreadRadius: 2.0,
                                                    ), //BoxShadow
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        controller:
                                                            _gstController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Enter GST number',
                                                          hintStyle: TextStyle(
                                                            color: MyTheme
                                                                .accent_color,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'NotoSans',
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    // Added space between TextField and InkWell
                                                    InkWell(
                                                      onTap: () {
                                                        if (_gstController
                                                                .text ==
                                                            '') {
                                                          ToastComponent.showDialog(
                                                              'Please enter GST number',
                                                              gravity:
                                                                  Toast.center,
                                                              duration: Toast
                                                                  .lengthLong);
                                                          return;
                                                        } else if (_gstController
                                                                .text.length !=
                                                            15) {
                                                          ToastComponent.showDialog(
                                                              'Please enter 15 digit GST number',
                                                              gravity:
                                                                  Toast.center,
                                                              duration: Toast
                                                                  .lengthLong);
                                                          return;
                                                        } else {
                                                          onGstNumberPress(
                                                              _gstController
                                                                  .text);
                                                          _gstController
                                                              .clear();
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 35,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: MyTheme
                                                              .accent_color,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Save',
                                                            style: TextStyle(
                                                              color:
                                                                  MyTheme.white,
                                                              // Changed to white for better visibility
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'NotoSans',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15,
                                                  left: 10,
                                                  bottom: 10),
                                              child: Text(
                                                'Please provide your GST number to get GST invoice and tax invoice details benefits',
                                                style: TextStyle(
                                                  color: MyTheme.grey_153,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'NotoSans',
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                      )
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CouponList()));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 18, right: 18),
                              child: Container(
                                height: 50,
                                width: MediaQuery.sizeOf(context).width - 20,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: MyTheme.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyTheme.grey_153.withOpacity(.2),
                                        offset: const Offset(0, 2),
                                        blurRadius: 2.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.local_offer,
                                      color: MyTheme.accent_color,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Apply Coupon',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 233,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: MyTheme.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: MyTheme.grey_153.withOpacity(.2),
                                  offset: const Offset(0, 2),
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                              ]),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  'ORDER DETAIL',
                                  style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'NotoSans',
                                  ),
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8, top: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .subtotal_all_capital,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        SystemConfig.systemCurrency != null
                                            ? _subTotalString!.replaceAll(
                                                SystemConfig
                                                    .systemCurrency!.code!,
                                                SystemConfig
                                                    .systemCurrency!.symbol!)
                                            : _subTotalString!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                                  .tax_all_capital +
                                              " ( " +
                                              _taxPercentage.toString() +
                                              "%)",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        SystemConfig.systemCurrency != null
                                            ? _taxString!.replaceAll(
                                                SystemConfig
                                                    .systemCurrency!.code!,
                                                SystemConfig
                                                    .systemCurrency!.symbol!)
                                            : _taxString!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .shipping_cost_all_capital,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        SystemConfig.systemCurrency != null
                                            ? _shippingCostString!.replaceAll(
                                                SystemConfig
                                                    .systemCurrency!.code!,
                                                SystemConfig
                                                    .systemCurrency!.symbol!)
                                            : _shippingCostString!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                              Row(
                                children: [
                                  Container(
                                    width: 120,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .discount_all_capital,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    SystemConfig.systemCurrency != null
                                        ? _discountString!.replaceAll(
                                            SystemConfig.systemCurrency!.code!,
                                            SystemConfig
                                                .systemCurrency!.symbol!)
                                        : _discountString!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              _discountString!.replaceAll(
                                          SystemConfig.systemCurrency!.code!,
                                          SystemConfig
                                              .systemCurrency!.symbol!) !=
                                      "Rs 0.00"
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextButton(
                                            onPressed: () {
                                              onCouponRemove();
                                            },
                                            child: Text(
                                              'Remove Coupon',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      child: Text(""),
                                    ),
                              Divider(
                                color: Colors.black.withOpacity(.5),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .grand_total_all_capital,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        SystemConfig.systemCurrency != null
                                            ? _totalString!.replaceAll(
                                                SystemConfig
                                                    .systemCurrency!.code!,
                                                SystemConfig
                                                    .systemCurrency!.symbol!)
                                            : _totalString!,
                                        style: TextStyle(
                                            color: MyTheme.accent_color,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),
              // Apply Coupon and order details container
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: widget.paymentFor == PaymentFor.WalletRecharge ||
              //           widget.paymentFor == PaymentFor.PackagePay
              //       ? Container()
              //       : Container(
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //
              //             /*border: Border(
              //         top: BorderSide(color: MyTheme.light_grey,width: 1.0),
              //       )*/
              //           ),
              //           height: widget.paymentFor == PaymentFor.ManualPayment
              //               ? 80
              //               : 140,
              //           //color: Colors.white,
              //           child: Padding(
              //             padding: const EdgeInsets.all(16.0),
              //             child: Column(
              //               children: [
              //                 widget.paymentFor == PaymentFor.Order
              //                     ? Padding(
              //                         padding:
              //                             const EdgeInsets.only(bottom: 16.0),
              //                         child: buildApplyCouponRow(context),
              //                       )
              //                     : Container(),
              //                 grandTotalSection(),
              //               ],
              //             ),
              //           ),
              //         ),
              // )
            ],
          )),
    );
  }

  Row buildApplyCouponRow(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
          child: TextFormField(
            controller: _couponController,
            readOnly: _coupon_applied!,
            autofocus: false,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enter_coupon_code,
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: app_language_rtl.$!
                    ? OutlineInputBorder(
                        borderSide: BorderSide(
                            color: MyTheme.textfield_grey, width: 0.5),
                        borderRadius: const BorderRadius.only(
                          topRight: const Radius.circular(8.0),
                          bottomRight: const Radius.circular(8.0),
                        ),
                      )
                    : OutlineInputBorder(
                        borderSide: BorderSide(
                            color: MyTheme.textfield_grey, width: 0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(8.0),
                          bottomLeft: const Radius.circular(8.0),
                        ),
                      ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.medium_grey, width: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16.0)),
          ),
        ),
        !_coupon_applied!
            ? Container(
                width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                height: 42,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: app_language_rtl.$!
                      ? RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(8.0),
                          bottomLeft: const Radius.circular(8.0),
                        ))
                      : RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                          topRight: const Radius.circular(8.0),
                          bottomRight: const Radius.circular(8.0),
                        )),
                  child: Text(
                    AppLocalizations.of(context)!.apply_coupon_all_capital,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    // onCouponApply();
                  },
                ),
              )
            : Container(
                width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                height: 42,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                    topRight: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  )),
                  child: Text(
                    AppLocalizations.of(context)!.remove_ucf,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    onCouponRemove();
                  },
                ),
              )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        widget.title!,
        style: TextStyle(
          fontSize: 16,
          color: MyTheme.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 14,
            );
          },
          itemCount: _paymentTypeList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildPaymentMethodItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _paymentTypeList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_payment_method_is_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildPaymentMethodItemCard(index) {
    return GestureDetector(
      onTap: () {
        onPaymentMethodItemTap(index);
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            decoration: BoxDecorations.buildBoxDecoration_1().copyWith(
                border: Border.all(
                    color: _selected_payment_method_key ==
                            _paymentTypeList[index].payment_type_key
                        ? MyTheme.accent_color
                        : MyTheme.light_grey,
                    width: _selected_payment_method_key ==
                            _paymentTypeList[index].payment_type_key
                        ? 2.0
                        : 0.0)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              /*Image.asset(
                          _paymentTypeList[index].image,
                          fit: BoxFit.fitWidth,
                        ),*/
                              FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: _paymentTypeList[index].payment_type ==
                                    "manual_payment"
                                ? _paymentTypeList[index].image
                                : _paymentTypeList[index].image,
                            fit: BoxFit.fitWidth,
                          ))),
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            _paymentTypeList[index].title,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: buildPaymentMethodCheckContainer(
                _selected_payment_method_key ==
                    _paymentTypeList[index].payment_type_key),
          )
        ],
      ),
    );
  }

  Widget buildPaymentMethodCheckContainer(bool check) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: check ? 1 : 0,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(Icons.check, color: Colors.white, size: 10),
        ),
      ),
    );
    /* Visibility(
      visible: check,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(Icons.check, color: Colors.white, size: 10),
        ),
      ),
    );*/
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Btn.minWidthFixHeight(
          minWidth: MediaQuery.of(context).size.width,
          height: 50,
          color: MyTheme.accent_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Text(
            widget.paymentFor == PaymentFor.WalletRecharge
                ? AppLocalizations.of(context)!.recharge_wallet_ucf
                : widget.paymentFor == PaymentFor.ManualPayment
                    ? AppLocalizations.of(context)!.proceed_all_caps
                    : widget.paymentFor == PaymentFor.PackagePay
                        ? AppLocalizations.of(context)!.buy_package_ucf
                        : AppLocalizations.of(context)!
                            .place_my_order_all_capital,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            onPressPlaceOrderOrProceed();
          },
        ),
      ),
    );
  }

  Widget grandTotalSection() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: MyTheme.soft_accent_color),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                AppLocalizations.of(context)!.total_amount_ucf,
                style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
              ),
            ),
            Visibility(
              visible: widget.paymentFor != PaymentFor.ManualPayment,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () {
                    onPressDetails();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.see_details_all_lower,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                  widget.paymentFor == PaymentFor.ManualPayment
                      ? widget.rechargeAmount.toString()
                      : SystemConfig.systemCurrency != null
                          ? _totalString!.replaceAll(
                              SystemConfig.systemCurrency!.code!,
                              SystemConfig.systemCurrency!.symbol!)
                          : _totalString!,
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
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
}
