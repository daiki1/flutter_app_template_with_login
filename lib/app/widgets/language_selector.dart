import 'package:flutter/material.dart';
import 'package:flutter_app_template_with_login/app/widgets/form_section.dart';
import 'package:get/get.dart';

import '../controllers/language_controller.dart';

class LanguageSelector extends StatelessWidget {
  LanguageSelector({super.key});

  final LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return FormSection(
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            value: controller.currentLocaleKey.value,
            icon: const Icon(Icons.language, color: Colors.orange),
            dropdownColor: Colors.white,
            isExpanded: true,
            onChanged: (value) {
              if (value != null) {
                controller.updateLocale(value);
              }
            },
            items: controller.languages.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}