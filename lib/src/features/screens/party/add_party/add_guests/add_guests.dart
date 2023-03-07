import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/profile_line/profile_line_widget.dart';
import 'package:my_party/src/features/controllers/party/add_guests/add_guests_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/features/controllers/party/add_party_controller.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;


class AddGuests extends StatefulWidget {
  const AddGuests({Key? key}) : super(key: key);

  @override
  State<AddGuests> createState() => _AddGuestsState();
}

class _AddGuestsState extends State<AddGuests> {
  final _controller = Get.put(AddGuestsController());
  final _partyController = Get.put(AddPartyController());

  final _userRepo = Get.put(UserRepository());

  final _authRepo = Get.put(AuthenticationRepository());

  @override
  void initState() {
    _controller.guestController.addListener(() {
      _controller.guestStream.add(_controller.guestController.text);
    });
    super.initState();
  }

  void dispose() {
    _controller.guestStream.close();
    // _controller.guestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thisUser = _authRepo.firebaseUser.value;
    return Column(
      children: [
        TextFormField(
          controller: _controller.guestController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.inviteFriends,
          ),
        ),

        StreamBuilder(
          stream: _controller.guestStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: _userRepo.getFriends(thisUser!.uid),
                builder: (context, snapshotUsers){
                  if(snapshotUsers.connectionState == ConnectionState.done){
                    if (snapshotUsers.hasData){
                      List<U.User> users = snapshotUsers.data as List<U.User>;
                      List<Widget> list = [];
                      users.forEach((user) {
                        bool isUserInGuestList = false;
                        _partyController.guests.forEach((guest) {
                          if(guest.userId == user.userId){
                            isUserInGuestList = true;
                          }
                        });
                        if(!isUserInGuestList){
                          list.add(ProfileLineWidget(
                            user: user,
                            icon: Icons.add,
                            iconOnPressed: () => _controller.addGuest(user),
                          ));
                        }
                      });
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: list,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(AppLocalizations.of(context)!.noUsers)),
                      );
                    }
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),

        // const SizedBox(
        //   height: 20,
        // ),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton(
        //     onPressed: addGuest,
        //     child:  Text(
        //       AppLocalizations.of(context)!.addGuest,
        //     ),
        //   ),
        // ),

        const SizedBox(
          height: 20,
        ),

        Obx(
              () => ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _partyController.guests.length,
            itemBuilder: (context, index) {
              U.User user = _partyController.guests.value[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProfileLineWidget(
                  user: user,
                  icon: Icons.delete_outlined,
                  iconOnPressed:
                      () => _controller.removeGuest(user),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

