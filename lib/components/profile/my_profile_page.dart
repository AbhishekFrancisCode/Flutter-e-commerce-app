import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vismaya/components/login/my_login.dart';
import 'package:vismaya/components/my_account/my_account.dart';
import 'package:vismaya/components/my_orders/my_orders.dart';
import 'package:vismaya/components/signup/my_signup.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/utils/utils.dart';
import 'cms_page.dart';

const kAboutUsUrl = 'cmsPage/5';
const kContactUsUrl = 'cmsBlock/2';
const kFaqUrl = 'cmsPage/6';
const kPrivacyPolicyUrl = 'cmsPage/4';

class MyProfilePage extends StatelessWidget {
  final _cmsPages = [
    {"icon": Icons.info_outline, "title": "About Us", "url": kAboutUsUrl},
    {
      "icon": Icons.question_answer,
      "title": "Contact us",
      "url": kContactUsUrl
    },
    {"icon": Icons.live_help, "title": "FAQ", "url": kFaqUrl},
    {
      "icon": Icons.lock_outline,
      "title": "Privacy & Cookie Policy",
      "url": kPrivacyPolicyUrl
    }
  ];

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = config.customerToken.isNotEmpty;
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: config.brandColor,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(32),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: isLoggedIn
                        ? Card(
                            child: FlatButton(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                children: [
                                  Icon(Icons.library_books),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("My Orders",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                ],
                              ),
                              onPressed: () =>
                                  Utils.navigateToPage(context, MyOrdersPage()),
                            ),
                          )
                        : RaisedButton(
                            onPressed: () =>
                                Utils.navigateToPage(context, MySignUpPage()),
                            child: Text("Sign Up"),
                            textColor: Colors.white,
                            color: config.brandColor,
                          ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: isLoggedIn
                        ? Card(
                            child: FlatButton(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                children: [
                                  Icon(Icons.person_outline),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("My Account",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                ],
                              ),
                              onPressed: () => Utils.navigateToPage(
                                  context, MyAccountPage()),
                            ),
                          )
                        : OutlineButton(
                            borderSide: BorderSide(color: config.brandColor),
                            onPressed: () =>
                                Utils.navigateToPage(context, MyLogInPage()),
                            child: Text("Log in"),
                          ),
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: _cmsPages.length,
              itemBuilder: (context, index) {
                final _page = _cmsPages[index];
                final _icon = _page["icon"];
                final title = _page["title"];
                final url = _page["url"];
                return ListTile(
                  title: Text(title),
                  leading: Icon(_icon),
                  onTap: () =>
                      Utils.navigateToPage(context, MyCMSPage(title, url)),
                );
              },
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              dense: true,
              onTap: () async {
                // final url = Platform.isIOS ? kAppstoreUrl : kPlayUrl;
                // await Utils.launchURL(url);
              },
              title: Text(
                config.brandName,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              subtitle: Text("v${config.appVersion}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600])),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Powered by Vismaya", textAlign: TextAlign.center)
          ],
        ));
  }
}
