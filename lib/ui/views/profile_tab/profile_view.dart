import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppj/core/blocs/authentication/authentication.dart';
import 'package:ppj/core/blocs/user_profile/user_profile.dart';
import 'package:ppj/core/models/address.dart';
import 'package:ppj/core/models/user.dart';
import 'package:ppj/ui/widgets/app_bar.dart';
import 'profile_form_row.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  User _currentUser;
  var _nameController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _streetController = TextEditingController();
  var _zipCodeController = TextEditingController();
  var _cityController = TextEditingController();
  var _countryController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _getWidgetByState(UserProfileState state) {
      if (state is UserProfileLoading) {
        return Container(
            //color: Theme.of(context).primaryColorDark,
            child: Center(child: CircularProgressIndicator()));
      } else if (state is UserProfileCompleted) {
        return Scaffold(
            appBar: PPJAppBar(
                titleName: state.user.firstName + ' ' + state.user.name,
                trailingButton:
                    IconButton(onPressed: _saveUser, icon: Icon(Icons.check))),
            body: SingleChildScrollView(
                child: new Column(children: <Widget>[
              Container(
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      color: Colors.black12,
                      child: new Stack(
                        children: <Widget>[
                          Image.asset(
                            'assets/background.png',
                            width: double.infinity,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          new Positioned(
                            child: new Material(
                              child: new IconButton(
                                icon: new Image.asset(
                                  'assets/ic_camera.png',
                                  width: 30.0,
                                  height: 30.0,
                                  fit: BoxFit.cover,
                                  color: Theme.of(context).buttonColor,
                                ),
                                onPressed: () {
                                  _getBackgroundImage();
                                },
                                padding: new EdgeInsets.all(0.0),
                                //highlightColor: Colors.black,
                                iconSize: 30.0,
                              ),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(30.0)),
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            left: 5.0,
                            top: 5.0,
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 200.0,
                    ),
                    // Avatar and button
                    new Positioned(
                      child: new Stack(
                        children: <Widget>[
                          state.user != null &&
                                  state.user.profilePicture != null
                              ? ClipOval(
                                  child: Image(
                                      image: NetworkImage(
                                          state.user.profilePicture),
                                      width: 70.0,
                                      height: 70.0,
                                      fit: BoxFit.fill),
                                )
                              : new Image.asset(
                                  'assets/ic_avatar.png',
                                  width: 70.0,
                                  height: 70.0,
                                ),
                          Positioned(
                              bottom: -10.0,
                              right: -15.0,
                              child: new Material(
                                child: IconButton(
                                  icon: new Image.asset(
                                    'assets/ic_camera.png',
                                    width: 30.0,
                                    height: 30.0,
                                    fit: BoxFit.cover,
                                    color: Theme.of(context).buttonColor,
                                  ),
                                  onPressed: () {
                                    _getUserImage();
                                  },
                                  iconSize: 10.0,
                                ),
                                color: Colors.transparent,
                              )),
                        ],
                      ),
                      top: 160.0,
                      right: 5.0,
                    ),
                    new Column(
                      children: <Widget>[
                        Container(height: 200),
                        ProfileFormRow(
                          controller: _nameController,
                          label: "Nom",
                          hint: "Nom",
                        ),
                        ProfileFormRow(
                          controller: _firstNameController,
                          label: "Prénom",
                          hint: "Prénom",
                        ),
                        ProfileFormRow(
                          controller: _streetController,
                          label: "Adresse",
                          hint: "Adresse",
                        ),
                        // Address
                        new Container(
                          child: new Text(
                            'Code postal / Ville',
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          margin: new EdgeInsets.only(
                              left: 10.0, top: 30.0, bottom: 5.0),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _zipCodeController,
                                    decoration: new InputDecoration(
                                        hintText: "Code postal",
                                        border: new UnderlineInputBorder(),
                                        contentPadding:
                                            EdgeInsets.only(bottom: -20.0)),
                                  )),
                              Spacer(),
                              Expanded(
                                  flex: 8,
                                  child: TextFormField(
                                    controller: _cityController,
                                    decoration: new InputDecoration(
                                        hintText: "Ville",
                                        border: new UnderlineInputBorder(),
                                        contentPadding:
                                            EdgeInsets.only(bottom: -20.0)),
                                  ))
                            ],
                          ),
                          margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                        ),
                        ProfileFormRow(
                          controller: _countryController,
                          label: "Pays",
                          hint: "Pays",
                        ),
                        ProfileFormRow(
                          controller: _emailController,
                          label: "Email",
                          hint: "Email",
                          readOnly: true,
                        ),
                        ProfileFormRow(
                          controller: _phoneNumberController,
                          label: "N° Téléphone",
                          hint: "Téléphone",
                        ),
                        Center(
                            child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: RaisedButton(
                                  onPressed: () =>
                                      BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .add(LoggedOut()),
                                  child: Text(
                                    "Déconnexion",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )))
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )
                  ],
                ),
              )
            ])));
      }
      return Container();
    }

    return BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
      Scaffold.of(context).removeCurrentSnackBar();
      if (state is UserProfileError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.errorMsg}'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (state is UserProfileCompleted) {
        _currentUser = state.user;
        _nameController.text = state.user.name;
        _firstNameController.text = state.user.firstName;
        _emailController.text = state.user.email;
        _phoneNumberController.text = state.user.phoneNumber;
      }
    }, child: BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, state) {
      return _getWidgetByState(state);
    }));
  }

  Future _getBackgroundImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      //_backgroundImage = image;
    });
  }

  Future _getUserImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      //_userImage = image;
    });
  }

  void _saveUser() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _currentUser.email = _emailController.text;
    _currentUser.phoneNumber = _phoneNumberController.text;
    BlocProvider.of<UserProfileBloc>(context)
        .add(UpdateUserProfile(user: _currentUser));
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 30),
        content: Container(
          height: 20.0,
          child: new Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      height: 15.0,
                      width: 15.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ))),
              Center(child: Text('Mise à jour du profil...')),
            ],
          ),
        )));
  }
}
