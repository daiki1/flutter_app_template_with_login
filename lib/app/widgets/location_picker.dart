import 'package:flutter/material.dart';
import 'package:flutter_app_template_with_login/app/widgets/custom_input.dart';
import 'package:get/get.dart';
import '../../models/city.dart';
import '../../models/country.dart';
import '../../models/state.dart';
import '../controllers/location_controller.dart';
import 'custom_dropdown.dart';

class LocationPicker extends StatelessWidget {
  final LocationController controller = Get.put(LocationController());
  final testController = TextEditingController();

  LocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown<Country>(
          label: 'country'.tr,
          items: controller.countries,
          selectedItem: controller.selectedCountry,
          itemLabel: (c) => c.name,
          hintText: 'select_country'.tr,
          onChanged: controller.onCountrySelected,
          enableSearch: true,
        ),
        CustomDropdown<StateModel>(
          label: 'state'.tr,
          items: controller.states,
          selectedItem: controller.selectedState,
          itemLabel: (c) => c.name,
          hintText: 'select_state'.tr,
          onChanged: controller.onStateSelected,
          enableSearch: true,
        ),
        CustomDropdown<City>(
          label: 'city'.tr,
          items: controller.cities,
          selectedItem: controller.selectedCity,
          itemLabel: (c) => c.name,
          hintText: 'select_city'.tr,
          onChanged: controller.onCitySelected,
          enableSearch: true,
          hasMoreItems: controller.hasMoreCities,
          onLoadMoreItems: () => controller.loadMoreCities(),
        ),

      ],
    );
  }
}