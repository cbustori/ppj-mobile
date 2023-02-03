import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ppj/core/blocs/login/login.dart';
import 'package:ppj/core/enums/social_type.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController(text: "admin@enrealit.fr");
  final _passwordController = TextEditingController(text: "ppj");

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }

    _onLoginSocialButtonPressed(SocialType type) {
      BlocProvider.of<LoginBloc>(context).add(
        LoginSocialButtonPressed(type: type),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
              children: [
                // email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                // password
                TextFormField(
                  controller: _passwordController,
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  height: 55,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed:
                          state is! LoginLoading ? _onLoginButtonPressed : null,
                      padding: EdgeInsets.all(12),
                      color: Colors.lightBlueAccent,
                      child: Text('Connexion',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Text(" OU "),
                  Expanded(child: Divider()),
                ]),
                SizedBox(height: 10.0),
                // Google login
                Container(
                  height: 55,
                  child: SignInButton(
                    Buttons.Google,
                    mini: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () async {
                      if (state is! LoginLoading) {
                        _onLoginSocialButtonPressed(SocialType.GOOGLE);
                      }
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                // Facebook login
                Container(
                  height: 55,
                  child: SignInButton(
                    Buttons.Facebook,
                    mini: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () async {
                      if (state is! LoginLoading) {
                        _onLoginSocialButtonPressed(SocialType.FACEBOOK);
                      }
                    },
                  ),
                ),

                // forgotLabel
                FlatButton(
                  child: Text(
                    'Mot de passe oublié?',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
