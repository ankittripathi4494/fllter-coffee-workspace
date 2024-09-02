import 'package:filtercoffee/global/utils/shared_preferences_helper.dart';
import 'package:filtercoffee/img_list.dart';
import 'package:filtercoffee/modules/dashboard/widgets/pdf_view_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer {
  static getDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.deepPurple],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: ListView(
          children: [
            DrawerHeader(child: Image.asset(ImageList.appLogo)),
            ListTile(
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.pushReplacementNamed(context, '/dashboard-screen');
              },
              leading: const Icon(
                Icons.home,
                size: 35,
                color: Colors.white,
              ),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 35,
                color: Colors.white,
              ),
            ),
            ExpansionTile(
              shape: Border.all(color: Colors.transparent),
              collapsedShape: null,
              leading: const Icon(
                CupertinoIcons.person_3_fill,
                size: 35,
                color: Colors.white,
              ),
              title: const Text(
                "Customers",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context); // close the drawer
                    Navigator.pushNamed(context, '/add-customer',
                        arguments: {'title': "Add Customer"});
                  },
                  leading: const Icon(
                    Icons.person_add,
                    size: 35,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Add Customer",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context); // close the drawer
                    Navigator.pushNamed(context, '/customer-list',
                        arguments: {'title': "Customers List"});
                  },
                  leading: const Icon(
                    Icons.list,
                    size: 35,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Customers List",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.pushNamed(
                  context,
                  '/webview_screen',
                );
              },
              leading: const Icon(
                Icons.web,
                size: 35,
                color: Colors.white,
              ),
              title: const Text(
                "WebViewPage",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 35,
                color: Colors.white,
              ),
            ),
             ListTile(
              onTap: () {
                Navigator.pop(context); // close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) {
                    return PdfViewScreenPage(arguments: const {});
                  },)
                );
              },
              leading: const Icon(
                Icons.web,
                size: 35,
                color: Colors.white,
              ),
              title: const Text(
                "Pdf View Screen",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 35,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                SessionHelper().remove("isLoggedIn");
                Navigator.pop(context); // close the drawer
                Navigator.pushReplacementNamed(context, '/login-screen',
                    arguments: {'title': "Login Screen"});
              },
              leading: const Icon(
                Icons.logout,
                size: 35,
                color: Colors.white,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 35,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
