import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class ProfileLineWidget extends StatelessWidget {
  ProfileLineWidget({
    Key? key,
    required this.user,
    this.buttonTitle,
    this.buttonOnPressed,
    this.icon,
    this.iconOnPressed,
  }) : super(key: key);

  final U.User user;
  VoidCallback? buttonOnPressed;
  VoidCallback? iconOnPressed;
  IconData? icon;
  String? buttonTitle;


  @override
  Widget build(BuildContext context) {
    print(buttonTitle);
    final _userRepo = Get.put(UserRepository());
    return Row(
      children: <Widget>[
        SizedBox(
          width: 55,
          height: 55,
          child: FutureBuilder<String>(
              future: _userRepo.getProfilPicture(user.userId ?? ""),
              builder: (BuildContext context,
                  AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!),
                    radius: 60.0,
                  );
                }
                return const CircleAvatar(
                  backgroundImage: NetworkImage(profilePicture),
                  radius: 60.0,
                );
              }),
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.userName),
            if(user.firstName != null && user.lastName != null)
              Row(
                children: [
                  Text(user.firstName!, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 5,),
                  Text(user.lastName!, style: const TextStyle(color: Colors.grey)),
                ],
              )
          ],
        ),
        const Spacer(),

        if(buttonTitle != null)
          OutlinedButton(
              onPressed: buttonOnPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(buttonTitle!),
              )
          ),

        if(icon != null)
          IconButton(
            onPressed: iconOnPressed,
            icon: Icon(
                icon
            ),
          ),
      ],
    );
  }
}