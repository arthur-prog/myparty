import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/snackbar/snackbar_information_widget.dart';
import 'package:my_party/src/features/Entities/Party.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PartyRepository extends GetxController {
  static PartyRepository get instance => Get.find();

  final partysCollection = FirebaseFirestore.instance.collection('partys');

  Future<void> addParty(Party party){
    final partyDoc = partysCollection.doc();
    return partyDoc.set(party.toMap())
        .whenComplete(
          () => SnackBarInformationWidget(
        text: AppLocalizations.of(Get.context!)!.createdParty,
        title: AppLocalizations.of(Get.context!)!.success,
        type: "success",
      ),
    )
        .catchError((error, stackTrace) {
      SnackBarInformationWidget(
        text: AppLocalizations.of(Get.context!)!.somethingWentWrong,
        title: AppLocalizations.of(Get.context!)!.error,
        type: "error",
      );
      print(error.toString());
    });
  }

}
