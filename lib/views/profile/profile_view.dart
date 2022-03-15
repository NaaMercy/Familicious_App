import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
            child: const ListTile(
              title: Text("Naa Adoley Quaye"),
              subtitle: Text("Main Account"),
            ),
            color: Colors.pink[100],
            height: 300,
          ),
          Expanded(
              child: ListView(
            children: const [
              ListTile(
                  title: Text(
                'Basic Info',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
              ListTile(
                leading: Icon(
                  UniconsLine.mobile_android,
                  size: 30,
                ),
                title: Text('233 543639002', style: TextStyle(fontSize: 18)),
                subtitle: Text('Phone Number'),
              ),
              Divider(
                thickness: 0.5,
              ),
              ListTile(
                leading: Icon(
                  UniconsLine.calendar_alt,
                  size: 30,
                ),
                title: Text('05.07.1992', style: TextStyle(fontSize: 18)),
                subtitle: Text('Date of birth'),
              ),
              Divider(
                thickness: 0.5,
              ),
              ListTile(
                leading: Icon(
                  UniconsLine.location_point,
                  size: 30,
                ),
                title: Text('Jamestown', style: TextStyle(fontSize: 18)),
                subtitle: Text('Location'),
              ),
              Divider(
                thickness: 0.5,
              ),
              ListTile(
                leading: Icon(
                  UniconsLine.envelope,
                  size: 30,
                ),
                title:
                    Text('naadoley@gmail.com', style: TextStyle(fontSize: 18)),
                subtitle: Text('Email'),
              ),
            ],
          ))
        ],
      )),
    );
  }
}
