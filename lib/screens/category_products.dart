import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../custom/btn.dart';
import '../custom/toast_component.dart';
import '../helpers/reg_ex_inpur_formatter.dart';
import '../helpers/shared_value_helper.dart';
import '../presenter/cart_counter.dart';
import '../repositories/brand_repository.dart';
import '../repositories/color_category_repository.dart';
import '../repositories/gender_category_repository.dart';
import '../repositories/search_repository.dart';
import '../repositories/seller_category_repository.dart';
import '../repositories/shop_repository.dart';
import '../repositories/size_category_repository.dart';
import '../repositories/sole_category_repository.dart';
import '../repositories/sub_category_repository.dart';
import '../ui_elements/brand_square_card.dart';
import '../ui_elements/shop_square_card.dart';
import 'cart.dart';
import 'filter.dart';
import 'package:badges/badges.dart' as badges;

class CategoryProducts extends StatefulWidget {
  CategoryProducts(
      {Key? key,
      this.category_name,
      this.category_id,
      this.selected_filter = "product"})
      : super(key: key);
  final String? category_name;
  final int? category_id;
  final String selected_filter;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class WhichFilter {
  String option_key;
  String name;

  WhichFilter(this.option_key, this.name);

  static List<WhichFilter> getWhichFilterList() {
    return <WhichFilter>[
      WhichFilter(
          "product", AppLocalizations.of(OneContext().context!)!.product_ucf),
      WhichFilter(
          'sellers', AppLocalizations.of(OneContext().context!)!.sellers_ucf),
      WhichFilter(
          'brands', AppLocalizations.of(OneContext().context!)!.brands_ucf),
    ];
  }
}

class _CategoryProductsState extends State<CategoryProducts> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  ScrollController _brandScrollController = ScrollController();
  ScrollController _shopScrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  ScrollController _productScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic> _productList = [];
  List<Category> _subCategoryList = [];
  List<Sole> _soleCategoryList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int? _totalData = 0;
  bool _showLoadingContainer = false;
  bool _showSearchBar = false;

  //Filte Related things
  WhichFilter? _selectedFilter;
  String? _givenSelectedFilterOptionKey; // may be it can come from another page
  String? _selectedSort = "";

  List<WhichFilter> _which_filter_list = WhichFilter.getWhichFilterList();
  List<DropdownMenuItem<WhichFilter>>? _dropdownWhichFilterItems;
  List<dynamic> _selectedCategories = [];
  List<dynamic> _selectedBrands = [];
  List<dynamic> _selectedSubCategories = [];
  List<dynamic> _selectedSoleCategories = [];
  List<dynamic> _selectedColorCategories = [];
  List<dynamic> _selectedGenderCategories = [];
  List<dynamic> _selectedSizeCategories = [];
  List<dynamic> _selectedSellerCategories = [];

  final TextEditingController _minPriceController = new TextEditingController();
  final TextEditingController _maxPriceController = new TextEditingController();

  List<dynamic> _filterBrandList = [];
  bool _filteredBrandsCalled = false;
  List<dynamic> _filterCategoryList = [];
  bool _filteredCategoriesCalled = false;

  List<dynamic> _filterSubCategoryList = [];
  bool _filteredSubCategoriesCalled = false;

  List<dynamic> _filterSoleCategoryList = [];
  bool _filteredSoleCategoriesCalled = false;

  List<dynamic> _filterColorCategoryList = [];
  bool _filteredColorCategoriesCalled = false;

  List<dynamic> _filterGenderCategoryList = [];
  bool _filteredGenderCategoriesCalled = false;

  List<dynamic> _filterSizeCategoryList = [
    {
      "id": 1,
      "name": "PVC",
      "logo":
          "https://buyto.in/admin/public/uploads/all/GfNGf6fZSb83Vazxr25qiFBKa591u3BCMtrRAGxn.webp",
      "links": {"products": "https://buyto.in/admin/api/v2/products/sole/1"}
    },
  ];
  bool _filteredSizeCategoriesCalled = false;

