import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_shop/models/appReview_model.dart';
import 'package:flutter_online_shop/services/auth/auth_services.dart';
import 'package:flutter_online_shop/services/db/app_review_db_helper.dart';
import 'package:flutter_online_shop/services/file_access/fs_files_access.dart';
import 'package:flutter_online_shop/utils/constant.dart';
import 'package:flutter_online_shop/utils/size_config.dart';
import 'package:flutter_online_shop/widget/default_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(50)),
                Container(
                  width: SizeConfig.screenWidth * .8,
                  height: SizeConfig.screenHeight * .15,
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(.3),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(
                            30,
                          ))),
                  child: Center(
                    child: Text(
                      'Vo Hong Quan',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * .8,
                      height: SizeConfig.screenHeight * .6,
                      decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(.3),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(
                                30,
                              ))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                getProportionateScreenWidth(screenPadding),
                            vertical:
                                getProportionateScreenHeight(screenPadding)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Email:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  kEmail,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            Row(
                              children: [
                                Spacer(),
                                IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/github_icon.svg",
                                    color: kTextColor.withOpacity(0.75),
                                  ),
                                  color: kTextColor.withOpacity(0.75),
                                  iconSize: 40,
                                  padding: EdgeInsets.all(16),
                                  onPressed: () async {
                                    String githubUrl = kGithubLink;
                                    await launchUrl(githubUrl);
                                  },
                                ),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeveloperAvatar() {
    return FutureBuilder<String>(
        future: FirestoreFilesAccess().getDeveloperImage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final url = snapshot.data;
            return CircleAvatar(
              radius: SizeConfig.screenWidth * 0.3,
              backgroundColor: kTextColor.withOpacity(0.75),
              backgroundImage: NetworkImage(url),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
          }
          return CircleAvatar(
            radius: SizeConfig.screenWidth * 0.3,
            backgroundColor: kTextColor.withOpacity(0.75),
          );
        });
  }

  Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Logger().i("LinkedIn URL was unable to launch");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }

  Future<void> submitAppReview(BuildContext context,
      {bool liked = true}) async {
    AppReview prevReview;
    try {
      prevReview = await AppReviewDatabaseHelper().getAppReviewOfCurrentUser();
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
    } catch (e) {
      Logger().w("Unknown Exception: $e");
    } finally {
      if (prevReview == null) {
        prevReview = AppReview(
          AuthentificationService().currentUser.uid,
          liked: liked,
          feedback: "",
        );
      }
    }
    final AppReview result = await showDialog(
      context: context,
      builder: (context) {
        return AppReviewDialog(
          appReview: prevReview,
        );
      },
    );
    if (result != null) {
      result.liked = liked;
      bool reviewAdded = false;
      String snackbarMessage;
      try {
        reviewAdded = await AppReviewDatabaseHelper().editAppReview(result);
        if (reviewAdded == true) {
          snackbarMessage = "Feedback submitted successfully";
        } else {
          throw "Coulnd't add feeback due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = e.toString();
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }
}

class AppReviewDialog extends StatelessWidget {
  final AppReview appReview;
  AppReviewDialog({
    Key key,
    @required this.appReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "Feedback",
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Center(
          child: TextFormField(
            initialValue: appReview.feedback,
            decoration: InputDecoration(
              hintText: "Feedback for App",
              labelText: "Feedback (optional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (value) {
              appReview.feedback = value;
            },
            maxLines: null,
            maxLength: 150,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Center(
          child: DefaultButton(
            text: "Submit",
            press: () {
              Navigator.pop(context, appReview);
            },
          ),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
    );
  }
}
