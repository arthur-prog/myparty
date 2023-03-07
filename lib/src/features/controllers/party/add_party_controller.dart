import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_party/src/features/Entities/Party.dart';
import 'package:my_party/src/repository/party_repository/party_repository.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPartyController extends GetxController {
  static AddPartyController get instance => Get.find();

  final _partyRepo = Get.put(PartyRepository());
  final _userRepo = Get.put(UserRepository());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxList<U.User> guests = <U.User>[].obs;

  void addParty(String userId) async {
    if (formKey.currentState!.validate()) {
      List<String> guestIdList = [];
      for (U.User user in guests) {
        guestIdList.add(user.userId);
      }
      List<Location> location =
      await locationFromAddress(locationController.text);
      final geoPoint = GeoPoint(location[0].latitude, location[0].longitude);
      Party party = Party(
        name: nameController.text,
        userId: userId,
        location: geoPoint,
        date: dateController.text,
        guestList: guestIdList,
      );
      await _partyRepo.addParty(party);
    }
  }

  void selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime(2000),
        firstDate: DateTime(1920),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
    } else {
      print("Date is not selected");
    }
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      return AppLocalizations.of(Get.context!)!.nameRequired;
    }
    return null;
  }
}
