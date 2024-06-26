import 'dart:async';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/pricecategory_response.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/flash_deal_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/sliders_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../repositories/pricecategory_repository.dart';
import '../repositories/sandlescollection_repository.dart';
import '../repositories/sellermarket_repository.dart';
import '../repositories/shoescollection_repository.dart';
import '../repositories/slipercollection_repository.dart';

class HomePresenter extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int current_slider = 0;
  ScrollController? allProductScrollController;
  ScrollController? featuredCategoryScrollController;
  ScrollController? sellerMarketCategoryScrollController;
  ScrollController? priceCategoryScrollController;
  ScrollController? sandlesCollectionScrollController;
  ScrollController? shoesCollectionScrollController;
  ScrollController? sliperCategoryScrollController;
  ScrollController mainScrollController = ScrollController();

  late AnimationController pirated_logo_controller;
  late Animation pirated_logo_animation;

  var carouselImageList = [];
  var bannerOneImageList = [];
  var bannerTwoImageList = [];
  var featuredCategoryList = [];
  var soleCategoryList = [];
  var sellerMarketCategoryList = [];
  var priceCategoryList = [];
  var sandlesCollectionCategoryList = [];
  var shoesCollectionCategoryList = [];
  var sliperCollectionCategoryList = [];

  bool isCategoryInitial = true;
  bool isSoleCategoryInitial = true;
  bool isPriceCategoryInitial = true;
  bool isShoesCategoryInitial = true;
  bool isSliperCategoryInitial = true;

  bool isCarouselInitial = true;
  bool isBannerOneInitial = true;
  bool isBannerTwoInitial = true;
  bool issellerMarketCategoryInitial = true;
  bool issandlesCollectionCategoryInitial = true;

  var featuredProductList = [];
  bool isFeaturedProductInitial = true;
  int? totalFeaturedProductData = 0;
  int featuredProductPage = 1;
  bool showFeaturedLoadingContainer = false;

  bool isTodayDeal = false;
  bool isFlashDeal = false;

  var allProductList = [];
  bool isAllProductInitial = true;
  int? totalAllProductData = 0;
  int allProductPage = 1;
  bool showAllLoadingContainer = false;
  int cartCount = 0;

  fetchAll() {
    fetchCarouselImages();
    fetchBannerOneImages();
    fetchBannerTwoImages();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchAllProducts();
    fetchTodayDealData();
    fetchFlashDealData();
    fetchSoleCategories();
    fetchSellerMarketCategories();
    fetchPriceCategories();
    fetchSandlesCollectionCategories();
    fetchShoesCollectionCategories();
    fetchSliperCollectionCategories();
  }

  fetchTodayDealData() async {
    var deal = await ProductRepository().getTodaysDealProducts();
    // print(deal.products!.length);
    if (deal.success! && deal.products!.isNotEmpty) {
      isTodayDeal = true;
      notifyListeners();
    }
  }

  fetchFlashDealData() async {
    var deal = await FlashDealRepository().getFlashDeals();

    if (deal.success! && deal.flashDeals!.isNotEmpty) {
      isFlashDeal = true;
      notifyListeners();
    }
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders!.forEach((slider) {
      carouselImageList.add(slider.photo);
    });
    isCarouselInitial = false;
    notifyListeners();
  }

  fetchBannerOneImages() async {
    var bannerOneResponse = await SlidersRepository().getBannerOneImages();
    bannerOneResponse.sliders!.forEach((slider) {
      bannerOneImageList.add(slider.photo);
    });
    isBannerOneInitial = false;
    notifyListeners();
  }

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SlidersRepository().getBannerTwoImages();
    bannerTwoResponse.sliders!.forEach((slider) {
      bannerTwoImageList.add(slider.photo);
    });
    isBannerTwoInitial = false;
    notifyListeners();
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    featuredCategoryList.addAll(categoryResponse.categories!);
    isCategoryInitial = false;
    notifyListeners();
  }

  fetchSellerMarketCategories() async {
    var sellerMarketResponse =
        await SellerMarketRepository().getSellerMarketCategories();
    sellerMarketCategoryList.addAll(sellerMarketResponse.market_name!);
    issellerMarketCategoryInitial = false;
    notifyListeners();
  }

  fetchPriceCategories() async {
    var priceCategoryResponse =
        await PriceCategoryRepository().getPriceCategories();
    priceCategoryList.addAll(priceCategoryResponse.price_category!);
    isPriceCategoryInitial = false;
    notifyListeners();
  }

  fetchSandlesCollectionCategories() async {
    var sandlesCollectionCategoryResponse =
        await SandlesCollectionRepository().getSandlesCollectionCategories();
    sandlesCollectionCategoryList
        .addAll(sandlesCollectionCategoryResponse.name!);
    issandlesCollectionCategoryInitial = false;
    notifyListeners();
  }

  fetchShoesCollectionCategories() async {
    var shoesCollectionCategoryResponse =
        await ShoesCollectionRepository().getShoesCollectionCategories();
    shoesCollectionCategoryList.addAll(shoesCollectionCategoryResponse.name!);
    print("shoesCollectionCategoryList ${shoesCollectionCategoryList}");
    isShoesCategoryInitial = false;
    notifyListeners();
  }

  fetchSliperCollectionCategories() async {
    var shoesCollectionCategoryResponse =
        await SliperCollectionRepository().getSliperCollectionCategories();
    sliperCollectionCategoryList.addAll(shoesCollectionCategoryResponse.name!);
    print("sliperCollectionCategoryList ${sliperCollectionCategoryList}");
    isSliperCategoryInitial = false;
    notifyListeners();
  }

  fetchSoleCategories() async {
    var soleResponse = await CategoryRepository().getSoleCategories();
    soleCategoryList.addAll(soleResponse.categories!);
    isSoleCategoryInitial = false;
    notifyListeners();
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: featuredProductPage,
    );
    featuredProductPage++;
    featuredProductList.addAll(productResponse.products!);
    isFeaturedProductInitial = false;
    totalFeaturedProductData = productResponse.meta!.total;
    showFeaturedLoadingContainer = false;
    notifyListeners();
  }

  fetchAllProducts() async {
    var productResponse = await ProductRepository().getAllProducts();
    if (productResponse.products!.isEmpty) {
      ToastComponent.showDialog("No more products!", gravity: Toast.center);
      return;
    }

    allProductList.addAll(productResponse.products!);
    isAllProductInitial = false;
    // totalAllProductData = productResponse.meta!.total;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  reset() {
    carouselImageList.clear();
    bannerOneImageList.clear();
    bannerTwoImageList.clear();
    featuredCategoryList.clear();
    soleCategoryList.clear();
    sellerMarketCategoryList.clear();
    priceCategoryList.clear();
    sandlesCollectionCategoryList.clear();
    shoesCollectionCategoryList.clear();
    sliperCollectionCategoryList.clear();

    isCarouselInitial = true;
    isBannerOneInitial = true;
    isBannerTwoInitial = true;
    isCategoryInitial = true;
    isSoleCategoryInitial = true;
    isPriceCategoryInitial = true;
    isShoesCategoryInitial = true;
    issellerMarketCategoryInitial = true;
    issandlesCollectionCategoryInitial = true;
    cartCount = 0;

    resetFeaturedProductList();
    resetAllProductList();
  }

  Future<void> onRefresh() async {
    reset();
    fetchAll();
  }

  resetFeaturedProductList() {
    featuredProductList.clear();
    isFeaturedProductInitial = true;
    totalFeaturedProductData = 0;
    featuredProductPage = 1;
    showFeaturedLoadingContainer = false;
    notifyListeners();
  }

  resetAllProductList() {
    allProductList.clear();
    isAllProductInitial = true;
    totalAllProductData = 0;
    allProductPage = 1;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  mainScrollListener() {
    mainScrollController.addListener(() {
      //print("position: " + xcrollController.position.pixels.toString());
      //print("max: " + xcrollController.position.maxScrollExtent.toString());

      if (mainScrollController.position.pixels ==
          mainScrollController.position.maxScrollExtent) {
        allProductPage++;
        ToastComponent.showDialog("More Products Loading...",
            gravity: Toast.center);
        showAllLoadingContainer = true;
        // fetchAllProducts();
      }
    });
  }

  initPiratedAnimation(vnc) {
    pirated_logo_controller =
        AnimationController(vsync: vnc, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
        CurvedAnimation(
            curve: Curves.bounceOut, parent: pirated_logo_controller));

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  // incrementFeaturedProductPage(){
  //   featuredProductPage++;
  //   notifyListeners();
  //
  // }

  incrementCurrentSlider(index) {
    current_slider = index;
    notifyListeners();
  }

  // void dispose() {
  //   pirated_logo_controller.dispose();
  //   notifyListeners();
  // }
  //

  @override
  void dispose() {
    // TODO: implement dispose
    pirated_logo_controller.dispose();
    notifyListeners();
    super.dispose();
  }
}
