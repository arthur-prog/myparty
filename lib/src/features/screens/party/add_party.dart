import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_party/src/features/Entities/Party.dart';

import 'package:my_party/src/features/Entities/User.dart' as U;

class AddParty extends StatefulWidget {
  const AddParty({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<AddParty> createState() => _AddPartyState();
}

class _AddPartyState extends State<AddParty> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _guestController = TextEditingController();

  List<String> guests = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          child: Column(
            children: <Widget> [

              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),



              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: guests.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(guests[index]),
                  );
                },
              ),
              TextField(
                controller: _guestController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Guest',
                ),
              ),
              TextButton(
                onPressed: () async {
                  U.User? user = await U.User.getUserByUsername(_guestController.text);
                  setState(() {
                    guests.add(user!.userId);
                  });
                },
                child: const Text(
                  "Add Guest",
                ),
              ),

              TextButton(
                onPressed: () async {
                  if (_nameController.text != ''){
                    Party party = Party(name: _nameController.text, userId: widget.user.uid, guestList: guests);
                    await party.addParty();
                  } else {
                    print('name is null!!!');
                  }
                },
                child: const Text(
                  "Add Party",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
