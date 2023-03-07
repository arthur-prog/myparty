import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/features/controllers/party/location/search_location_controller.dart';
import 'package:my_party/src/features/screens/party/add_party/location/location_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchLocationWidget extends StatelessWidget {
  SearchLocationWidget({Key? key, required this.locationController}) : super(key: key);

  final TextEditingController locationController;

  final _controller = Get.put(SearchLocationController());

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Form(
            child: TextFormField(
              onChanged: (value) => _controller.onChanged(value),
              controller: locationController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on_outlined),
                labelText: AppLocalizations.of(context)!.location,
              ),
            ),
          ),
          Obx(
            () => Container(
              height: _controller.placePredictions.isNotEmpty ? 200 : 0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: _controller.placePredictions.length,
                itemBuilder: (context, index) => LocationListTile(
                  press: () {
                    locationController.text = _controller.placePredictions[index].description!;
                    _controller.placePredictions.clear();
                  },
                  location: _controller.placePredictions[index].description!,
                ),
              ),
            ),
          ),
        ],
      );
  }
}
