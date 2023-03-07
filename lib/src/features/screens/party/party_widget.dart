import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:my_party/src/features/Entities/Party.dart';
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class PartyWidget extends StatelessWidget {
  PartyWidget({
    super.key,
    required this.party,
  });

  final Party party;
  final _userRepo = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    print(party.location);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Card(
        child: SizedBox(
          height: 0.3 * MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                Center(
                  child: Text(
                    party.name,
                    style: Theme.of(Get.context!).textTheme.headline2,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: party.guestList.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<String>(
                          future: _userRepo
                              .getProfilPicture(party.guestList[index]),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                  radius: 20.0,
                                );
                              }
                            }
                            return const CircleAvatar(
                              backgroundImage: NetworkImage(profilePicture),
                              radius: 20.0,
                            );
                          });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    party.date != "" ?
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.date_range_outlined,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            party.date!,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ) : const SizedBox(),
                    party.location != null && (party.location?.latitude != 0 && party.location?.longitude != 0) ?
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.location_on_outlined,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            party.date!,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ) : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
