import 'package:baideshikrojgar/utlis/global/Helper.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:baideshikrojgar/views/fragements/jobTile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BaideshikRojgarReviews extends StatefulWidget {
  BaideshikRojgarReviews({
    this.reviews,
    this.id,
    this.type,
    @required this.fetchFunction,
  });
  final String id;
  final String type;
  final ValueSetter<bool> fetchFunction;
  final dynamic reviews;
  @override
  _BaideshikRojgarReviewsState createState() => _BaideshikRojgarReviewsState();
}

class _BaideshikRojgarReviewsState extends State<BaideshikRojgarReviews> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.reviews.length == 0
        ? Center(
            child: TextFormatted(text: "Sorry no reviews yet."),
          )
        : Column(
            children: this.widget.reviews.map<Widget>((element) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              element['user']['main_image'],
                            ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SimplePrimaryTitle(
                                  title: element['user']['name'],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.timer,
                                  color: Colors.grey,
                                  size: 11,
                                ),
                                TextFormatted(
                                  text: getTimeFormatted(element['updated_at']),
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IgnorePointer(
                                  child: RatingBar.builder(
                                    initialRating: double.parse(
                                        element['rating'].toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    itemSize: 16,
                                    glowRadius: 1,
                                    onRatingUpdate: (double rating) {},
                                  ),
                                ),
                                TextNormal(
                                  text: " (" +
                                      element['rating'].toString() +
                                      "/5)",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60),
                    child: TextFormatted(
                      text: element['review'],
                      maxline: 5000,
                    ),
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          );
  }
}
