import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_app/screens/permission/user-permission.dart';
import 'package:work_app/screens/profile/user_profile.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  String userName = "UserName";
  String userSurname = "UserSurname";
  String userPhone = "UserPhone";
  bool isWorkingButtonVisible = false;
  final LatLng officeLocation = LatLng(40.36878995923975, 49.82711960253402);
  String? selectedReason;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
    _checkProximityToOffice();
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "UserName";
      userSurname = prefs.getString('user_surname') ?? "UserSurname";
      userPhone = prefs.getString('user_phone') ?? "UserPhone";
    });
  }

  Future<void> _checkProximityToOffice() async {
    try {
      Position userPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        officeLocation.latitude,
        officeLocation.longitude,
      );
      setState(() {
        isWorkingButtonVisible = distanceInMeters <= 100;
      });
    } catch (e) {
      print('Konum alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[300],
        title: Text(
          '$userName $userSurname',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.border_color),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserPermission()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: officeLocation,
              zoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: officeLocation,
                    radius: 100,
                    useRadiusInMeter: true,
                    color: Colors.red.withOpacity(0.3),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: isWorkingButtonVisible
                  ? GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        height: 50,
                        width: 130,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "I Am Working",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          if (!isWorkingButtonVisible) 
            Positioned(
              bottom: 60, 
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: DropdownButton<String>(
                        value: selectedReason,
                        hint: const Text("Neden Çalışamıyorsunuz?"),
                        items: <String>["Trafik Var", "Hastayım","Lotuyam"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedReason = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20), 
                    GestureDetector(
                      onTap: () {
                        if (selectedReason != null) {
                          print("Seçilen neden: $selectedReason");
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 130,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Gönder",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

