import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lenguas/screens/language_select.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lenguas/models/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AppState>(
        builder: (context, state, child) {
          analytics.logEvent(name: 'open-drawer');
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Consumer<UserAccount>(
                builder: (context, account, child) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(
                      '${account.displayName ?? ''}',
                      style: GoogleFonts.fredokaOne(),
                    ),
                    accountEmail: Text('${account.email ?? ''}'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: account.profilePic,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.language),
                title: Text('Cambiar idioma'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: LanguageSelectPage(
                        title: 'Selecciona el idioma',
                        onLanguageSelect: (language) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ));
                },
              ),
              Consumer<AppState>(
                builder: (context, state, widget) => ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Actualizar base de datos'),
                  subtitle: FutureBuilder(
                    future: state.lastUpdate,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text('??lt. act: ${snapshot.data}');
                      } else {
                        return Text('');
                      }
                    },
                  ),
                  onTap: () async {
                    analytics.logEvent(name: 'manual-refresh');
                    try {
                      await state.updateLanguageData();
                    } on SocketException {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('No tienes internet'),
                            content: Text(
                                'No se pudo intentar actualizar la base de datos porque no tienes conexi??n a internet.'),
                            actions: [
                              TextButton(
                                child: Text('DE ACUERDO'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Error desconocido'),
                            content: Text(
                                'Ocurri?? un error desconocido. Por favor toma captura de pantalla y m??ndala a miyotl@googlegroups.com. El error es $e'),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ajustes'),
                onTap: () {
                  analytics.logEvent(name: 'open-settings');
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Compartir aplicaci??n'),
                onTap: () {
                  analytics.logShare(
                      contentType: 'invite', itemId: 'app', method: 'drawer');
                  Share.share(
                      '??Sab??as que hay una app donde puedes acercarte a nuestras lenguas ind??genas? ??Pr??ximamente podr??s aprenderlas!\n\nDesc??rgala en miyotl.org');
                },
              ),
              ListTile(
                leading: Icon(Icons.feedback),
                title: Text('Enviar retroalimentaci??n'),
                onTap: () {
                  analytics.logEvent(
                      name: 'contact', parameters: {'source': 'drawer'});
                  launch(
                    'mailto:miyotl@googlegroups.com?subject=Retroalimentaci??n sobre app',
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Acerca de'),
                onTap: () {
                  analytics.logEvent(name: 'open-about');
                  showAboutDialog(
                    context: context,
                    applicationIcon: CircleAvatar(
                      backgroundImage: AssetImage('img/icon-full-new.png'),
                      backgroundColor: Colors.white,
                    ),
                    applicationLegalese: 'Con amor desde Chapingo ??????',
//                       '''Fundadores y mesa directiva: Emilio ??lvarez (CEO), Gabriel Rodr??guez (CTO), Daniela Madrigal (COO), Carter Diegui??o (CFO y abogado),
// C??digo: Gabriel Rodr??guez
// Dibujos y CMO: Camila Varela
// Con amor desde Chapingo ??????''',
                    applicationVersion: 'versi??n inicial (beta)',
                    children: [
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Ver cr??ditos'),
                        onTap: () {
                          analytics.logEvent(name: 'view-credits');
                          launch(
                            'https://proyecto-miyotl.web.app/acerca_de',
                            forceWebView: true,
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Ionicons.logo_facebook),
                        title: Text('S??guenos en Facebook'),
                        onTap: () {
                          analytics.logEvent(name: 'view-facebook');
                          launch('https://fb.me/MiyotlApp');
                        },
                      ),
                      ListTile(
                        leading: Icon(Ionicons.logo_twitter),
                        title: Text('S??guenos en Twitter'),
                        onTap: () {
                          analytics.logEvent(name: 'view-twitter');
                          launch('https://twitter.com/MiyotlApp');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('M??ndanos un correo'),
                        onTap: () {
                          analytics.logEvent(
                              name: 'contact', parameters: {'source': 'about'});
                          launch('mailto:miyotl@googlegroups.com');
                        },
                      ),
                      ListTile(
                        leading: Icon(Ionicons.logo_github),
                        title: Text('Colabora en GitHub'),
                        onTap: () {
                          analytics.logEvent(name: 'view-github');
                          launch('https://github.com/miyotl/miyotl');
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