  List<dynamic> _filterSellerCategoryList = [];
  bool _filteredSellerCategoriesCalled = false;

  bool _isProductInitial = true;
  int _productPage = 1;
  int? _totalProductData = 0;
  bool _showProductLoadingContainer = false;

  List<dynamic> _brandList = [];
  bool _isBrandInitial = true;
  int _brandPage = 1;
  int? _totalBrandData = 0;
  bool _showBrandLoadingContainer = false;

  List<dynamic> _shopList = [];
  bool _isShopInitial = true;
  int _shopPage = 1;
  int? _totalShopData = 0;
  bool _showShopLoadingContainer = false;
  bool _isInWishList = false;

  List<DropdownMenuItem<WhichFilter>> buildDropdownWhichFilterItems(
      List which_filter_list) {
    List<DropdownMenuItem<WhichFilter>> items = [];
    for (WhichFilter which_filter_item
        in which_filter_list as Iterable<WhichFilter>) {
      items.add(
        DropdownMenuItem(
          value: which_filter_item,
          child: Text(which_filter_item.name),
        ),
      );
    }
    return items;
  }

  getSubCategory() async {
    var res =
        await CategoryRepository().getCategories(parent_id: widget.category_id);
    _subCategoryList.addAll(res.categories!);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
    fetchAllDate();

    _xcrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  init() {
    _givenSelectedFilterOptionKey = widget.selected_filter;
    _dropdownWhichFilterItems =
        buildDropdownWhichFilterItems(_which_filter_list);
    _selectedFilter = _dropdownWhichFilterItems![0].value;
    for (int x = 0; x < _dropdownWhichFilterItems!.length; x++) {
      if (_dropdownWhichFilterItems![x].value!.option_key ==
          _givenSelectedFilterOptionKey) {
        _selectedFilter = _dropdownWhichFilterItems![x].value;
      }
    }

    fetchFilteredCategories();
    fetchFilteredBrands();
    fetchFilteredSubCategories();
    fetchFilteredSoleCategories();
    fetchFilteredColorCategories();
    fetchFilteredGenderCategories();
    // fetchFilteredSizeCategories();
    fetchFilteredSellerCategories();

    if (_selectedFilter!.option_key == "sellers") {
      fetchShopData();
    } else if (_selectedFilter!.option_key == "brands") {
      fetchBrandData();
    } else {
      fetchProductData();
    }

    //set scroll listeners

    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchProductData();
      }
    });

    _brandScrollController.addListener(() {
      if (_brandScrollController.position.pixels ==
          _brandScrollController.position.maxScrollExtent) {
        setState(() {
          _brandPage++;
        });
        _showBrandLoadingContainer = true;
        fetchBrandData();
      }
    });

    _shopScrollController.addListener(() {
      if (_shopScrollController.position.pixels ==
          _shopScrollController.position.maxScrollExtent) {
        setState(() {
          _shopPage++;
        });
        _showShopLoadingContainer = true;
        fetchShopData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchFilteredBrands() async {
    var filteredBrandResponse = await BrandRepository().getFilterPageBrands();
    _filterBrandList.addAll(filteredBrandResponse.brands!);
    _filteredBrandsCalled = true;
    setState(() {});
  }

  fetchFilteredCategories() async {
    var filteredCategoriesResponse =
        await CategoryRepository().getFilterPageCategories();
    _filterCategoryList.addAll(filteredCategoriesResponse.categories!);
    _filteredCategoriesCalled = true;
    setState(() {});
  }

  fetchFilteredSubCategories() async {
    var filteredSubCategoriesResponse =
        await SubCategoryRepository().getFilterPageSubCategory();
    _filterSubCategoryList.addAll(filteredSubCategoriesResponse.subcategory!);
    _filteredSubCategoriesCalled = true;
    setState(() {});
  }

  fetchFilteredSoleCategories() async {
    var filteredSoleCategoriesResponse =
        await SoleCategoryRepository().getFilterPageSoleCategory();
    _filterSoleCategoryList
        .addAll(filteredSoleCategoriesResponse.solecategory!);
    _filteredSoleCategoriesCalled = true;
    setState(() {});
  }

  fetchFilteredColorCategories() async {
    var filteredColorCategoriesResponse =
        await ColorCategoryRepository().getFilterPageColorCategory();
    _filterColorCategoryList
        .addAll(filteredColorCategoriesResponse.colorcategory!);
    _filteredColorCategoriesCalled = true;
    setState(() {});
  }

  fetchFilteredGenderCategories() async {
    var filteredGenderCategoriesResponse =
        await GenderCategoryRepository().getFilterPageGenderCategory();
    _filterGenderCategoryList
        .addAll(filteredGenderCategoriesResponse.gendercategory!);
    _filteredGenderCategoriesCalled = true;
    setState(() {});
  }

  fetchFilteredSizeCategories() async {
    var filteredSizeCategoriesResponse =
        await SizeCategoryRepository().getFilterPageSizeCategory();
    _filterSizeCategoryList
        .addAll(filteredSizeCategoriesResponse.sizecategory!);
    _filteredSizeCategoriesCalled = true;
    setState(() {});
  }

  fetchFilteredSellerCategories() async {
    var filteredSellerCategoriesResponse =
        await SellerCategoryRepository().getFilterPageSellerCategory();
    _filterSellerCategoryList
        .addAll(filteredSellerCategoriesResponse.sellercategory!);
    _filteredSellerCategoriesCalled = true;
    setState(() {});
  }

  fetchData() async {
    var productResponse = await ProductRepository().getCategoryProducts(
        id: widget.category_id, page: _page, name: _searchKey);
    _productList.addAll(productResponse.products!);
    _isInitial = false;
    _totalData = productResponse.meta!.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  fetchAllDate() {
    fetchData();
    getSubCategory();
  }

  reset() {
    _subCategoryList.clear();
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAllDate();
  }

  _onWhichFilterChange() {
    if (_selectedFilter!.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter!.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  onPopped(value) async {
    reset();
    fetchAllDate();
  }

  _onSortChange() {
    reset();
    resetProductList();
    fetchProductData();
  }

  resetProductList() {
    _productList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  _onSearchSubmit() {
    reset();
    if (_selectedFilter!.option_key == "sellers") {
      // resetShopList();
      // fetchShopData();
    } else if (_selectedFilter!.option_key == "brands") {
      // resetBrandList();
      // fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  fetchProductData() async {
    //print("sc:"+_selectedCategories.join(",").toString());
    //print("sb:"+_selectedBrands.join(",").toString());
    var productResponse = await ProductRepository().getFilteredProducts(
        page: _productPage,
        name: _searchKey,
        sort_key: _selectedSort,
        brands: _selectedBrands.join(",").toString(),
        categories: _selectedCategories.join(",").toString(),
        max: _maxPriceController.text.toString(),
        min: _minPriceController.text.toString());

    _productList.addAll(productResponse.products!);
    _isProductInitial = false;
    _totalProductData = productResponse.meta!.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  Row buildBottomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                  vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                  horizontal: BorderSide(color: MyTheme.light_grey, width: 1))),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 36,
          width: MediaQuery.of(context).size.width * .33,
          child: new DropdownButton<WhichFilter>(
            icon: Padding(
              padding: app_language_rtl.$!
                  ? const EdgeInsets.only(right: 18.0)
                  : const EdgeInsets.only(left: 18.0),
              child: Icon(Icons.expand_more, color: Colors.black54),
            ),
            hint: Text(
              AppLocalizations.of(context)!.products_ucf,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
            style: TextStyle(color: Colors.black, fontSize: 13),
            iconSize: 13,
            underline: SizedBox(),
            value: _selectedFilter,
            items: _dropdownWhichFilterItems,
            onChanged: (WhichFilter? selectedFilter) {
              setState(() {
                _selectedFilter = selectedFilter;
              });

              _onWhichFilterChange();
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            _selectedFilter!.option_key == "product"
                ? _scaffoldKey.currentState!.openEndDrawer()
                : ToastComponent.showDialog(
                    AppLocalizations.of(context)!
                        .you_can_use_sorting_while_searching_for_products,
                    gravity: Toast.center,
                    duration: Toast.lengthLong);
            ;
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: Center(
                child: Container(
              width: 50,
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 13,
                  ),
                  SizedBox(width: 2),
                  Text(
                    AppLocalizations.of(context)!.filter_ucf,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
        GestureDetector(
          onTap: () {
            _selectedFilter!.option_key == "product"
                ? showDialog(
                    context: context,
                    builder: (_) => Directionality(
                          textDirection: app_language_rtl.$!
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: AlertDialog(
                            contentPadding: EdgeInsets.only(
                                top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                            content: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .sort_products_by_ucf,
                                      )),
                                  RadioListTile(
                                    dense: true,
                                    value: "",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(AppLocalizations.of(context)!
                                        .default_ucf),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "price_high_to_low",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(AppLocalizations.of(context)!
                                        .price_high_to_low),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "price_low_to_high",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(AppLocalizations.of(context)!
                                        .price_low_to_high),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "new_arrival",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(AppLocalizations.of(context)!
                                        .new_arrival_ucf),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "popularity",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(AppLocalizations.of(context)!
                                        .popularity_ucf),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "top_rated",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(AppLocalizations.of(context)!
                                        .top_rated_ucf),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }),
                            actions: [
                              Btn.basic(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .close_all_capital,
                                  style: TextStyle(color: MyTheme.medium_grey),
                                ),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                              ),
                            ],
                          ),
                        ))
                : ToastComponent.showDialog(
                    AppLocalizations.of(context)!
                        .you_can_use_filters_while_searching_for_products,
                    gravity: Toast.center,
                    duration: Toast.lengthLong);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: Center(
                child: Container(
              width: 50,
              child: Row(
                children: [
                  Icon(
                    Icons.swap_vert,
                    size: 13,
                  ),
                  SizedBox(width: 2),
                  Text(
                    AppLocalizations.of(context)!.sort_ucf,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )),
          ),
        )
      ],
    );
  }

  Container buildBrandList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildBrandScrollableList(),
          )
        ],
      ),
    );
  }

  buildBrandScrollableList() {
    if (_isBrandInitial && _brandList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_brandList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onBrandListRefresh,
        child: SingleChildScrollView(
          controller: _brandScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height:
                      MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _brandList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1),
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 18, right: 18),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return BrandSquareCard(
                    id: _brandList[index].id,
                    image: _brandList[index].logo,
                    name: _brandList[index].name,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalBrandData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_brand_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Future<void> _onBrandListRefresh() async {
    reset();
    resetBrandList();
    fetchBrandData();
  }

  resetBrandList() {
    _brandList.clear();
    _isBrandInitial = true;
    _totalBrandData = 0;
    _brandPage = 1;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  fetchBrandData() async {
    var brandResponse =
        await BrandRepository().getBrands(page: _brandPage, name: _searchKey);
    _brandList.addAll(brandResponse.brands!);
    _isBrandInitial = false;
    _totalBrandData = brandResponse.meta!.total;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  Container buildShopList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildShopScrollableList(),
          )
        ],
      ),
    );
  }

  Future<void> _onShopListRefresh() async {
    reset();
    resetShopList();
    fetchShopData();
  }

  resetShopList() {
    _shopList.clear();
    _isShopInitial = true;
    _totalShopData = 0;
    _shopPage = 1;
    _showShopLoadingContainer = false;
    setState(() {});
  }

  fetchShopData() async {
    var shopResponse =
        await ShopRepository().getShops(page: _shopPage, name: _searchKey);
    _shopList.addAll(shopResponse.shops);
    _isShopInitial = false;
    _totalShopData = shopResponse.meta.total;
    _showShopLoadingContainer = false;
    //print("_shopPage:" + _shopPage.toString());
    //print("_totalShopData:" + _totalShopData.toString());
    setState(() {});
  }

  _applyProductFilter() {
    reset();
    resetProductList();
    fetchProductData();
    _scaffoldKey.currentState!.closeEndDrawer();
  }

  buildShopScrollableList() {
    if (_isShopInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          controller: _scrollController,
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_shopList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onShopListRefresh,
        child: SingleChildScrollView(
          controller: _shopScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                  height:
                      MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _shopList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.7),
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 18, right: 18),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SellerDetails();
                      }));
                    },
                    child: ShopSquareCard(
                      id: _shopList[index].id,
                      image: _shopList[index].logo,
                      name: _shopList[index].name,
                      stars: double.parse(_shopList[index].rating.toString()),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalShopData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_shop_is_available));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.red,
      child: Center(
        child: Text(_totalProductData == _productList.length
            ? AppLocalizations.of(context)!.no_more_products_ucf
            : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }

  Container buildBrandLoadingContainer() {
    return Container(
      height: _showBrandLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.red,
      child: Center(
        child: Text(_totalBrandData == _brandList.length
            ? AppLocalizations.of(context)!.no_more_brands_ucf
            : AppLocalizations.of(context)!.loading_more_brands_ucf),
      ),
    );
  }

  Container buildShopLoadingContainer() {
    return Container(
      height: _showShopLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.red,
      child: Center(
        child: Text(_totalShopData == _shopList.length
            ? AppLocalizations.of(context)!.no_more_shops_ucf
            : AppLocalizations.of(context)!.loading_more_shops_ucf),
      ),
    );
  }

  ListView buildFilterBrandsList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterBrandList
            .map(
              (brand) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(brand.name),
                value: _selectedBrands.contains(brand.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedBrands.add(brand.id);
                    });
                  } else {
                    setState(() {
                      _selectedBrands.remove(brand.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterCategoryList
            .map(
              (category) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(category.name),
                value: _selectedCategories.contains(category.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedCategories.clear();
                      _selectedCategories.add(category.id);
                    });
                  } else {
                    setState(() {
                      _selectedCategories.remove(category.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterSubCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterSubCategoryList
            .map(
              (subcategory) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(subcategory.name),
                value: _selectedSubCategories.contains(subcategory.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedSubCategories.add(subcategory.id);
                    });
                  } else {
                    setState(() {
                      _selectedSubCategories.remove(subcategory.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterSoleCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterSoleCategoryList
            .map(
              (solecategory) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(solecategory.name),
                value: _selectedSoleCategories.contains(solecategory.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedSoleCategories.add(solecategory.id);
                    });
                  } else {
                    setState(() {
                      _selectedSoleCategories.remove(solecategory.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterColorCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterColorCategoryList
            .map(
              (colorcategory) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(colorcategory.name),
                value: _selectedColorCategories.contains(colorcategory.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedColorCategories.add(colorcategory.id);
                    });
                  } else {
                    setState(() {
                      _selectedColorCategories.remove(colorcategory.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterGenderCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterGenderCategoryList
            .map(
              (gendercategory) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(gendercategory.name),
                value: _selectedGenderCategories.contains(gendercategory.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedGenderCategories.add(gendercategory.id);
                    });
                  } else {
                    setState(() {
                      _selectedGenderCategories.remove(gendercategory.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterSellerCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterSellerCategoryList
            .map(
              (sellercategory) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(sellercategory.name),
                value: _selectedSellerCategories.contains(sellercategory.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedSellerCategories.add(sellercategory.id);
                    });
                  } else {
                    setState(() {
                      _selectedSellerCategories.remove(sellercategory.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterSizeCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterSizeCategoryList
            .map(
              (sizecategory) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                // title: Text(sizecategory.name),
                // value: _selectedSizeCategories.contains(sizecategory.id),
                title: Text('Size 6'),
                value: _selectedSizeCategories.contains(1),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      _selectedSizeCategories.add(sizecategory.id);
                    });
                  } else {
                    setState(() {
                      _selectedSizeCategories.remove(sizecategory.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  buildFilterDrawer() {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Container(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.price_range_ucf,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _minPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .minimum_ucf,
                                    hintStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.textfield_grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                          Text(" - "),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: 30,
                              width: 100,
                              child: TextField(
                                controller: _maxPriceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_amountValidator],
                                decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .maximum_ucf,
                                    hintStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: MyTheme.textfield_grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MyTheme.textfield_grey,
                                          width: 2.0),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(4.0),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(4.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.brands_ucf,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterBrandsList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.categories_ucf,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterCategoryList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_category_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Sub Categories',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterSubCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Sole Categories',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterSoleCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Color',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterColorCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Gender',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterGenderCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Size',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterSizeCategoryList(),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Seller List',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _filterBrandList.length == 0
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .no_brand_is_available,
                                  style: TextStyle(color: MyTheme.font_grey),
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: buildFilterSellerCategoryList(),
                            ),
                    ]),
                  )
                ]),
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Btn.basic(
                      color: Color.fromRGBO(234, 67, 53, 1),
                      shape: RoundedRectangleBorder(
                        side: new BorderSide(
                            color: MyTheme.light_grey, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.clear_all_capital,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _minPriceController.clear();
                        _maxPriceController.clear();
                        setState(() {
                          _selectedCategories.clear();
                          _selectedBrands.clear();
                          _selectedSubCategories.clear();
                          _selectedSoleCategories.clear();
                          _selectedColorCategories.clear();
                          _selectedGenderCategories.clear();
                          _selectedSizeCategories.clear();
                          _selectedSellerCategories.clear();
                          _scaffoldKey.currentState!.closeEndDrawer();
                        });
                      },
                    ),
                    Btn.basic(
                      color: Color.fromRGBO(52, 168, 83, 1),
                      child: Text(
                        "APPLY",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        var min = _minPriceController.text.toString();
                        var max = _maxPriceController.text.toString();
                        bool apply = true;
                        if (min != "" && max != "") {
                          if (max.compareTo(min) < 0) {
                            ToastComponent.showDialog(
                                AppLocalizations.of(context)!
                                    .filter_screen_min_max_warning,
                                gravity: Toast.center,
                                duration: Toast.lengthLong);
                            apply = false;
                          }
                        }

                        if (apply) {
                          _applyProductFilter();
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ScrollController _mainScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        endDrawer: buildFilterDrawer(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        // body: CustomScrollView(
        //   controller:_mainScrollController ,
        //   physics: const BouncingScrollPhysics(
        //       parent: AlwaysScrollableScrollPhysics()),
        //   slivers:[SliverList(delegate: SliverChildListDelegate([Container(
        //     // height: 500,
        //     child: Stack(
        //       fit: StackFit.loose,
        //       children: [
        //         // buildProductList(),
        //         // _selectedFilter!.option_key == 'product'
        //         //     ? buildProductList()
        //         //     : (_selectedFilter!.option_key == 'brands'
        //         //     ? buildBrandList()
        //         //     : buildShopList()),
        //         Positioned(
        //           top: 0.0,
        //           left: 0.0,
        //           right: 0.0,
        //           child: buildAppBar(context),
        //         ),
        //        // Align(
        //        //      alignment: Alignment.bottomCenter,
        //        //      child: _selectedFilter!.option_key == 'product'
        //        //          ? buildProductLoadingContainer()
        //        //          : (_selectedFilter!.option_key == 'brands'
        //        //           ? buildBrandLoadingContainer()
        //        //          : buildShopLoadingContainer()))
        //       ],
        //     ),
        //   )]))] ,
        // ),
        body: buildProductList(),
      ),
    );
    // return Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: buildAppBar(context),
    //     body: Stack(
    //       children: [
    //         // buildProductList(),
    //         Column(
    //           children: [
    //             Container(
    //               height: 45,
    //               color: Colors.yellow,
    //               width: MediaQuery.sizeOf(context).width,
    //               // color: Colors.lightGreen,
    //               child: Stack(fit: StackFit.loose, children: [
    //                 _selectedFilter!.option_key == 'product'
    //                     ? buildProductList()
    //                     : (_selectedFilter!.option_key == 'brands'
    //                     ? buildBrandList()
    //                     : buildShopList()),
    //                 // Positioned(
    //                 //   top: 0.0,
    //                 //   left: 0.0,
    //                 //   right: 0.0,
    //                 //   child: buildAppBar(context),
    //                 // ),
    //                 Text("data"),
    //                 Align(
    //                     alignment: Alignment.bottomCenter,
    //                     child: _selectedFilter!.option_key == 'product'
    //                         ? buildProductLoadingContainer()
    //                         : (_selectedFilter!.option_key == 'brands'
    //                         ? buildBrandLoadingContainer()
    //                         : buildShopLoadingContainer()))
    //               ]),
    //             ),
    //           ],
    //         ),
    //         Align(
    //             alignment: Alignment.bottomCenter,
    //             child: buildLoadingContainer())
    //       ],
    //     ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? AppLocalizations.of(context)!.no_more_products_ucf
            : AppLocalizations.of(context)!.loading_more_products_ucf),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: _subCategoryList.isEmpty
            ? DeviceInfo(context).height! / 10
            : DeviceInfo(context).height! / 6.5,
        flexibleSpace: Container(
          height: DeviceInfo(context).height! / 4,
          width: DeviceInfo(context).width,
          color: MyTheme.accent_color,
          alignment: Alignment.topRight,
          child: Image.asset(
            "assets/background_1.png",
          ),
        ),
        bottom: PreferredSize(
            child: AnimatedContainer(
              //color: MyTheme.textfield_grey,
              height: _subCategoryList.isEmpty ? 0 : 60,
              duration: Duration(milliseconds: 500),
              child: !_isInitial ? buildSubCategory() : buildSubCategory(),
            ),
            preferredSize: Size.fromHeight(0.0)),
        title: buildAppBarTitle(context),
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
        elevation: 0.0,
        titleSpacing: 0
        // centerTitle: false,
        // flexibleSpace: Padding(
        //   padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
        //   child: Column(
        //     children: [buildTopAppbar(context), buildBottomAppBar(context)],
        //   ),
        );
  }

  Row buildTopAppbar(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            icon: UsefulElements.backButton(context),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .6,
            child: Container(
              child: Padding(
                  padding: MediaQuery.of(context).viewPadding.top >
                          30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                      ? const EdgeInsets.symmetric(
                          vertical: 36.0, horizontal: 0.0)
                      : const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 0.0),
                  child: TypeAheadField(
                    suggestionsCallback: (pattern) async {
                      //return await BackendService.getSuggestions(pattern);
                      var suggestions = await SearchRepository()
                          .getSearchSuggestionListResponse(
                              query_key: pattern,
                              type: _selectedFilter!.option_key);
                      //print(suggestions.toString());
                      return suggestions;
                    },
                    loadingBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .loading_suggestions,
                                style: TextStyle(color: MyTheme.medium_grey))),
                      );
                    },
                    itemBuilder: (context, dynamic suggestion) {
                      //print(suggestion.toString());
                      var subtitle =
                          "${AppLocalizations.of(context)!.searched_for_all_lower} ${suggestion.count} ${AppLocalizations.of(context)!.times_all_lower}";
                      if (suggestion.type != "search") {
                        subtitle =
                            "${suggestion.type_string} ${AppLocalizations.of(context)!.found_all_lower}";
                      }
                      return ListTile(
                        dense: true,
                        title: Text(
                          suggestion.query,
                          style: TextStyle(
                              color: suggestion.type != "search"
                                  ? MyTheme.accent_color
                                  : MyTheme.font_grey),
                        ),
                        subtitle: Text(subtitle,
                            style: TextStyle(
                                color: suggestion.type != "search"
                                    ? MyTheme.font_grey
                                    : MyTheme.medium_grey)),
                      );
                    },
                    noItemsFoundBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .no_suggestion_available,
                                style: TextStyle(color: MyTheme.medium_grey))),
                      );
                    },
                    onSuggestionSelected: (dynamic suggestion) {
                      _searchController.text = suggestion.query;
                      _searchKey = suggestion.query;
                      setState(() {});
                      _onSearchSubmit();
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      onTap: () {},
                      //autofocus: true,
                      controller: _searchController,
                      onSubmitted: (txt) {
                        _searchKey = txt;
                        setState(() {});
                        _onSearchSubmit();
                      },
                      decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.search_here_ucf,
                          hintStyle: TextStyle(
                              fontSize: 12.0, color: MyTheme.textfield_grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: MyTheme.white, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: MyTheme.white, width: 0.0),
                          ),
                          contentPadding: EdgeInsets.all(0.0)),
                    ),
                  )),
            ),
          ),
          IconButton(
              icon: Icon(Icons.search, color: MyTheme.dark_grey),
              onPressed: () {
                _searchKey = _searchController.text.toString();
                setState(() {});
                _onSearchSubmit();
              }),
        ]);
  }

  Widget buildAppBarTitle(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: buildAppBarTitleOption(context),
        secondChild: buildAppBarSearchOption(context),
        firstCurve: Curves.fastOutSlowIn,
        secondCurve: Curves.fastOutSlowIn,
        crossFadeState: _showSearchBar
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 500));
  }

  Container buildAppBarTitleOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            width: 20,
            child: UsefulElements.backButton(context, color: "white"),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            width: DeviceInfo(context).width! / 2,
            child: Text(
              widget.category_name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.white),
            ),
          ),
          Spacer(),
          SizedBox(
            width: 20,
            child: IconButton(
                onPressed: () {
                  _showSearchBar = true;
                  setState(() {});
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.search,
                  color: MyTheme.white,
                  size: 25,
                )),
          ),
        ],
      ),
    );
  }

  Container buildAppBarSearchOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      width: DeviceInfo(context).width,
      height: 40,
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          _searchKey = txt;
          reset();
          fetchData();
        },
        onSubmitted: (txt) {
          _searchKey = txt;
          reset();
          fetchData();
        },
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              _showSearchBar = false;
              setState(() {});
            },
            icon: Icon(
              Icons.clear,
              color: MyTheme.white,
            ),
          ),
          filled: true,
          fillColor: MyTheme.white.withOpacity(0.6),
          hintText: "${AppLocalizations.of(context)!.search_products_from} : " +
              widget.category_name!,
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.font_grey),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.noColor, width: 0.0),
              borderRadius: BorderRadius.circular(6)),
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  ListView buildSubCategory() {
    return ListView.separated(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CategoryProducts(
                      category_id: _subCategoryList[index].id,
                      category_name: _subCategoryList[index].name,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: _subCategoryList.isEmpty ? 0 : 46,
              width: _subCategoryList.isEmpty ? 0 : 96,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Text(
                _subCategoryList[index].name!,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.w500,
                    color: MyTheme.font_grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: _subCategoryList.length);
  }

  ListView buildSoleCategory() {
    return ListView.separated(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CategoryProducts(
                      category_id: _soleCategoryList[index].id,
                      category_name: _soleCategoryList[index].name,
                      // logo: _soleCategoryList[index].logo,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: _subCategoryList.isEmpty ? 0 : 46,
              width: _subCategoryList.isEmpty ? 0 : 96,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Text(
                _subCategoryList[index].name!,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.w400,
                    color: MyTheme.font_grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: _subCategoryList.length);
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
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
          controller: _xcrollController,
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
}
