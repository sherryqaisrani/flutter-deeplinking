import 'package:deeplinking/constant/constant.dart';
import 'package:deeplinking/firebase_options.dart';
import 'package:deeplinking/pages/product/product_cubit.dart';
import 'package:deeplinking/pages/product/product_state.dart';
import 'package:deeplinking/pages/product/widget/product_item_design.dart';
import 'package:deeplinking/routes/routes_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await init();
  runApp(const MyApp());
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteServices.generateRoute,
      home: _MainScreen(),
    );
  }
}

class _MainScreen extends StatefulWidget {
  const _MainScreen({super.key});

  @override
  State<_MainScreen> createState() => __MainScreenState();
}

class __MainScreenState extends State<_MainScreen> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  // Future<void> initDynamicLinks() async {
  //   try {
  //     FirebaseDynamicLinks.instance.onLink.listen((event) {
  //       print(event.link.path);
  //       print('****');
  //       final Uri? uri = event?.link;
  //        if (uri != null) {
  //     final queryParams = uri.path;
  //     print(queryParams);
  //     print("111***");
  //     if (queryParams.isNotEmpty) {
  //       String? productId = queryParams;
  //       Navigator.pushNamed(context, uri.path,
  //           arguments: {"productId": int.parse(productId!)});
  //     } else {
  //       Navigator.pushNamed(context, uri.path);
  //     }
  //   }
  //  //     Navigator.pushNamed(context, event.link.path);

  //     });
  //   } catch (e) {}
  // }

  Future<void> initDynamicLinks() async {
    try {
      FirebaseDynamicLinks.instance.onLink.listen((event) {
        final Uri? uri = event.link;
        if (uri != null) {
          final queryParams = uri.queryParameters;
          if (queryParams.containsKey('id')) {
            String? productId = queryParams['id'];
            Navigator.pushNamed(
              context,
              '/productpage',
              arguments: {'productId': int.parse(productId!)},
            );
          } else {
            Navigator.pushNamed(context, uri.path);
          }
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Lists'),
          centerTitle: true,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return BlocBuilder<ProductCubit, ProductStates>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                switch (state.status) {
                  case ProductStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (state.productList.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(1.0),
                      childAspectRatio: 8.0 / 14.0,
                      children: List<Widget>.generate(
                          state.productList.length - 1, (index) {
                        var item = state.productList[index];
                        return GridTile(
                            child: GridTilesProducts(
                          name: item.name.toString(),
                          imageUrl: item.url.toString(),
                          onShare: () {
                            context.read<ProductCubit>().createDynamicLink(
                                kProductpageLink + item.id.toString());
                          },
                          voidCallback: () {
                            Navigator.pushNamed(
                              context,
                              '/productpage',
                              arguments: {
                                'productId': int.parse(item.id.toString())
                              },
                            );
                          },
                          price: item.price.toString(),
                        ));
                      }),
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
