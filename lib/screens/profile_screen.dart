import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:divoc/common/constants.dart';
import 'package:divoc/common/form_field.dart';
import 'package:divoc/common/images.dart';
import 'package:divoc/common/loader.dart';
import 'package:divoc/models/address.dart';
import 'package:divoc/models/user.dart';
import 'package:divoc/services/globals.dart';
import 'package:divoc/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:divoc/services/utils.dart';

class ProfileScreen extends StatefulWidget {
  static const title = "Profil";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  String _name;
  String _email;
  String _mobile;
  String _gender;
  String _role;
  DateTime _birthdate;
  ImageService imageService = new ImageService();
  Address _address;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }

    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Card(
              child: Container(
                decoration: BoxDecoration(color: kCardColor),
                padding: EdgeInsets.all(35.0),
                child: ListView(
                  children: <Widget>[
                    if (user != null) ...[
                      Stack(
                        children: <Widget>[
                          Center(child: UserProfileImage(image: user.photo)),
                          Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: SizedBox(
                              height: 30.0,
                              width: 30.0,
                              child: FloatingActionButton(
                                heroTag: null,
                                mini: true,
                                elevation: 2.0,
                                child: user.photo.isNullEmptyOrWhitespace
                                    ? const Icon(Icons.add, size: 20.0)
                                    : const Icon(Icons.close, size: 20.0, color: Colors.red),
                                backgroundColor: user.photo.isNullEmptyOrWhitespace ? Colors.red : Colors.white,
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (user.photo.isNullEmptyOrWhitespace) {
                                    await imageService.uploadImage(user.id);
                                  } else {
                                    await imageService.deleteImage(user.id);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      GenericTextField(
                        title: 'Namn',
                        hint: 'Fyll i namn',
                        icon: Icons.person,
                        initialValue: user.name,
                        textInputType: TextInputType.text,
                        onChanged: (String val) => setState(() => _name = val),
                      ),
                      SizedBox(height: 20.0),
                      GenericTextField(
                        title: 'Email adress',
                        hint: 'Fyll i email adress',
                        icon: Icons.email,
                        initialValue: user.email,
                        textInputType: TextInputType.text,
                        onChanged: (String val) => setState(() => _email = val),
                      ),
                      SizedBox(height: 20.0),
                      GenericTextField(
                        title: 'Mobil nummer',
                        hint: 'Fyll i mobil nummer (inkl +46)',
                        icon: Icons.phone,
                        initialValue: user.mobile,
                        textInputType: TextInputType.phone,
                        onChanged: (String val) => setState(() => _mobile = val),
                      ),
                      SizedBox(height: 20.0),
                      GenericDropdownField(
                        title: 'Roll',
                        hint: 'Välj roll',
                        initialValue: user.fromRole,
                        icon: CommunityMaterialIcons.hospital,
                        options: User.USER_ROLES,
                        onChanged: (String val) => setState(() => _role = val),
                      ),
                      SizedBox(height: 20.0),
                      GenericDropdownField(
                        title: 'Kön',
                        hint: 'Välj kön',
                        initialValue: user.gender,
                        icon: CommunityMaterialIcons.gender_male_female,
                        options: ['Man', 'Kvinna', 'Annat'],
                        onChanged: (String val) => setState(() => _gender = val),
                      ),
                      SizedBox(height: 20.0),
                      GenericDateField(
                        title: 'Födelsedatum',
                        hint: 'Välj födelsedatum',
                        initialValue: user.birthdate.isNull ? null : user.birthdate,
                        onChanged: (DateTime val) {
                          setState(() {
                            _birthdate = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      GenericGoogleMapField(
                        title: 'Plats',
                        hint: 'Välj plats',
                        initialValue: user.formattedAddress,
                        onSelected: (Address address) {
                          _address = address;
                        },
                      ),
                      SizedBox(height: 40.0),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'Spara Ändringar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          String selectedRole = User.toRoleOrNull(_role);
                          await Global.userDoc.upsert(
                            ({
                              'name': _name ?? user.name,
                              'email': _email ?? user.email,
                              'mobile': _mobile ?? user.mobile,
                              'role': selectedRole ?? user.role,
                              'gender': _gender ?? user.gender,
                              'birthdate': _birthdate ?? user.birthdate,
                              'city': _address != null && !_address.city.isNullOrEmpty ? _address.city : user.city,
                              'state': _address != null && !_address.state.isNullOrEmpty ? _address.state : user.state,
                              'postalCode': _address != null && !_address.postalCode.isNullOrEmpty ? _address.postalCode : user.postalCode,
                              'street': _address != null && !_address.street.isNullOrEmpty ? _address.street : user.street,
                            }),
                          );
                        },
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Radera Konto',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(height: 30.0),
                    ],
                    if (user == null) ...[
                      Container(),
                    ]
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
