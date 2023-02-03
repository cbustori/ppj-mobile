import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppj/core/blocs/authentication/authentication.dart';
import 'package:ppj/core/blocs/login/login.dart';
import 'package:ppj/core/repositories/user_repository.dart';
import 'package:ppj/ui/views/login_form.dart';

class LoginView extends StatelessWidget {
  final UserRepository userRepository;

  LoginView({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
          children: <Widget>[
            // Logo
            Container(
              height: 250,
              child: Image.asset('assets/logo_ppj.png'),
            ),

            SizedBox(height: 10.0),

            BlocProvider(
                builder: (context) {
                  return LoginBloc(
                    authenticationBloc:
                        BlocProvider.of<AuthenticationBloc>(context),
                    userRepository: userRepository,
                  );
                },
                child: LoginForm())
          ],
        ),
      ),
    );
  }
}
