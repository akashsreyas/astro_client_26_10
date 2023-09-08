import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hallo_doctor_client/app/utils/constants/style_constants.dart';

class DoctorCard extends StatelessWidget {
  final String? doctorName;
  final String? doctorSpecialty;
  final String? imageUrl;
  final double? rating;
  final VoidCallback onTap;
  const DoctorCard(
      {Key? key,
      this.doctorName,
      this.doctorSpecialty,
      this.imageUrl,
      this.rating,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.maxFinite,
            padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network(
                      imageUrl!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          doctorName!,
                          style: doctorNameTextStyle,
                        ),
                      ),

          Text(
            doctorSpecialty!.split("-").join("\n"),
            style: specialistTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,

          ),
                      RatingBarIndicator(
                          rating: rating!.toDouble(),
                          itemCount: 5,
                          itemSize: 20.0,
                          itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ))
                    ],
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: onTap,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Book Appointment".tr,
                            style: TextStyle(color: Colors.white,fontSize: 12),
                            textAlign: TextAlign.center,

                          ),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
