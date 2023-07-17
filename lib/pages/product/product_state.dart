// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:deeplinking/model/json_model.dart';

enum ProductStatus { loading, loaded }

class ProductStates extends Equatable {
  final ProductStatus status;
  final List<ModelClass> productList;
  const ProductStates({
    this.status = ProductStatus.loading,
    this.productList = const [],
  });



  @override
  // TODO: implement props
  List<Object?> get props => [status, productList];

  ProductStates copyWith({
    ProductStatus? status,
    List<ModelClass>? productList,
  }) {
    return ProductStates(
      status: status ?? this.status,
      productList: productList ?? this.productList,
    );
  }
}
