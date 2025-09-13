// Step 2: Install loading app screen
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

// Step 3: Check internet connection
import 'package:connectivity_plus/connectivity_plus.dart';
// Step 4: Show toast message
import 'package:fluttertoast/fluttertoast.dart';

// Step 6: Firestore CRUD operations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_flutter_67_1_2/services/firestore.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  // อะไรที่อยากให้ทำงานตอนเริ่มต้น ให้ใส่ในนี้
  void initState() {
    super.initState();

    // Step 3: Check internet connection
    checkInternetConnection();
  }

  // Step 3: Check internet connection
  void checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      _showToast(context, "Mobile network available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      _showToast(context, "Wi-fi is available.");
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
      _showToast(context, "Ethernet connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      _showToast(context, "Vpn connection active.");
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      _showToast(context, "Bluetooth connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
      _showToast(context, "Other network is available.");
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      setState(() {
        _showAlertDialog(
          context,
          "No Internet",
          "Please check your internet connection.",
        );
      });
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: FractionalOffset(0, 0),
          end: FractionalOffset(0.5, 0.6),
          tileMode: TileMode.mirror,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              './android/assets/image/app_screen.png',
              height: 100,
            ),
          ),
          const SizedBox(height: 20),
          const SpinKitSpinningLines(color: Colors.pinkAccent),
        ],
      ),
    );
  }
}

// Step 4: Show toast message
void _timer(BuildContext context) {
  // เมื่อรครบ 3 วิ ให้ไปหน้า SecondScreen
  Timer(
    const Duration(seconds: 3),
    () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    ),
  );
}

// Step 4: Show toast message
void _showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.lightGreen,
    textColor: Colors.white,
    fontSize: 24.0,
  );
  _timer(context);
}

// Step 4: Show toast message
void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.redAccent,
            fontWeight: FontWeight.w500,
            fontFamily: "Alike",
          ),
        ),
        content: Text(msg),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black54),
            ),
            onPressed: () {
              Navigator.pop(context); // ถอยหลัง 1 หน้า
            },
            child: Text(
              "OK",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue.shade200,
                fontWeight: FontWeight.w500,
                fontFamily: "Alike",
              ),
            ),
          ),
        ],
      );
    },
  );
}

// class SecondScreen extends StatelessWidget {
//   const SecondScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Second Screen')),
//       body: const Center(
//         child: Text(
//           'This is the second screen',
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.amberAccent,
//             fontWeight: FontWeight.w500,
//             fontFamily: "Alike",
//           ),
//         ),
//       ),
//     );
//   }
// }

// Step 6: Firestore CRUD operations
class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  // make an instance of FirestoreService
  final FirestoreService firestoreService = FirestoreService();

  // text editing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Open a dialog to add a new person
  void openPersonBox(String? personID) async {
    if (personID != null) {
      // Update Case
      final person = await firestoreService.getPersonById(personID);
      nameController.text = person['personName'] ?? '';
      emailController.text = person['personEmail'] ?? '';
      ageController.text = person['personAge']?.toString() ?? '';
    } else {
      // Create Case
      nameController.clear();
      emailController.clear();
      ageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String name = nameController.text;
              final String email = emailController.text;
              final int age = int.tryParse(ageController.text) ?? 0;

              if (personID != null) {
                // Update
                firestoreService.updatePerson(personID, name, email, age);
              } else {
                // Create
                firestoreService.addPerson(name, email, age);
              }

              nameController.clear();
              emailController.clear();
              ageController.clear();

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preson List"),
        automaticallyImplyLeading: false, // Disable back button
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openPersonBox(null),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getPersons(),
        builder: (context, snapshot) {
          // if we have data, get the list of persons
          if (snapshot.hasData) {
            List personsList = snapshot.data!.docs;

            // Diplay persons list
            return ListView.builder(
              itemCount: personsList.length,
              itemBuilder: (context, index) {
                // get each individual person
                DocumentSnapshot person = personsList[index];
                String personId = person.id;

                // get person from person document
                Map<String, dynamic> personData =
                    person.data() as Map<String, dynamic>;

                String nameText = personData['personName'] ?? '';
                String emailText = personData['personEmail'] ?? '';
                int ageText = personData['personAge'] ?? 0;

                return ListTile(
                  title: Text('$nameText (Age: $ageText)'),
                  subtitle: Text(emailText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // print('Edit pressed: $personId'); // debug
                          openPersonBox(personId);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            firestoreService.deletePerson(personId),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // if we don't have data, show message
          else {
            return const Center(
              child: Text(
                "No data available",
                style: TextStyle(fontSize: 24, color: Colors.redAccent),
              ),
            );
          }
        },
      ),
    );
  }
}
