import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_party/src/common_widgets/form/form_header_widget.dart';
import 'package:my_party/src/common_widgets/profile_line/profile_line_widget.dart';
import 'package:my_party/src/features/Entities/Party.dart';

import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/features/controllers/party/add_party_controller.dart';
import 'package:my_party/src/features/screens/party/add_party/add_guests/add_guests.dart';
import 'package:my_party/src/features/screens/party/add_party/location/search_location_widget.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/repository/party_repository/party_repository.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddParty extends StatelessWidget {
  AddParty({
    Key? key,
  }) : super(key: key);

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  final _controller = Get.put(AddPartyController());

  @override
  Widget build(BuildContext context) {
    final thisUser = _authRepo.firebaseUser;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormHeaderWidget(
                      title: AppLocalizations.of(context)!.createParty,
                      subTitle: ""),
                  Form(
                    key: _controller.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) =>
                              _controller.validateName(value!),
                          controller: _controller.nameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.name,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SearchLocationWidget(
                            locationController: _controller.locationController),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _controller.dateController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today),
                            labelText: AppLocalizations.of(context)!.date,
                          ),
                          readOnly: true,
                          onTap: _controller.selectDate,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const AddGuests(),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                _controller.addParty(thisUser.value!.uid),
                            child: Text(
                              AppLocalizations.of(context)!.createParty,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
