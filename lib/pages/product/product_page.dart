import 'package:deeplinking/model/json_model.dart';
import 'package:deeplinking/pages/product/product_cubit.dart';
import 'package:deeplinking/pages/product/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatelessWidget {
  final int? productId;
  const ProductPage({Key? key, this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFfafafa),
        // appBar: appBarWidget(context),
        body: BlocBuilder<ProductCubit, ProductStates>(
          builder: (context, state) {
            return FutureBuilder(
              future: getDetailData(productId!, context),
              builder: (context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return createDetailView(context, snapshot);
                    }
                }
              },
            );
          },
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.favorite_border,
            color: Color(0xFF5e5e5e),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: Container(
            
              child: Text("Add to cart".toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFff665e))),
            ),
          ),
          SizedBox(width: 4,),
          ElevatedButton(
            onPressed: () {},
            child: Container(
              
              child: Text("available at shops".toUpperCase(),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFFFF))),
            ),
          ),
        ],
      ),
    );
  }
}

Widget createDetailView(BuildContext context, AsyncSnapshot snapshot) {
  ModelClass values = snapshot.data;
  return DetailScreen(
    productDetails: values,
  );
}

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  ModelClass productDetails;

  DetailScreen({Key? key, required this.productDetails}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /*Image.network(
              widget.productDetails.data.productVariants[0].productImages[0]),*/
          Image.network(
            widget.productDetails.url.toString(),
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("SKU".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text(widget.productDetails.id.toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFfd0100))),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF999999),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Price".toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text(
                    "৳ ${(widget.productDetails.price.toString())}"
                        .toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFFf67426),
                        fontFamily: 'Roboto-Light.ttf',
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
                // Text(
                //     "${widget.productDetails.data.productVariants[0].productDescription}",
                //     textAlign: TextAlign.justify,
                //     style: const TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w400,
                //         color: Color(0xFF4c4c4c))),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: const Color(0xFFFFFFFF),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Specification",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future<ModelClass> getDetailData(int id, BuildContext context) async {
  final ModelClass product =
      await context.read<ProductCubit>().getDetailData(id);
  return product;
}
