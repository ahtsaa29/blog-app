import 'dart:developer';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    if (state is! AuthInitial) {
      on<AuthEvent>((_, emit) => emit(AuthLoading()));
    }
    on<AuthSignUp>(_onAuthSignup);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _onAuthSignup(AuthSignUp event, Emitter<AuthState> emit) async {
    (event, emit) async {
      final response = await _userSignUp(
        UserSignUpParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );
      log("Response : $response");
      response.fold(
        (l) => emit(AuthFailure(l.message)),
        (user) => _emitAuthSuccess(user, emit),
      );
    };
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    (event, emit) async {
      final response = await _userSignIn(
        UserLoginParams(email: event.email, password: event.password),
      );
      response.fold(
        (l) => emit(AuthFailure(l.message)),
        (user) => _emitAuthSuccess(user, emit),
      );
    };
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _currentUser(NoParams());
    result.fold((l) => AuthFailure(l.message), (r) => emit(AuthSuccess(r)));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
