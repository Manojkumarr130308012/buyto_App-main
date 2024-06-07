import 'package:active_ecommerce_flutter/custom/aiz_route.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/text_styles.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/cart_response.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/screens/select_address.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../custom/enum_classes.dart';
import '../custom/lang_text.dart';
import '../data_model/city_response.dart';
import '../data_model/country_response.dart';
import '../data_model/state_response.dart';
import '../repositories/address_repository.dart';
import '../repositories/coupon_repository.dart';
import '../ui_sections/drawer.dart';
import 'address.dart';
import 'checkout.dart';
import 'edit_oredr_page.dart';
import 'map_location.dart';

class Cart extends StatefulWidget {
  Cart(
      {Key? key,
      this.has_bottomnav,
      this.from_navigation = false,
      this.counter,
      this.selectedValue})
      : super(key: key);
  final bool? has_bottomnav;
  final bool from_navigation;
  final CartCounter? counter;
  final List<int?>? selectedValue;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  var _shopList = [];
  CartResponse? _shopResponse;
  bool _isInitial = true;
  var _cartTotal = 0.00;
  var _cartTotalString = ". . .";
  int _page = 1;

  List<dynamic> _shippingAddressList = [];
  int? _seleted_shipping_address = 0;
  bool _faceData = false;
  List<bool> _isChecked = [];
  int selected = 0;

