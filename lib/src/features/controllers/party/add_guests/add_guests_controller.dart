import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/features/controllers/party/add_party_controller.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;


class AddGuestsController extends GetxController {
  static AddGuestsController get instance => Get.find();

  final _partyController = Get.put(AddPartyController());

  TextEditingController guestController = TextEditingController();
  StreamController<String> guestStream = StreamController<String>();

  void addGuest(U.User user) async {
    guestController.text = "";
    _partyController.guests.add(user);
  }

  void removeGuest(U.User user) {
    _partyController.guests.remove(user);
  }

}
