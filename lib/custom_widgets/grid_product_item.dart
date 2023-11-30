import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user/models/product_model.dart';
import 'package:ecom_user/pages/product_details_page.dart';
import 'package:ecom_user/providers/product_provider.dart';
import 'package:ecom_user/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class GridProductItem extends StatelessWidget {
  const GridProductItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return InkWell(
      onTap: ()=> Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: product.id),
      child: Card(
        clipBehavior:Clip.antiAlias,
        color: Colors.grey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    fadeInDuration: const Duration(seconds: 2),
                    fadeInCurve: Curves.bounceInOut,
                      imageUrl: product.imageUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: const Icon(Icons.error),
                    ),
                    width: double.infinity,
                  ),
                  if(product.discount > 0)Container(
                    color: Colors.black45,
                    alignment: Alignment.center,
                    height: 50,
                    child: Text("${product.discount}% OFF",
                      style: TextStyle(fontSize: 25,color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(2.0),
                    child: Text(product.name, overflow: TextOverflow.ellipsis,style:const TextStyle(fontSize: 16)),
            ),
            if(product.discount > 0)RichText(
                text: TextSpan(
                  text: "$currencySymbol${product.price}",
                  style: TextStyle(color: Colors.black, fontSize: 16,decoration: TextDecoration.lineThrough),
                  children: [
                    TextSpan(
                      text: "$currencySymbol${provider.priceAfterDiscount(product.price, product.discount)}",
                      style: TextStyle(color: Colors.black, fontSize: 20,decoration: TextDecoration.none),

                    )
                  ]
                ),
            ),
            if(product.discount == 0)Text(
              "$currencySymbol${product.price}",
                style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${product.avgRating}"),

                RatingBar.builder(
                    onRatingUpdate: (value){

                    },
                ignoreGestures: true,
                  itemBuilder: (context, index) => const Icon(Icons.star,color: Colors.amber,),
                  itemCount: 5,
                  allowHalfRating: true,
                  initialRating: product.avgRating,
                  itemSize: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
