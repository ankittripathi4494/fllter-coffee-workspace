// ignore_for_file: must_be_immutable

import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_bloc.dart';
import 'package:filtercoffee/global/blocs/theme_switcher/theme_switcher_event.dart';
import 'package:filtercoffee/global/utils/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../global/utils/shared_preferences_helper.dart';

class WebViewScreenPage extends StatefulWidget {
  late Map<String, dynamic> arguments;
  WebViewScreenPage({
    super.key,
    required this.arguments,
  });

  @override
  State<WebViewScreenPage> createState() => _WebViewScreenPageState();
}

class _WebViewScreenPageState extends State<WebViewScreenPage> {
  bool? darkTheme;
  late WebViewController _webViewController;
  String webUrl = 'http://vardanindia.in';
  Map<String, dynamic> contactData = {
    "mailId": "support@financepe.in",
    "contacts": [
      "+917054344815",
      "+918433643190",
    ]
  };
  @override
  void initState() {
    getCurrentTheme();
    fetchWebPage();
    super.initState();
  }

  fetchWebPage() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            LoggerUtil()
                .debugData('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            LoggerUtil().debugData('Page started loading: $url');
          },
          onPageFinished: (String url) {
            LoggerUtil().debugData('Page finished loading: $url');
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {
            LoggerUtil().debugData('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.redAccent,
                shape: const StadiumBorder(),
                behavior: SnackBarBehavior.floating,
                elevation: 30,
                content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(webUrl));
  }

  getCurrentTheme() async {
    SessionHelper sph = SessionHelper();

    if (sph.getBool('darkTheme') == true) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<ThemeSwitcherBloc>(context)
          .add(ThemeChanged(themeType: true));
      setState(() {
        darkTheme = true;
      });
    } else {
      // ignore: use_build_context_synchronously
      BlocProvider.of<ThemeSwitcherBloc>(context)
          .add(ThemeChanged(themeType: false));
      setState(() {
        darkTheme = false;
      });
    }

    return darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    enableDrag: false,
                    isDismissible: true,
                    isScrollControlled: false,
                    backgroundColor: Colors.transparent,
                    builder: ((context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: MediaQuery.of(context).viewInsets,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: (darkTheme == true)
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(45),
                                  topRight: Radius.circular(45)),
                              gradient: (darkTheme == true)
                                  ? const LinearGradient(
                                      colors: <Color>[
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                    )
                                  : const LinearGradient(
                                      colors: <Color>[
                                        Colors.white,
                                        Colors.grey,
                                      ],
                                    ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Customer Support",
                                    style: TextStyle(
                                        color: (darkTheme == true)
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 4),
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.deepOrange),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    showModalBottomSheet(
                                                        context: context,
                                                        enableDrag: false,
                                                        isDismissible: true,
                                                        isScrollControlled:
                                                            false,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder: ((context) {
                                                          return Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            padding:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: (darkTheme ==
                                                                          true)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .transparent,
                                                                  width: 2),
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          45),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          45)),
                                                              gradient: (darkTheme ==
                                                                      true)
                                                                  ? const LinearGradient(
                                                                      colors: <Color>[
                                                                        Colors
                                                                            .transparent,
                                                                        Colors
                                                                            .transparent,
                                                                      ],
                                                                    )
                                                                  : const LinearGradient(
                                                                      colors: <Color>[
                                                                        Colors
                                                                            .white,
                                                                        Colors
                                                                            .grey,
                                                                      ],
                                                                    ),
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      "On Call Support",
                                                                      style: TextStyle(
                                                                          color: (darkTheme == true)
                                                                              ? Colors
                                                                                  .white
                                                                              : Colors
                                                                                  .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: List.from(contactData['contacts']).length,
                                                                        itemBuilder: ((context, index) {
                                                                          return ListTile(
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              var telUrl = "tel://${List.from(contactData['contacts'])[index]}";

                                                                              var url = Uri.parse(telUrl);
                                                                              if (await canLaunchUrl(url)) {
                                                                                await launchUrl(url);
                                                                              } else {
                                                                                throw 'Could not launch $url';
                                                                              }
                                                                            },
                                                                            leading:
                                                                                Container(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              decoration: BoxDecoration(
                                                                                color: (darkTheme == true) ? Colors.white : Colors.black,
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: const Icon(
                                                                                Icons.phone,
                                                                                color: Colors.deepOrange,
                                                                              ),
                                                                            ),
                                                                            title:
                                                                                Text(
                                                                              List.from(contactData['contacts'])[index],
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(color: (darkTheme == true) ? Colors.white : Colors.black, fontSize: 20),
                                                                            ),
                                                                          );
                                                                        })),
                                                                  ],
                                                                )),
                                                          );
                                                        }));
                                                  },
                                                  icon: const Icon(
                                                    Icons.phone,
                                                    size: 50,
                                                  )),
                                            ),
                                            Text(
                                              "Phone",
                                              style: TextStyle(
                                                  color: (darkTheme == true)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 4),
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.green),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    showModalBottomSheet(
                                                        context: context,
                                                        enableDrag: false,
                                                        isDismissible: true,
                                                        isScrollControlled:
                                                            false,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        builder: ((context) {
                                                          return Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            padding:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: (darkTheme ==
                                                                          true)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .transparent,
                                                                  width: 2),
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          45),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          45)),
                                                              gradient: (darkTheme ==
                                                                      true)
                                                                  ? const LinearGradient(
                                                                      colors: <Color>[
                                                                        Colors
                                                                            .transparent,
                                                                        Colors
                                                                            .transparent,
                                                                      ],
                                                                    )
                                                                  : const LinearGradient(
                                                                      colors: <Color>[
                                                                        Colors
                                                                            .white,
                                                                        Colors
                                                                            .grey,
                                                                      ],
                                                                    ),
                                                            ),
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      "Whatsapp Support",
                                                                      style: TextStyle(
                                                                          color: (darkTheme == true)
                                                                              ? Colors
                                                                                  .white
                                                                              : Colors
                                                                                  .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: List.from(contactData['contacts']).length,
                                                                        itemBuilder: ((context, index) {
                                                                          return ListTile(
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              var whatsappUrl = "whatsapp://send?phone=${List.from(contactData['contacts'])[index]}&text=${Uri.encodeComponent("Hi, Welcome to FinancePe! How may we help you?")}";

                                                                              var url = Uri.parse(whatsappUrl);
                                                                              if (await canLaunchUrl(url)) {
                                                                                await launchUrl(url);
                                                                              } else {
                                                                                throw 'Could not launch $url';
                                                                              }
                                                                            },
                                                                            leading:
                                                                                Container(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              decoration: BoxDecoration(
                                                                                color: (darkTheme == true) ? Colors.white : Colors.black,
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: const Icon(
                                                                                FontAwesomeIcons.whatsapp,
                                                                                color: Colors.green,
                                                                              ),
                                                                            ),
                                                                            title:
                                                                                Text(
                                                                              List.from(contactData['contacts'])[index],
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(color: (darkTheme == true) ? Colors.white : Colors.black, fontSize: 20),
                                                                            ),
                                                                          );
                                                                        })),
                                                                  ],
                                                                )),
                                                          );
                                                        }));
                                                  },
                                                  icon: const Icon(
                                                    FontAwesomeIcons.whatsapp,
                                                    size: 50,
                                                  )),
                                            ),
                                            Text(
                                              "Whatsapp",
                                              style: TextStyle(
                                                  color: (darkTheme == true)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 4),
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.amber),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    final Uri params = Uri(
                                                      scheme: 'mailto',
                                                      path:
                                                          contactData['mailId']
                                                              .toString()
                                                              .trim(),
                                                      query:
                                                          'subject=&body=', //add subject and body here
                                                    );

                                                    var url = params;
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url);
                                                    } else {
                                                      throw 'Could not launch $url';
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.mail,
                                                    size: 50,
                                                  )),
                                            ),
                                            Text(
                                              "E-Mail",
                                              style: TextStyle(
                                                  color: (darkTheme == true)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }));
              },
              icon: Icon(Icons.local_activity))
        
        ],
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
