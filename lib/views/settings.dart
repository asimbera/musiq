import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/version_controller.dart';
import '../controllers/config_controller.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _info = Provider.of<VersionController>(context).info;
    final _config = Provider.of<ConfigController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('General'),
            dense: true,
          ),
          SwitchListTile(
            title: Text('Dark Theme'),
            secondary: Icon(Icons.brightness_4),
            value: _config.darkMode,
            // onChanged: (val) => _config.toogleDarkMode(val),
            onChanged: (_) => null,
          ),
          ListTile(
            title: Text('Stream Quality'),
            leading: Icon(Icons.high_quality),
            subtitle: Text('High'),
            enabled: false,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column();
                },
              );
            },
          ),
          ListTile(
            title: Text('Advanced'),
            dense: true,
          ),
          ListTile(
            title: Text('Clear Cache'),
            leading: Icon(Icons.delete_forever),
            enabled: false,
          ),
          Divider(),
          ListTile(
            title: Text('Check Updates'),
            leading: Icon(Icons.update),
          ),
          AboutListTile(
            icon: Icon(Icons.info),
            applicationName: _info.appName,
            applicationVersion: _info.version,
            applicationLegalese: 'Free and Open Source Music Player',
          ),
        ],
      ),
    );
  }
}
