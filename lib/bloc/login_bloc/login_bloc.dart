import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sales_force/database/tables/categories_table.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/models/objects/user.dart';
import 'package:sales_force/repositories/login_repository.dart';
import 'package:sales_force/shared/config.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    try {
      if (event is LoginGetLastLogin) {
        Config.user = await LoginRepo.repo.getLastLogin();
        if (Config.user != null) {
          yield SavedUser(email: Config.user.email);
        } else {
          Config.user = User();
          yield NewUser();
        }
      } else if (event is LoginEmailChanged) {
        if (event.email == '') {
          yield InvalidEmail(message: 'Enter email');
        } else {
          Config.user.email = event.email;
        }
      } else if (event is LoginPasswordChanged) {
        if (event.password == '') {
          yield InvalidPassword(message: 'Enter password');
        } else {
          Config.user.password = event.password;
        }
      } else if (event is LoginSubmit) {
        if (event.forceLogin) {
          yield LoginSuccessful(message: 'Login successful');
        } else if (Config.user.email == '' || Config.user.password == '') {
          yield InvalidSubmission(message: 'Please check email and password');
        } else {
          User user = await LoginRepo.repo
              .login(Config.user.email, Config.user.password);
          Config.user = user;
          if (user != null) {
            (await Config.database)
                .update(TableCustomer.tableName, {TableCustomer.userId: 1});
            (await Config.database)
                .update(TableProducts.tableName, {TableProducts.userId: 1});
            (await Config.database)
                .update(TableCategories.tableName, {TableCategories.userId: 1});
            yield LoginSuccessful(message: 'Login successful');
          } else {
            yield LoginFailed(message: 'Invalid username or password');
          }
        }
      } else if (event is LoginEventLogout) {
        await LoginRepo.repo.logout();
        yield NewUser();
      }
    } catch (e) {
      yield LoginError(message: e.toString());
    }
  }
}
