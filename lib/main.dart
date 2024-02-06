import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';

void main() => runApp(const FlutterWifiList());

class FlutterWifiList extends StatefulWidget {
  const FlutterWifiList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlutterWifiListState createState() => _FlutterWifiListState();
}

class _FlutterWifiListState extends State<FlutterWifiList> {
  List<WifiNetwork> _wifiNetworks = [];

  @override
  void initState() {
    super.initState();
    _loadWifiList();
  }

  Future<void> _loadWifiList() async {
    try {
      List<WifiNetwork> wifiList = await WiFiForIoTPlugin.loadWifiList();
      setState(() {
        _wifiNetworks = wifiList;
      });
    } catch (e) {
      print("Error loading Wi-Fi list: $e");
    }
  }

  Future<void> _rescanWifiList() async {
    await _loadWifiList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wi-Fi List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nearby Wi-Fi Networks'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: _rescanWifiList,
              child: Text('Rescan Wi-Fi'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _wifiNetworks.length,
                itemBuilder: (context, index) {
                  WifiNetwork wifi = _wifiNetworks[index];
                  return ListTile(
                    title: Text(wifi.ssid ?? 'Unknown SSID'),
                    subtitle: Text('Signal Strength: ${wifi.level} dBm'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