  // address update

  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<TextEditingController> _cityControllerListForUpdate = [];
  List<TextEditingController> _stateControllerListForUpdate = [];
  List<TextEditingController> _countryControllerListForUpdate = [];
  List<City?> _selected_city_list_for_update = [];
  List<MyState?> _selected_state_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];

  int? _default_shipping_address = 0;
  double? cartTotal = 0.0;

  fetchShippingAddressList() async {
    // print("enter fetchShippingAddressList");
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses);
    setState(() {
      _isInitial = false;
    });
    if (_shippingAddressList.length > 0) {
      //_default_shipping_address = _shippingAddressList[0].id;

      var count = 0;
      _shippingAddressList.forEach((address) {
        //var acity = getCityByPartialName(address.city);
        //var acountry = getCountryByPartialName(address.country);
        if (address.set_default == 1) {
          _default_shipping_address = address.id;
        }
        _addressControllerListForUpdate
            .add(TextEditingController(text: address.address));
        _postalCodeControllerListForUpdate
            .add(TextEditingController(text: address.postal_code));
        _phoneControllerListForUpdate
            .add(TextEditingController(text: address.phone));
        _countryControllerListForUpdate
            .add(TextEditingController(text: address.country_name));
        _stateControllerListForUpdate
            .add(TextEditingController(text: address.state_name));
        _cityControllerListForUpdate
            .add(TextEditingController(text: address.city_name));
        _selected_country_list_for_update
            .add(Country(id: address.country_id, name: address.country_name));
        _selected_state_list_for_update
            .add(MyState(id: address.state_id, name: address.state_name));
        _selected_city_list_for_update
            .add(City(id: address.city_id, name: address.city_name));
      });

      // print("fetchShippingAddressList");
    }

    setState(() {});
  }

  resets() {
    _shippingAddressList.clear();
    _faceData = false;
    _seleted_shipping_address = 0;

    //update-ables
    _addressControllerListForUpdate.clear();
    _postalCodeControllerListForUpdate.clear();
    _phoneControllerListForUpdate.clear();
    _countryControllerListForUpdate.clear();
    _stateControllerListForUpdate.clear();
    _cityControllerListForUpdate.clear();
    _selected_city_list_for_update.clear();
    _selected_state_list_for_update.clear();
    _selected_country_list_for_update.clear();
    setState(() {});
  }

  onAddressUpdate(context, index, id) async {
    var address = _addressControllerListForUpdate[index].text.toString();
    var postal_code = _postalCodeControllerListForUpdate[index].text.toString();
    var phone = _phoneControllerListForUpdate[index].text.toString();

    if (address == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_address_ucf,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_country_list_for_update[index] == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_a_country,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_state_list_for_update[index] == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_a_state,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_city_list_for_update[index] == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.select_a_city,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var addressUpdateResponse = await AddressRepository()
        .getAddressUpdateResponse(
            id: id,
            address: address,
            country_id: _selected_country_list_for_update[index].id,
            state_id: _selected_state_list_for_update[index]!.id,
            city_id: _selected_city_list_for_update[index]!.id,
            postal_code: postal_code,
            phone: phone);

    if (addressUpdateResponse.result == false) {
      ToastComponent.showDialog(addressUpdateResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressUpdateResponse.message,
        gravity: Toast.center, duration: Toast.lengthLong);

    Navigator.of(context, rootNavigator: true).pop();
    // afterUpdatingAnAddress();
  }

  confirmSellerStatusUpdate(owner_id, status) async {
    var cartDeleteResponse =
        await CartRepository().getSellerStausResponse(owner_id, status);
    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  Widget showOptions({listIndex, productId}) {
    return Container(
      width: 45,
      child: PopupMenuButton<MenuOptions>(
        offset: Offset(-25, 0),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            width: 45,
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.topRight,
            child: Image.asset("assets/more.png",
                width: 4,
                height: 16,
                fit: BoxFit.contain,
                color: MyTheme.grey_153),
          ),
        ),
        onSelected: (MenuOptions result) {
          _tabOption(result.index, listIndex);
          // setState(() {
          //   //_menuOptionSelected = result;
          // });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
          PopupMenuItem<MenuOptions>(
            value: MenuOptions.Edit,
            child: Text(AppLocalizations.of(context)!.edit_ucf),
          ),
        ],
      ),
    );
  }

  _tabOption(int index, listIndex) {
    switch (index) {
      case 0:
        buildShowUpdateFormDialog(context, listIndex);
        break;
      case 1:
        // onPressDelete(_shippingAddressList[listIndex].id);
        onPressDelete(index, _shippingAddressList[listIndex].id);
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MapLocation(address: _shippingAddressList[listIndex]);
        })).then((value) {
          onPopped(value);
        });
        //deleteProduct(productId);
        break;
      default:
        break;
    }
  }

  Future buildShowUpdateFormDialog(BuildContext context, index) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return AlertDialog(
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
                        child: Text(
                            "${AppLocalizations.of(context)!.address_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressControllerListForUpdate[index],
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_address_ucf),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.country_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              var countryResponse = await AddressRepository()
                                  .getCountryList(name: name);
                              return countryResponse.countries;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loading_countries_ucf,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, dynamic country) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  country.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .no_country_available,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (dynamic country) {
                              onSelectCountryDuringUpdate(
                                  index, country, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller:
                                  _countryControllerListForUpdate[index],
                              onSubmitted: (txt) {
                                // keep this blank
                              },
                              decoration: buildAddressInputDecoration(
                                  context,
                                  AppLocalizations.of(context)!
                                      .enter_country_ucf),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.state_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              if (_selected_country_list_for_update[index] ==
                                  null) {
                                var stateResponse = await AddressRepository()
                                    .getStateListByCountry(); // blank response
                                return stateResponse.states;
                              }
                              var stateResponse = await AddressRepository()
                                  .getStateListByCountry(
                                      country_id:
                                          _selected_country_list_for_update[
                                                  index]
                                              .id,
                                      name: name);
                              return stateResponse.states;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loading_states_ucf,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, dynamic state) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  state.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .no_state_available,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (dynamic state) {
                              onSelectStateDuringUpdate(
                                  index, state, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller: _stateControllerListForUpdate[index],
                              onSubmitted: (txt) {
                                // _searchKey = txt;
                                // setState(() {});
                                // _onSearchSubmit();
                              },
                              decoration: buildAddressInputDecoration(
                                  context,
                                  AppLocalizations.of(context)!
                                      .enter_state_ucf),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "${AppLocalizations.of(context)!.city_ucf} *",
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TypeAheadField(
                            suggestionsCallback: (name) async {
                              if (_selected_state_list_for_update[index] ==
                                  null) {
                                var cityResponse = await AddressRepository()
                                    .getCityListByState(); // blank response
                                return cityResponse.cities;
                              }
                              var cityResponse = await AddressRepository()
                                  .getCityListByState(
                                      state_id: _selected_state_list_for_update[
                                              index]!
                                          .id,
                                      name: name);
                              return cityResponse.cities;
                            },
                            loadingBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .loading_cities_ucf,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            itemBuilder: (context, dynamic city) {
                              //print(suggestion.toString());
                              return ListTile(
                                dense: true,
                                title: Text(
                                  city.name,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .no_city_available,
                                        style: TextStyle(
                                            color: MyTheme.medium_grey))),
                              );
                            },
                            onSuggestionSelected: (dynamic city) {
                              onSelectCityDuringUpdate(
                                  index, city, setModalState);
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                              onTap: () {},
                              //autofocus: true,
                              controller: _cityControllerListForUpdate[index],
                              onSubmitted: (txt) {
                                // keep blank
                              },
                              decoration: buildAddressInputDecoration(context,
                                  AppLocalizations.of(context)!.enter_city_ucf),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(AppLocalizations.of(context)!.postal_code,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller:
                                _postalCodeControllerListForUpdate[index],
                            autofocus: false,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_postal_code_ucf),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(AppLocalizations.of(context)!.phone_ucf,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneControllerListForUpdate[index],
                            autofocus: false,
                            decoration: buildAddressInputDecoration(
                                context,
                                AppLocalizations.of(context)!
                                    .enter_phone_number),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 40,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)!.close_all_capital,
                          style: TextStyle(
                              color: MyTheme.accent_color, fontSize: 13),
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
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 40,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.update_all_capital,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onAddressUpdate(
                              context, index, _shippingAddressList[index].id);
                          resets();
                          fetchShippingAddressList();
                          fetchData();
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  onSelectCountryDuringUpdate(index, country, setModalState) {
    if (country.id == _selected_country_list_for_update[index].id) {
      setModalState(() {
        _countryControllerListForUpdate[index].text = country.name;
      });
      return;
    }
    _selected_country_list_for_update[index] = country;
    _selected_state_list_for_update[index] = null;
    _selected_city_list_for_update[index] = null;
    setState(() {});

    setModalState(() {
      _countryControllerListForUpdate[index].text = country.name;
      _stateControllerListForUpdate[index].text = "";
      _cityControllerListForUpdate[index].text = "";
    });
  }

  onSelectStateDuringUpdate(index, state, setModalState) {
    if (_selected_state_list_for_update[index] != null &&
        state.id == _selected_state_list_for_update[index]!.id) {
      setModalState(() {
        _stateControllerListForUpdate[index].text = state.name;
      });
      return;
    }
    _selected_state_list_for_update[index] = state;
    _selected_city_list_for_update[index] = null;
    setState(() {});
    setModalState(() {
      _stateControllerListForUpdate[index].text = state.name;
      _cityControllerListForUpdate[index].text = "";
    });
  }

  onSelectCityDuringUpdate(index, city, setModalState) {
    if (_selected_city_list_for_update[index] != null &&
        city.id == _selected_city_list_for_update[index]!.id) {
      setModalState(() {
        _cityControllerListForUpdate[index].text = city.name;
      });
      return;
    }
    _selected_city_list_for_update[index] = city;
    setModalState(() {
      _cityControllerListForUpdate[index].text = city.name;
    });
  }

  InputDecoration buildAddressInputDecoration(BuildContext context, hintText) {
    return InputDecoration(
        filled: true,
        fillColor: MyTheme.light_grey,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.noColor, width: 0.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.noColor, width: 1.0),
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),
        contentPadding: EdgeInsets.only(left: 8.0, top: 16.0, bottom: 16.0));
  }

  GestureDetector buildAddressItemCard(index) {
    return GestureDetector(
      onDoubleTap: () {
        if (_default_shipping_address != _shippingAddressList[index].id) {
          onAddressSwitch(_shippingAddressList[index].id);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        // decoration: BoxDecorations.buildBoxDecoration_1().copyWith(
        //     border: Border.all(
        //         color:
        //             _default_shipping_address == _shippingAddressList[index].id
        //                 ? MyTheme.accent_color
        //                 : MyTheme.light_grey,
        //         width:
        //             _default_shipping_address == _shippingAddressList[index].id
        //                 ? 1.0
        //                 : 0.0)),
        child: Stack(
          children: [
            Positioned(
                top: 3,
                left: 10,
                child: Icon(
                  Icons.pin_drop,
                  color: MyTheme.accent_color,
                  size: 22,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _shippingAddressList[index].address,
                      maxLines: 2,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _shippingAddressList[index].city_name,
                      maxLines: 2,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _shippingAddressList[index].state_name,
                      maxLines: 2,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      '${_shippingAddressList[index].country_name} - ${_shippingAddressList[index].postal_code}',
                      maxLines: 2,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans',
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _shippingAddressList[index].phone,
                      maxLines: 1,
                      style: TextStyle(
                        color: MyTheme.dark_grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSans',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                onTap: () {
                  buildShowUpdateFormDialog(context, 0);
                },
                child: Container(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 1.2, color: MyTheme.accent_color)),
                  child: Center(
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: 'NotoSans',
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            )

            /*  app_language_rtl.$
                ? Positioned(
                    left: 0,
                    top: 40.0,
                    child: InkWell(
                      onTap: () {
                        onPressDelete(_shippingAddressList[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                        child: Icon(
                          Icons.delete_forever_outlined,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    ))
                : Positioned(
                    right: 0,
                    top: 40.0,
                    child: InkWell(
                      onTap: () {
                        onPressDelete(_shippingAddressList[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                        child: Icon(
                          Icons.delete_forever_outlined,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    )),
            OtherConfig.USE_GOOGLE_MAP
                ? Positioned(
                    right: 0,
                    top: 80.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MapLocation(
                              address: _shippingAddressList[index]);
                        })).then((value) {
                          onPopped(value);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                        child: Icon(
                          Icons.location_on,
                          color: MyTheme.dark_grey,
                          size: 16,
                        ),
                      ),
                    ))
                : Container()*/
          ],
        ),
      ),
    );
  }

  onAddressSwitch(index) async {
    var addressMakeDefaultResponse =
        await AddressRepository().getAddressMakeDefaultResponse(index);

    if (addressMakeDefaultResponse.result == false) {
      ToastComponent.showDialog(addressMakeDefaultResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressMakeDefaultResponse.message,
        gravity: Toast.center, duration: Toast.lengthLong);

    setState(() {
      _default_shipping_address = index;
    });
  }

  buildAddressList() {
    // print("is Initial: ${_isInitial}");
    if (is_logged_in == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.you_need_to_log_in,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 14,
            );
          },
          itemCount: 1,
          //_shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildAddressItemCard(index);
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_address_is_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  // end add update

  buildShippingInfoList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            LangText(context).local!.you_need_to_log_in,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (!_faceData && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildShippingInfoItemCard(index),
            );
          },
        ),
      );
    } else if (_faceData && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            LangText(context).local!.no_address_is_added,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/

    if (is_logged_in.$ == true) {
      fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  getCartCount() {
    Provider.of<CartCounter>(context, listen: false).getCount();
    // var res = await CartRepository().getCartCount();
    // widget.counter.controller.sink.add(res.count);
  }

  double _totalAmountPrice = 0.0;

  fetchData() async {
    getCartCount();
    fetchShippingAddressList();
    CartResponse cartResponseList =
        await CartRepository().getCartResponseList(user_id.$);
    if (cartResponseList != null || cartResponseList.data!.length > 0) {
      _shopList = cartResponseList.data!;
      _shopResponse = cartResponseList;
      // _isChecked = List<bool>.generate(_shopList.length, (index) => false);

      getSetCartTotal();
    }

    _shopList.forEach((shop) {
      _totalAmountPrice += double.tryParse(shop.subTotal.replaceAll(
            SystemConfig.systemCurrency!.code,
            '',
          )) ??
          0.0;
      _isChecked = List<bool>.generate(_shopList.length,
          shop.status == 1 ? (index) => true : (index) => false);
    });

    _isInitial = false;
    setState(() {});
  }

  getSetCartTotal() {
    double cartTotal = 0.0;
    if (_shopResponse != null && _shopResponse!.data != null) {
      cartTotal = _shopResponse!.data!.fold(0.0, (sum, item) {
        if (item != null && item.status == 1) {
          return sum + (item.new_sub_total ?? 0);
        }
        return sum;
      });
    }

    setState(() {
      _cartTotalString = cartTotal!.toStringAsFixed(2);
      print("_cartTotalString $_cartTotalString");
    });
  }

  onQuantityIncrease(seller_index, item_index) {
    if (_shopList[seller_index].cartItems[item_index].quantity <
        _shopList[seller_index].cartItems[item_index].upperLimit) {
      _shopList[seller_index].cartItems[item_index].quantity++;
      getSetCartTotal();
      setState(() {});
      process(mode: "update");
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context)!.cannot_order_more_than} ${_shopList[seller_index].cartItems[item_index].upperLimit} ${AppLocalizations.of(context)!.items_of_this_all_lower}",
          gravity: Toast.center,
          duration: Toast.lengthLong);
    }
  }

  onQuantityDecrease(seller_index, item_index) {
    if (_shopList[seller_index].cartItems[item_index].quantity >
        _shopList[seller_index].cartItems[item_index].lowerLimit) {
      _shopList[seller_index].cartItems[item_index].quantity--;
      // getSetCartTotal();
      setState(() {});
      process(mode: "update");
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context)!.cannot_order_more_than} ${_shopList[seller_index].cartItems[item_index].lowerLimit} ${AppLocalizations.of(context)!.items_of_this_all_lower}",
          gravity: Toast.center,
          duration: Toast.lengthLong);
    }
  }

  // onPressDelete(cart_id) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             contentPadding: EdgeInsets.only(
  //                 top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
  //             content: Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //               child: Text(
  //                 AppLocalizations.of(context)!
  //                     .are_you_sure_to_remove_this_item,
  //                 maxLines: 3,
  //                 style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
  //               ),
  //             ),
  //             actions: [
  //               Btn.basic(
  //                 child: Text(
  //                   AppLocalizations.of(context)!.cancel_ucf,
  //                   style: TextStyle(color: MyTheme.medium_grey),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context, rootNavigator: true).pop();
  //                 },
  //               ),
  //               Btn.basic(
  //                 color: MyTheme.soft_accent_color,
  //                 child: Text(
  //                   AppLocalizations.of(context)!.confirm_ucf,
  //                   style: TextStyle(color: MyTheme.dark_grey),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context, rootNavigator: true).pop();
  //                   confirmDelete(cart_id);
  //                 },
  //               ),
  //             ],
  //           ));
  // }
  onPressDelete(user_id, owner_id) {
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
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    confirmDelete(user_id, owner_id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(owner_id, user_id) async {
    var cartDeleteResponse =
        await CartRepository().getSellerDeleteResponse(owner_id, user_id);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      reset();
      resets();
      fetchData();
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  // confirmDelete(cart_id) async {
  //   var cartDeleteResponse =
  //       await CartRepository().getCartDeleteResponse(cart_id);
  //
  //   if (cartDeleteResponse.result == true) {
  //     ToastComponent.showDialog(cartDeleteResponse.message,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //
  //     reset();
  //     fetchData();
  //   } else {
  //     ToastComponent.showDialog(cartDeleteResponse.message,
  //         gravity: Toast.center, duration: Toast.lengthLong);
  //   }
  // }

  onPressUpdate() {
    process(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }

  process({mode}) async {
    var cart_ids = [];
    var cart_quantities = [];
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cartItems.length > 0) {
          shop.cartItems.forEach((cart_item) {
            cart_ids.add(cart_item.id);
            cart_quantities.add(cart_item.quantity);
          });
        }
      });
    }

    if (cart_ids.length == 0) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.cart_is_empty,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();

    // print(cart_ids_string);
    // print(cart_quantities_string);

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cart_ids_string, cart_quantities_string);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      // cart update message
      // remove on
      // ToastComponent.showDialog(cartProcessResponse.message,
      //     gravity: Toast.center, duration: Toast.lengthLong);

      if (mode == "update") {
        // reset();
        fetchData();
      }
      // else if (mode == "proceed_to_shipping") {
      //   AIZRoute.push(
      //       context,
      //       Checkout(
      //         title: AppLocalizations.of(context)!.checkout_ucf,
      //         paymentFor: PaymentFor.Order,
      //       )).then((value) {
      //     onPopped(value);
      //   });
      // }
      else if (mode == "proceed_to_shipping") {
        AIZRoute.push(context, SelectAddress()).then((value) {
          onPopped(value);
        });
      }
    }
  }

  reset() {
    _shopList = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          color: MyTheme.accent_color,
          displacement: 0,
          onRefresh: _onRefresh,
          // child: Stack(
          //   children: [
          //     RefreshIndicator(
          //       color: MyTheme.accent_color,
          //       backgroundColor: Colors.white,
          //       onRefresh: _onRefresh,
          //       displacement: 0,
          //       child: CustomScrollView(
          //         controller: _mainScrollController,
          //         physics: const BouncingScrollPhysics(
          //             parent: AlwaysScrollableScrollPhysics()),
          //         slivers: [
          //           SliverList(
          //             delegate: SliverChildListDelegate([
          //               Padding(
          //                 padding: const EdgeInsets.all(16.0),
          //                 child: Container(
          //                   height: MediaQuery.sizeOf(context).height / 1.4,
          //                   child: buildCartSellerList(),
          //                 ),
          //               ),
          //             ]),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Positioned(
          //         bottom: 0,
          //         left: 10,
          //         right: 10,
          //         child: buildBottomContainer())
          //   ],
          // ),
          child: CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                // Padding(
                //   padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                //   child: Container(
                //     padding:
                //         EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
                //     // height: 150,
                //     width: MediaQuery.sizeOf(context).width,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(.08),
                //           blurRadius: 10,
                //           spreadRadius: 0.0,
                //           offset: Offset(
                //               0.0, 10.0), // shadow direction: bottom right
                //         )
                //       ],
                //     ),
                //     child: Stack(
                //       children: [
                //         Container(
                //           child: buildAddressList(),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 100),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: _shopList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: MyTheme.accent_color.withOpacity(0.1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          Colors.orangeAccent.withOpacity(0.3)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 0.0,
                                            top: 10.0,
                                            left: 10.0,
                                            right: 5.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              _shopList[index].name,
                                              style: TextStyle(
                                                  color: MyTheme.dark_font_grey,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'NotoSans',
                                                  fontSize: 14),
                                            ),
                                            Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return SellerDetails(
                                                      id: _shopList[index]
                                                          .shopId);
                                                }));
                                              },
                                              child: Container(
                                                height: 30,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width /
                                                        3.75,
                                                decoration: BoxDecorations
                                                    .buildBoxDecoration_1(),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.shopify,
                                                      size: 25,
                                                      color:
                                                          MyTheme.accent_color,
                                                    ),
                                                    Text(
                                                      'Visit Store',
                                                      style: TextStyle(
                                                        color: MyTheme
                                                            .accent_color,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'NotoSans',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Text(
                                            //   _shopList[index].subTotal.replaceAll(
                                            //           SystemConfig
                                            //               .systemCurrency!.code,
                                            //           SystemConfig.systemCurrency!
                                            //               .symbol) ??
                                            //       '',
                                            //   style: TextStyle(
                                            //       color: MyTheme.accent_color,
                                            //       fontWeight: FontWeight.w600,
                                            //       fontFamily: 'NotoSans',
                                            //       fontSize: 14),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 0.0, left: 10.0),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Min. Order Value: ₹ ${_shopList[index].cartItems[0].minimumOrderValue}',
                                                style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'NotoSans',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, left: 10.0, right: 5.0),
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.local_shipping,
                                                size: 18,
                                                color: MyTheme.accent_color,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Free Shipping',
                                                style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'NotoSans',
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                _shopList[index]
                                                        .subTotal
                                                        .replaceAll(
                                                            SystemConfig
                                                                .systemCurrency!
                                                                .code,
                                                            SystemConfig
                                                                .systemCurrency!
                                                                .symbol) ??
                                                    '',
                                                style: TextStyle(
                                                    color: MyTheme.accent_color,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'NotoSans',
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(5.0)),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 10.0,
                                )),
                                buildCartSellerItemList(index),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 10.0, right: 10.0),
                                  child: Container(
                                    height: 45,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditOrder(
                                                          owner_id:
                                                              _shopList[index]
                                                                  .ownerId,
                                                          minimumvalue: _shopList[
                                                                  index]
                                                              .cartItems[0]
                                                              .minimumOrderValue,
                                                          shopId:
                                                              _shopList[index]
                                                                  .shopId,
                                                        )));
                                          },
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                1.325,
                                            decoration: BoxDecorations
                                                .buildBoxDecoration_1(),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'EDIT ORDER ',
                                                  style: TextStyle(
                                                    color: MyTheme.accent_color,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'NotoSans',
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Icon(
                                                  Icons.pin_end,
                                                  size: 25,
                                                  color: MyTheme.accent_color,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        InkWell(
                                          onTap: () {
                                            onPressDelete(
                                              user_id.$,
                                              _shopList[index].ownerId,
                                            );
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecorations
                                                .buildBoxDecoration_1(),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 5, bottom: 0),
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.08),
                                          blurRadius: 10,
                                          spreadRadius: 0.0,
                                          offset: Offset(0.0,
                                              10.0), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          child: Row(children: [
                                            Checkbox(
                                                value: _isChecked[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isChecked[index] = value!;
                                                    selected = _isChecked[index]
                                                        ? 1
                                                        : 0;
                                                    confirmSellerStatusUpdate(
                                                        _shopList[index]
                                                            .ownerId,
                                                        selected);
                                                    _shopResponse!.data![index]
                                                        .status = selected;

                                                    double cartTotal = 0.0;
                                                    if (_shopResponse != null &&
                                                        _shopResponse!.data !=
                                                            null) {
                                                      cartTotal = _shopResponse!
                                                          .data!
                                                          .fold(0.0,
                                                              (sum, item) {
                                                        if (item != null &&
                                                            item.status == 1) {
                                                          return sum +
                                                              (item.new_sub_total ??
                                                                  0);
                                                        }
                                                        return sum;
                                                      });
                                                    }

                                                    _cartTotalString =
                                                        cartTotal!
                                                            .toStringAsFixed(2);
                                                    print(
                                                        "_cartTotalString $_cartTotalString");
                                                  });
                                                }),
                                            Text(
                                              _shopList[index]
                                                      .subTotal
                                                      .replaceAll(
                                                          SystemConfig
                                                              .systemCurrency!
                                                              .code,
                                                          SystemConfig
                                                              .systemCurrency!
                                                              .symbol) ??
                                                  '',
                                              style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'NotoSans',
                                                  fontSize: 14),
                                            ),
                                            Spacer(),
                                            _shopList[index].new_sub_total >
                                                    _shopList[index]
                                                        .cartItems[0]
                                                        .minimumOrderValue
                                                ? InkWell(
                                                    onTap: () {
                                                      if (selected == 0) {
                                                        ToastComponent.showDialog(
                                                            'Please select any one Seller',
                                                            gravity:
                                                                Toast.bottom,
                                                            duration: Toast
                                                                .lengthLong);
                                                        return;
                                                      } else {
                                                        onPressProceedToShipping();
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width /
                                                          3,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: MyTheme
                                                              .accent_color),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.shopping_cart,
                                                            size: 18,
                                                            color:
                                                                MyTheme.white,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'ORDER',
                                                            style: TextStyle(
                                                              color:
                                                                  MyTheme.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'NotoSans',
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              size: 18,
                                                              color: MyTheme
                                                                  .white),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return SellerDetails(
                                                            id: _shopList[index]
                                                                .shopId);
                                                      }));
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width /
                                                          3,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: MyTheme
                                                              .accent_color),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Add Product',
                                                            style: TextStyle(
                                                              color:
                                                                  MyTheme.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'NotoSans',
                                                            ),
                                                          ),
                                                          Icon(
                                                              Icons
                                                                  .arrow_forward_ios_outlined,
                                                              size: 18,
                                                              color: MyTheme
                                                                  .white),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
                // Container(
                //   height: 140,
                //   width: MediaQuery.sizeOf(context).width,
                //   padding: EdgeInsets.only(left: 15, right: 15),
                //   child: ListView.builder(
                //       itemCount: _shopList.length,
                //       physics: NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         return Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.only(bottom: 12.0),
                //               child: Row(
                //                 children: [
                //                   Text(
                //                     'Liberty shoes limit',
                //                     style: TextStyle(
                //                         color: MyTheme.dark_font_grey,
                //                         fontWeight: FontWeight.w500,
                //                         fontFamily: 'NotoSans',
                //                         fontSize: 15),
                //                   ),
                //                   Spacer(),
                //                   Text(
                //                     _shopList[index].subTotal.replaceAll(
                //                             SystemConfig.systemCurrency!.code,
                //                             SystemConfig
                //                                 .systemCurrency!.symbol) ??
                //                         '',
                //                     style: TextStyle(
                //                         color: MyTheme.accent_color,
                //                         fontWeight: FontWeight.w700,
                //                         fontFamily: 'NotoSans',
                //                         fontSize: 12),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             buildCartSellerItemList(index),
                //           ],
                //         );
                //       }),
                // ),
                // SizedBox(height: 10),
              ])),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 60,
          color: Colors.white,
          width: MediaQuery.sizeOf(context).width - 30,
          child: Row(
            children: [
              Container(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_isChecked.where((x) => x == true).length} Order Checkout',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NotoSans',
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _cartTotalString ?? '',
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'NotoSans',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: 45,
                color: MyTheme.accent_color,
                // width: MediaQuery.sizeOf(context).width / 3.1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: MyTheme.accent_color),
                  onPressed: () async {
                    if (_cartTotalString == "0.00") {
                      ToastComponent.showDialog('Please select any one seller',
                          gravity: Toast.center, duration: Toast.lengthLong);
                      return;
                    } else {
                      onPressProceedToShipping();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   'Order Now',
                      //   style: TextStyle(
                      //       color: MyTheme.white,
                      //       fontFamily: 'NotoSans',
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.w700),
                      // ),
                      // Icon(Icons.arrow_forward_ios_outlined,
                      //     size: 14, color: MyTheme.white),
                      Icon(
                        Icons.shopping_cart,
                        size: 18,
                        color: MyTheme.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'ORDER NOW',
                        style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward, size: 18, color: MyTheme.white),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Container(
              height: 40,
              // width: double.infinity,
              width: MediaQuery.sizeOf(context).width - 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: MyTheme.soft_accent_color),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.total_amount_ucf,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey,
                          fontSize: 13,
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(_cartTotalString,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Container(
                //     width: (MediaQuery.of(context).size.width - 48) * (1 / 3),
                //     height: 58,
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         // border:
                //         //     Border.all(color: MyTheme.accent_color, width: 1),
                //         borderRadius: app_language_rtl.$!
                //             ? const BorderRadius.only(
                //                 topLeft: const Radius.circular(0.0),
                //                 bottomLeft: const Radius.circular(0.0),
                //                 topRight: const Radius.circular(6.0),
                //                 bottomRight: const Radius.circular(6.0),
                //               )
                //             : const BorderRadius.only(
                //                 topLeft: const Radius.circular(6.0),
                //                 bottomLeft: const Radius.circular(6.0),
                //                 topRight: const Radius.circular(0.0),
                //                 bottomRight: const Radius.circular(0.0),
                //               )),
                //     child: Btn.basic(
                //       minWidth: MediaQuery.of(context).size.width,
                //       color: MyTheme.soft_accent_color,
                //       shape: app_language_rtl.$!
                //           ? RoundedRectangleBorder(
                //               borderRadius: const BorderRadius.only(
                //               topLeft: const Radius.circular(0.0),
                //               bottomLeft: const Radius.circular(0.0),
                //               topRight: const Radius.circular(6.0),
                //               bottomRight: const Radius.circular(6.0),
                //             ))
                //           : RoundedRectangleBorder(
                //               borderRadius: const BorderRadius.only(
                //               topLeft: const Radius.circular(6.0),
                //               bottomLeft: const Radius.circular(6.0),
                //               topRight: const Radius.circular(0.0),
                //               bottomRight: const Radius.circular(0.0),
                //             )),
                //       child: Text(
                //         AppLocalizations.of(context)!.update_cart_ucf,
                //         style: TextStyle(
                //             color: MyTheme.dark_font_grey,
                //             fontSize: 13,
                //             fontWeight: FontWeight.w700),
                //       ),
                //       onPressed: () {
                //         onPressUpdate();
                //       },
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 58,
                    width: (MediaQuery.of(context).size.width - 48),
                    // width: (MediaQuery.of(context).size.width - 48) * (2 / 3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: MyTheme.accent_color, width: 1),
                        borderRadius: app_language_rtl.$!
                            ? const BorderRadius.only(
                                topLeft: const Radius.circular(6.0),
                                bottomLeft: const Radius.circular(6.0),
                                topRight: const Radius.circular(6.0),
                                bottomRight: const Radius.circular(6.0),
                              )
                            : const BorderRadius.only(
                                topLeft: const Radius.circular(6.0),
                                bottomLeft: const Radius.circular(6.0),
                                topRight: const Radius.circular(6.0),
                                bottomRight: const Radius.circular(6.0),
                              )),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: MyTheme.accent_color,
                      shape: app_language_rtl.$!
                          ? RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(6.0),
                              bottomLeft: const Radius.circular(6.0),
                              topRight: const Radius.circular(0.0),
                              bottomRight: const Radius.circular(0.0),
                            ))
                          : RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(0.0),
                              bottomLeft: const Radius.circular(0.0),
                              topRight: const Radius.circular(6.0),
                              bottomRight: const Radius.circular(6.0),
                            )),
                      child: Text(
                        AppLocalizations.of(context)!.proceed_to_shipping_ucf,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        onPressProceedToShipping();
                      },
                    ),
                  ),
                ),
              ],
            )
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(top: 8.0),
            //       child: Container(
            //         width: (MediaQuery.of(context).size.width - 48) * (1 / 3),
            //         height: 58,
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             // border:
            //             //     Border.all(color: MyTheme.accent_color, width: 1),
            //             borderRadius: app_language_rtl.$!
            //                 ? const BorderRadius.only(
            //                     topLeft: const Radius.circular(0.0),
            //                     bottomLeft: const Radius.circular(0.0),
            //                     topRight: const Radius.circular(6.0),
            //                     bottomRight: const Radius.circular(6.0),
            //                   )
            //                 : const BorderRadius.only(
            //                     topLeft: const Radius.circular(6.0),
            //                     bottomLeft: const Radius.circular(6.0),
            //                     topRight: const Radius.circular(0.0),
            //                     bottomRight: const Radius.circular(0.0),
            //                   )),
            //         child: Btn.basic(
            //           minWidth: MediaQuery.of(context).size.width,
            //           color: MyTheme.soft_accent_color,
            //           shape: app_language_rtl.$!
            //               ? RoundedRectangleBorder(
            //                   borderRadius: const BorderRadius.only(
            //                   topLeft: const Radius.circular(0.0),
            //                   bottomLeft: const Radius.circular(0.0),
            //                   topRight: const Radius.circular(6.0),
            //                   bottomRight: const Radius.circular(6.0),
            //                 ))
            //               : RoundedRectangleBorder(
            //                   borderRadius: const BorderRadius.only(
            //                   topLeft: const Radius.circular(6.0),
            //                   bottomLeft: const Radius.circular(6.0),
            //                   topRight: const Radius.circular(0.0),
            //                   bottomRight: const Radius.circular(0.0),
            //                 )),
            //           child: Text(
            //             AppLocalizations.of(context)!.update_cart_ucf,
            //             style: TextStyle(
            //                 color: MyTheme.dark_font_grey,
            //                 fontSize: 13,
            //                 fontWeight: FontWeight.w700),
            //           ),
            //           onPressed: () {
            //             onPressUpdate();
            //           },
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(top: 8.0),
            //       child: Container(
            //         height: 58,
            //         width: (MediaQuery.of(context).size.width - 48),
            //         // width: (MediaQuery.of(context).size.width - 48) * (2 / 3),
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             border:
            //                 Border.all(color: MyTheme.accent_color, width: 1),
            //             borderRadius: app_language_rtl.$!
            //                 ? const BorderRadius.only(
            //                     topLeft: const Radius.circular(6.0),
            //                     bottomLeft: const Radius.circular(6.0),
            //                     topRight: const Radius.circular(6.0),
            //                     bottomRight: const Radius.circular(6.0),
            //                   )
            //                 : const BorderRadius.only(
            //                     topLeft: const Radius.circular(6.0),
            //                     bottomLeft: const Radius.circular(6.0),
            //                     topRight: const Radius.circular(6.0),
            //                     bottomRight: const Radius.circular(6.0),
            //                   )),
            //         child: Btn.basic(
            //           minWidth: MediaQuery.of(context).size.width,
            //           color: MyTheme.accent_color,
            //           shape: app_language_rtl.$!
            //               ? RoundedRectangleBorder(
            //                   borderRadius: const BorderRadius.only(
            //                   topLeft: const Radius.circular(6.0),
            //                   bottomLeft: const Radius.circular(6.0),
            //                   topRight: const Radius.circular(0.0),
            //                   bottomRight: const Radius.circular(0.0),
            //                 ))
            //               : RoundedRectangleBorder(
            //                   borderRadius: const BorderRadius.only(
            //                   topLeft: const Radius.circular(0.0),
            //                   bottomLeft: const Radius.circular(0.0),
            //                   topRight: const Radius.circular(6.0),
            //                   bottomRight: const Radius.circular(6.0),
            //                 )),
            //           child: Text(
            //             AppLocalizations.of(context)!.proceed_to_shipping_ucf,
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 13,
            //                 fontWeight: FontWeight.w700),
            //           ),
            //           onPressed: () {
            //             onPressProceedToShipping();
            //           },
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
      leading: Builder(
        builder: (context) => widget.from_navigation
            ? UsefulElements.backToMain(context, go_back: false)
            : UsefulElements.backButton(context),
      ),
      title: Text(
        AppLocalizations.of(context)!.shopping_cart_ucf,
        style: TextStyles.buildAppBarTexStyle(),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildCartSellerList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.please_log_in_to_see_the_cart_items,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shopList.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 26,
          ),
          itemCount: _shopList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Text(
                        _shopList[index].name,
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSans',
                            fontSize: 12),
                      ),
                      Spacer(),
                      Text(
                        _shopList[index].subTotal.replaceAll(
                                SystemConfig.systemCurrency!.code,
                                SystemConfig.systemCurrency!.symbol) ??
                            '',
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'NotoSans',
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                buildCartSellerItemList(index),
              ],
            );
          },
        ),
      );
    } else if (!_isInitial && _shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.cart_is_empty,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  // SingleChildScrollView buildCartSellerItemList(seller_index) {
  //   return SingleChildScrollView(
  //     child: ListView.separated(
  //       separatorBuilder: (context, index) => SizedBox(
  //         height: 14,
  //       ),
  //       itemCount: _shopList[seller_index].cartItems.length,
  //       scrollDirection: Axis.vertical,
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemBuilder: (context, index) {
  //         return buildCartSellerItemCard(seller_index, index);
  //       },
  //     ),
  //   );
  // }

  SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 110,
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 10,
          ),
          itemCount: _shopList[seller_index].cartItems.length,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetails(
                        id: _shopList[seller_index].cartItems[index].productId,
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: MyTheme.accent_color.withOpacity(.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(4), right: Radius.zero),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: _shopList[seller_index]
                                  .cartItems[index]
                                  .productThumbnailImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )),
                        Padding(padding: EdgeInsets.only(top: 5.0)),
                        Text(
                            'Quantity: ${_shopList[seller_index].cartItems[index].quantity}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: 'NotoSans',
                                fontWeight: FontWeight.w700))
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  // buildCartSellerItemCard(seller_index, item_index) {
  //   return Container(
  //     height: 120,
  //     decoration: BoxDecorations.buildBoxDecoration_1(),
  //     child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Container(
  //               width: DeviceInfo(context).width! / 4,
  //               height: 120,
  //               child: ClipRRect(
  //                   borderRadius: BorderRadius.horizontal(
  //                       left: Radius.circular(6), right: Radius.zero),
  //                   child: FadeInImage.assetNetwork(
  //                     placeholder: 'assets/placeholder.png',
  //                     image: _shopList[seller_index]
  //                         .cartItems[item_index]
  //                         .productThumbnailImage,
  //                     fit: BoxFit.cover,
  //                   ))),
  //           Container(
  //             // color: Colors.red,
  //             width: DeviceInfo(context).width! - 170,
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 10.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     _shopList[seller_index].cartItems[item_index].productName,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 2,
  //                     style: TextStyle(
  //                         color: MyTheme.font_grey,
  //                         fontSize: 14,
  //                         fontFamily: 'NotoSans',
  //                         fontWeight: FontWeight.w400),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 23.0),
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           SystemConfig.systemCurrency != null
  //                               ? _shopList[seller_index]
  //                                   .cartItems[item_index]
  //                                   .price
  //                                   .replaceAll(
  //                                       SystemConfig.systemCurrency!.code,
  //                                       SystemConfig.systemCurrency!.symbol)
  //                               : _shopList[seller_index]
  //                                   .cart_items[item_index]
  //                                   .price,
  //                           textAlign: TextAlign.left,
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 2,
  //                           style: TextStyle(
  //                               color: MyTheme.accent_color,
  //                               fontSize: 14,
  //                               fontFamily: 'NotoSans',
  //                               fontWeight: FontWeight.w400),
  //                         ),
  //                         Padding(padding: EdgeInsets.only(left: 20)),
  //                         Text(
  //                           "Qty : " +
  //                               _shopList[seller_index]
  //                                   .cartItems[item_index]
  //                                   .quantity
  //                                   .toString(),
  //                           style: TextStyle(
  //                               color: MyTheme.font_grey,
  //                               fontSize: 14,
  //                               fontFamily: 'NotoSans',
  //                               fontWeight: FontWeight.w400),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Spacer(),
  //           Container(
  //             width: 32,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     onPressDelete(
  //                         _shopList[seller_index].cartItems[item_index].id);
  //                   },
  //                   child: Container(
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(bottom: 14.0),
  //                       child: Image.asset(
  //                         'assets/trash.png',
  //                         height: 16,
  //                         color: Colors.red,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //           // Padding(
  //           //   padding: const EdgeInsets.all(14.0),
  //           //   child: Column(
  //           //     mainAxisAlignment: MainAxisAlignment.end,
  //           //     children: [
  //           //       GestureDetector(
  //           //         onTap: () {
  //           //           if (_shopList[seller_index]
  //           //                   .cartItems[item_index]
  //           //                   .auctionProduct ==
  //           //               0) {
  //           //             onQuantityIncrease(seller_index, item_index);
  //           //           }
  //           //           return null;
  //           //         },
  //           //         child: Container(
  //           //           width: 24,
  //           //           height: 24,
  //           //           decoration:
  //           //               BoxDecorations.buildCartCircularButtonDecoration(),
  //           //           child: Icon(
  //           //             Icons.add,
  //           //             color: _shopList[seller_index]
  //           //                         .cartItems[item_index]
  //           //                         .auctionProduct ==
  //           //                     0
  //           //                 ? MyTheme.accent_color
  //           //                 : MyTheme.grey_153,
  //           //             size: 12,
  //           //           ),
  //           //         ),
  //           //       ),
  //           //       Padding(
  //           //         padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
  //           //         child: Text(
  //           //           _shopList[seller_index]
  //           //               .cartItems[item_index]
  //           //               .quantity
  //           //               .toString(),
  //           //           style:
  //           //               TextStyle(color: MyTheme.accent_color, fontSize: 16),
  //           //         ),
  //           //       ),
  //           //       GestureDetector(
  //           //         onTap: () {
  //           //           if (_shopList[seller_index]
  //           //                   .cartItems[item_index]
  //           //                   .auctionProduct ==
  //           //               0) {
  //           //             onQuantityDecrease(seller_index, item_index);
  //           //           }
  //           //           return null;
  //           //         },
  //           //         child: Container(
  //           //           width: 24,
  //           //           height: 24,
  //           //           decoration:
  //           //               BoxDecorations.buildCartCircularButtonDecoration(),
  //           //           child: Icon(
  //           //             Icons.remove,
  //           //             color: _shopList[seller_index]
  //           //                         .cartItems[item_index]
  //           //                         .auctionProduct ==
  //           //                     0
  //           //                 ? MyTheme.accent_color
  //           //                 : MyTheme.grey_153,
  //           //             size: 12,
  //           //           ),
  //           //         ),
  //           //       ),
  //           //     ],
  //           //   ),
  //           // )
  //         ]),
  //   );
  // }

  // new creation work

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_address != _shippingAddressList[index].id) {
          _seleted_shipping_address = _shippingAddressList[index].id;

          // onAddressSwitch();
        }
        //detectShippingOption();
        setState(() {});
      },
      child: buildShippingInfoItemChildren(index),
    );
  }

  Column buildShippingInfoItemChildren(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildShippingInfoItemAddress(index),
        buildShippingInfoItemCity(index),
        buildShippingInfoItemState(index),
        buildShippingInfoItemCountry(index),
        buildShippingInfoItemPhone(index),
      ],
    );
  }

  Padding buildShippingInfoItemState(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _shippingAddressList[index].state_name,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemCity(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _shippingAddressList[index].city_name,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemAddress(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _shippingAddressList[index].address,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemCountry(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _shippingAddressList[index].country_name,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
          ),
          Text('-'),
          Text(
            _shippingAddressList[index].postal_code,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemPhone(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _shippingAddressList[index].phone,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

//address update
}
