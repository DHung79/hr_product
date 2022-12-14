import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import '../../../../main.dart';
import '../../../base/rest/models/rest_api_response.dart';
import '../../auth.dart';
import '../../models/status.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    final AuthenticationRepository authenticationService =
        AuthenticationRepository();

    on<AppLoadedup>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      emit(AuthenticationLoading());
      try {
        if (sharedPreferences.getString('authtoken') != null) {
          emit(AppAutheticated());
        } else {
          emit(AuthenticationStart());
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<UserSignUp>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;
      emit(AuthenticationLoading());

      final userId = sharedPreferences.getString('reset_id') ?? '';

      final data = await authenticationService.signUpWithEmailAndPassword(
        userId,
        event.password,
      );
      try {
        if (data is ApiResponse) {
          if (data.error == null) {
            sharedPreferences.remove('reset_id');
            emit(ResetPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(ResetPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<UserLogin>(
      (event, emit) async {
        final SharedPreferences sharedPreferences = await prefs;
        emit(AuthenticationLoading());
        try {
          final data = await authenticationService.userLogin(
            event.email,
            event.password,
          );
          if (data["error_message"] == null) {
            final currentUser = Token.fromJson(data);
            if (currentUser.id.isNotEmpty) {
              final now = DateTime.now().millisecondsSinceEpoch;
              sharedPreferences.setString('authtoken', currentUser.token);
              sharedPreferences.setString('last_username', event.email);
              sharedPreferences.setString('last_userpassword', event.password);
              sharedPreferences.setBool('keep_session', event.keepSession);
              sharedPreferences.setInt('login_time', now);
              emit(AppAutheticated());
            } else {
              emit(AuthenticationNotAuthenticated());
            }
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        } on Error catch (e) {
          emit(AuthenticationFailure(
            message: e.toString(),
            errorCode: '',
          ));
          logDebug(e);
        }
      },
    );

    on<UserLoginGoogle>(
      (event, emit) async {
        final SharedPreferences sharedPreferences = await prefs;

        emit(AuthenticationLoading());
        try {
          final data =
              await authenticationService.loginWithGoogle(event.accessToken);

          if (data["error_message"] == null) {
            final currentUser = Token.fromJson(data);
            if (currentUser.id.isNotEmpty) {
              final now = DateTime.now().millisecondsSinceEpoch;
              sharedPreferences.setString('authtoken', currentUser.token);
              sharedPreferences.setBool('keep_session', event.keepSession);
              sharedPreferences.setInt('login_time', now);
              emit(AppAutheticated());
            } else {
              emit(AuthenticationNotAuthenticated());
            }
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        } on Error catch (e) {
          emit(AuthenticationFailure(
            message: e.toString(),
            errorCode: '',
          ));
        }
      },
    );

    on<ResetPassword>((event, emit) async {
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final userId = sharedPreferences.getString('reset_id') ?? '';
        final data = await authenticationService.resetPassword(
          userId,
          event.password,
        );
        if (data is ApiResponse) {
          if (data.error == null) {
            sharedPreferences.remove('reset_id');
            emit(ResetPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(ResetPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<CheckRegisterEmail>(
      (event, emit) async {
        try {
          final data = await authenticationService.checkRegisterEmail(
            event.email,
          );
          if (data is ApiResponse) {
            if (data.error == null) {
              emit(CheckEmailDoneState());
            } else {
              emit(AuthenticationFailure(
                message: data.error!.errorMessage,
                errorCode: data.error!.errorCode,
              ));
            }
          } else {
            if (data["error_message"] == null) {
              emit(CheckEmailDoneState());
            } else {
              emit(AuthenticationFailure(
                message: data["error_message"],
                errorCode: data["error_code"].toString(),
              ));
            }
          }
        } on Error catch (e) {
          emit(
            AuthenticationFailure(
              message: e.toString(),
              errorCode: '',
            ),
          );
          logDebug(e);
        }
      },
    );

    on<UserLogOut>((event, emit) async {
      await _cleanupCache();
      emit(UserLogoutState());
    });

    on<GetUserData>((event, emit) async {
      final SharedPreferences sharedPreferences = await prefs;

      final token = sharedPreferences.getString('authtoken');
      if (token == null || token.isEmpty) {
        await _cleanupCache();
        emit(AuthenticationStart());
      } else {
        await sharedPreferences.reload();

        final userJson = sharedPreferences.getString('userJson');
        if (userJson != null && userJson.isNotEmpty) {
          try {
            // final account = await UserBloc().getProfile();
            // // ignore: unnecessary_null_comparison
            // if (account == null) {
            //   Map<String, dynamic> json = convert.jsonDecode(userJson);
            //   final account = UserModel.fromJson(json);
            //   account.password =
            //       sharedPreferences.getString('last_userpassword') ?? '';
            //   emit(SetUserData(currentUser: account));
            // } else {
            //   final json = account.toJson();
            //   final jsonStr = convert.jsonEncode(json);
            //   sharedPreferences.setString('userJson', jsonStr);
            //   account.password =
            //       sharedPreferences.getString('last_userpassword') ?? '';
            //   emit(SetUserData(currentUser: account));
            // }
            return;
          } on Error catch (e) {
            emit(AuthenticationFailure(
              message: e.toString(),
              errorCode: '',
            ));
          }
        } else {
          // final account = await UserBloc().getProfile();
          // // ignore: unnecessary_null_comparison
          // if (account == null) {
          //   await _cleanupCache();
          //   emit(UserTokenExpired());
          // } else {
          //   final json = account.toJson();
          //   final jsonStr = convert.jsonEncode(json);
          //   sharedPreferences.setString('userJson', jsonStr);
          //   account.password =
          //       sharedPreferences.getString('last_userpassword') ?? '';
          //   emit(SetUserData(currentUser: account));
          // }
        }
      }
    });

    on<TokenExpired>((event, emit) async {
      await _cleanupCache();
      emit(UserTokenExpired());
    });

    on<GetLastUser>(
      (event, emit) async {
        final SharedPreferences sharedPreferences = await prefs;

        final username = sharedPreferences.getString('last_username') ?? '';
        final keepSession = sharedPreferences.getBool('keep_session') ?? false;
        final forgotPasswordEmail =
            sharedPreferences.getString('forgot_password_email') ?? '';
        emit(LoginLastUser(
          username: username,
          isKeepSession: keepSession,
          forgotPasswordEmail: forgotPasswordEmail,
        ));
      },
    );

    on<CheckOTPForgot>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final data = await authenticationService.checkOTPForgot(event.otp);
        if (data is ApiResponse<OtpModel>) {
          if (data.model != null) {
            sharedPreferences.setString('reset_id', data.model!.userId);
            emit(CheckOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(CheckOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<CheckOTPRegister>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final SharedPreferences sharedPreferences = await prefs;
        final data = await authenticationService.checkOTPRegister(event.otp);
        if (data is ApiResponse<OtpModel>) {
          if (data.model != null) {
            sharedPreferences.setString('reset_id', data.model!.userId);
            emit(CheckOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(CheckOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<ForgotPassword>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final data = await authenticationService.checkEmail(event.email);
        if (data is ApiResponse) {
          if (data.error == null) {
            emit(ForgotPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(ForgotPasswordDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });

    on<SendOTP>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final data = await authenticationService.forgotPassword(event.email);
        if (data is ApiResponse) {
          if (data.error == null) {
            emit(SendOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            ));
          }
        } else {
          if (data["error_message"] == null) {
            emit(SendOTPDoneState());
          } else {
            emit(AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            ));
          }
        }
      } on Error catch (e) {
        emit(AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        ));
      }
    });
  }

  _cleanupCache() async {
    final SharedPreferences sharedPreferences = await prefs;
    sharedPreferences.remove('authtoken');
    sharedPreferences.remove('userJson');
    sharedPreferences.remove('login_time');
    sharedPreferences.remove('last_lang');
  }
}
