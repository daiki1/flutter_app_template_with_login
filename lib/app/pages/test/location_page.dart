import 'package:flutter/material.dart';
import 'package:flutter_app_template_with_login/app/widgets/custom_input.dart';
import 'package:get/get.dart';

import '../../widgets/location_picker.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPage();
}

class _LocationPage extends State<LocationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('location'.tr)),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LocationPicker(),
            ],
          ),
        ),
      ),
    );
  }
}
