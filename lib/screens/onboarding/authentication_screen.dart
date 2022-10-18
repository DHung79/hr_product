import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/authentication/auth.dart';
import '../../main.dart';
import '../../themes/jt_colors.dart';
import 'login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: JTColors.nWhite,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AuthenticationBlocController().authenticationBloc,
        listener: (context, state) {
          if (state is AppAutheticated) {
            navigateTo(homeRoute);
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: AuthenticationBlocController().authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            return LayoutBuilder(builder: (context, size) {
              final screenSize = MediaQuery.of(context).size;
              final bottomHeight = MediaQuery.of(context).viewInsets.bottom;
              return SizedBox(
                height: screenSize.height - bottomHeight,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.maxHeight / 3,
                        // child: Image.asset(
                        //   'assets/images/logo.png',
                        //   fit: BoxFit.fitWidth,
                        // ),
                        child: Center(
                          child: Container(
                            width: 162,
                            height: 106,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      LoginForm(state: state),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
