import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/styles/styles.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile(
      {Key? key,
      required this.imgUrl,
      required this.name,
      required this.rating,
      required this.review})
      : super(key: key);
  final String imgUrl;
  final String name;
  final double rating;
  final String review;

  @override
  Widget build(BuildContext context) {
    var imagePath = imgUrl.isNotEmpty
        ? NetworkImage(imgUrl)
        : AssetImage('assets/images/default-profile.png');
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: 68,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Color(0x04000000),
                blurRadius: 10,
                spreadRadius: 10,
                offset: Offset(0.0, 8.0))
          ],
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Styles.whiteGreyColor,
                  image: DecorationImage(
                    image: imagePath as ImageProvider,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name,
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    Container(
                      width: 250,
                      child: Flexible(
                        child: Text(
                          review,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, color: Colors.black),
                          maxLines: 2,
                          softWrap: false,
                        ),
                      ),
                    ),
                    RatingBarIndicator(
                      rating: rating.toDouble(),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 22.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
