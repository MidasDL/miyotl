import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lenguas/models/app_state.dart';
import 'package:lenguas/models/settings.dart';
import 'package:lenguas/screens/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:system_settings/system_settings.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajustes',
          style: GoogleFonts.fredokaOne(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Consumer2<Settings, UserAccount>(
          builder: (context, settings, account, child) => SettingsList(
            backgroundColor: Colors.transparent,
            sections: [
              SettingsSection(
                title: 'Apariencia',
                tiles: [
                  SettingsTile(
                    title: 'Tema',
                    subtitle: settings.theme.string(),
                    leading: Icon(Icons.lightbulb),
                    onPressed: (BuildContext context) {
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('Tema'),
                          children: [
                            for (var value in ThemeMode.values)
                              RadioListTile<ThemeMode>(
                                title: Text('${value.string()}'),
                                value: value,
                                groupValue: settings.theme,
                                onChanged: (value) {
                                  settings.theme = value;
                                  analytics.setUserProperty(
                                      name: 'theme',
                                      value: '${settings.theme}');
                                  Navigator.of(context).pop();
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Estilo',
                    subtitle: settings.useIOSStyle ? 'iOS' : 'Android',
                    leading: Icon(
                      settings.useIOSStyle
                          ? Ionicons.logo_apple
                          : Icons.android,
                    ),
                    onPressed: (context) => showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text('Estilo'),
                        children: [
                          RadioListTile<bool>(
                            title: Text('iOS'),
                            value: true,
                            groupValue: settings.useIOSStyle,
                            onChanged: (value) {
                              analytics.setUserProperty(
                                  name: 'ux', value: 'ios');
                              settings.useIOSStyle = value;
                              Navigator.of(context).pop();
                            },
                          ),
                          RadioListTile<bool>(
                            title: Text('Android'),
                            value: false,
                            groupValue: settings.useIOSStyle,
                            onChanged: (value) {
                              analytics.setUserProperty(
                                  name: 'ux', value: 'android');
                              settings.useIOSStyle = value;
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SettingsSection(
                title: 'Cuenta',
                tiles: [
                  SettingsTile(
                    title:
                        '${account.displayName == null ? 'Iniciar sesi??n' : 'Cambiar de cuenta'}',
                    subtitle:
                        '${account.displayName == null ? 'No hay ninguna sesi??n iniciada' : 'Iniciaste sesi??n como ${account.displayName}'}',
                    leading: Icon(Icons.switch_account),
                    onPressed: (context) {
                      analytics.logEvent(name: 'switch-user');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            body: SignInPage(onSignIn: () {
                              Navigator.of(context).pop();
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    title: 'Cerrar sesi??n',
                    leading: Icon(Icons.logout),
                    onPressed: (context) {
                      analytics.logEvent(name: 'log-out');
                      account.logOut();
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: 'Varios',
                tiles: [
                  SettingsTile(
                    title: 'Notificaciones',
                    leading: Icon(Icons.notifications),
                    onPressed: (context) {
                      analytics.logEvent(name: 'open-notification-settings');
                      SystemSettings.appNotifications();
                    },
                  ),
                  SettingsTile(
                    title: 'T??rminos y condiciones',
                    leading: Icon(Icons.description),
                    onPressed: (context) {
                      analytics.logEvent(
                          name: 'view-terms',
                          parameters: {'source': 'settings'});
                      launch(
                        'https://proyecto-miyotl.web.app/terminos',
                        forceWebView: true,
                      );
                    },
                  ),
                  SettingsTile(
                      title: 'Pol??tica de privacidad',
                      leading: Icon(Icons.privacy_tip),
                      onPressed: (context) {
                        analytics.logEvent(
                            name: 'view-privacy',
                            parameters: {'source': 'settings'});
                        launch(
                          'https://proyecto-miyotl.web.app/privacidad',
                          forceWebView: true,
                        );
                      }),
                  SettingsTile(
                    title: 'Enviar retroalimentaci??n',
                    leading: Icon(Icons.feedback),
                    onPressed: (context) {
                      analytics.logEvent(
                          name: 'contact', parameters: {'source': 'settings'});
                      launch(
                          'mailto:miyotl@googlegroups.com?subject=Retroalimentaci??n sobre app');
                    },
                  ),
                  SettingsTile(
                    title: 'Opciones avanzadas y diagn??sticos',
                    leading: Icon(Icons.bug_report),
                    onPressed: (context) {
                      analytics.logEvent(name: 'open-developer-menu');
                      Navigator.of(context).pushNamed('/debug');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
