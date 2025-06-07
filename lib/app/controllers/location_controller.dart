import 'package:get/get.dart';

import '../../models/city.dart';
import '../../models/country.dart';
import '../../models/state.dart';
import '../../services/loading_service.dart';
import '../../services/location_service.dart';

/// LocationController is responsible for managing the location-related data
class LocationController extends GetxController {
  var countries = <Country>[].obs;
  var states = <StateModel>[].obs;
  var cities = <City>[].obs;

  var selectedCountry = Rx<Country?>(null);
  var selectedState = Rx<StateModel?>(null);
  var selectedCity = Rx<City?>(null);

  var cityPage = 0.obs;
  final int cityPageSize = 100;

  var hasMoreCities = true.obs;

  final loader = Get.find<LoadingService>();


  @override
  void onInit() {
    super.onInit();
    loadCountries();
  }

  /// Loads the list of countries from the LocationService.
  void loadCountries() async {
    try {
      countries.value = await LocationService.getCountries();
    } catch (e) {
      Get.snackbar('error'.tr, 'could_not_load_countries'.tr);
    }
  }

  /// Handles the selection of a country.
  void onCountrySelected(Country? country) async {
    selectedCountry.value = country;
    selectedState.value = null;
    selectedCity.value = null;
    states.clear();
    cities.clear();
    cityPage.value = 0;
    hasMoreCities.value = true;

    if (country != null) {
      try {
        states.value = await LocationService.getStates(country.id);
      } catch (e) {
        Get.snackbar('error'.tr, 'could_not_load_states'.tr);
      }
    }
  }

  /// Handles the selection of a state.
  void onStateSelected(StateModel? state) async {
    selectedState.value = state;
    selectedCity.value = null;
    cities.clear();
    cityPage.value = 0;
    hasMoreCities.value = true;

    if (state != null) {
      await loadMoreCities();
    }
  }

  /// Loads more cities for the selected state.
  Future<void> loadMoreCities() async {
    if (!hasMoreCities.value || selectedState.value == null) return;

    loader.show();
    try {
      final newCities = await LocationService.getCities(selectedState.value!.id, cityPage.value, cityPageSize);
      if (newCities.length < cityPageSize) {
        hasMoreCities.value = false;
      }
      cities.addAll(newCities);
      cityPage.value++;
    } catch (e) {
      Get.snackbar('error'.tr, 'could_not_load_cities'.tr);
    }finally{
      loader.hide();
    }

  }

  /// Handles the selection of a city.
  void onCitySelected(City? city) {
    selectedCity.value = city;
  }
}