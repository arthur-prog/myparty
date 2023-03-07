import 'package:get/get.dart';
import 'package:my_party/src/features/Entities/AutocompletePrediction.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:my_party/src/features/Entities/PlaceAutocompleteResponse.dart';
import 'package:my_party/src/utils/network/network_utility.dart';


class SearchLocationController extends GetxController {
  static SearchLocationController get instance => Get.find();

  RxList<AutocompletePrediction> placePredictions = <AutocompletePrediction>[].obs;

  void onChanged(value) {
    print(value);
    placeAutocomplete(value);
  }

  void placeAutocomplete(String query) async {
    Uri uri =
    Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": FlutterConfig.get("GOOGLE_MAPS_API_KEY"),
    });
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
      PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        placePredictions.value = result.predictions!;
      }
    }
  }

}
