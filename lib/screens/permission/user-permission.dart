import 'package:flutter/material.dart';

class UserPermission extends StatefulWidget {
  const UserPermission({super.key});

  @override
  State<UserPermission> createState() => _UserPermissionState();
}

class _UserPermissionState extends State<UserPermission> {
    String? selectedPermission;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('İcaze'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text(
                    "Zehmet Olmasa İcaze Sebebini Açıqlayan Bir Metin Yazın",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                buildTextArea(),
                SizedBox(height: 30),
                Center(
                  child: buildDropdown(),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // İşlemler
                    },
                    child: Text(
                      "Gönder",
                      style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextArea() {
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "İcaze sebebini yazın...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.all(15),
      ),
    );
  }

  Widget buildDropdown() {
    return DropdownButton<String>(
      value: selectedPermission,
      hint: const Text("Icaze Muddeti"),
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black, fontSize: 16),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedPermission = newValue!;
        });
      },
      items: <String>['1 gün', '2 gün', '3 gün', '1 hafta']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(child: Text(value)),
        );
      }).toList(),
    );
  }
}
