import 'package:deeplinking/constant/constant.dart';
import 'package:deeplinking/model/json_model.dart';
import 'package:deeplinking/pages/product/product_state.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class ProductCubit extends Cubit<ProductStates> {
  final BuildContext context;
  ProductCubit(this.context) : super(const ProductStates()) {
    _onInit();
  }

  Future<void> _onInit() async {
    await _getProductList();
  }

  Future<void> _getProductList() async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      List<ModelClass> jsonList =
          (productJson).map((e) => ModelClass.fromJson(e)).toList();

      emit(state.copyWith(productList: jsonList));
      emit(state.copyWith(status: ProductStatus.loaded));
    } catch (e) {
      print('Any thing wrong here');
    }
  }

  ModelClass getDetailData(int id) {
    final ModelClass product = state.productList[id];
    return product;
  }

  Future<void> createDynamicLink(String link) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + link),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.deeplinking',
        minimumVersion: 0,
      ),
    );
    Uri url;
    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    Share.share(url.toString());

    // if (short) {

    // } else {
    //   url = await dynamicLinks.buildLink(parameters);
    // }
  }
}
