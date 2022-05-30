import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:lesson43_practice/models/models.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    UserModel userModel;
    on<UserEvent>((event, emit) async {
      if (event is GetUserEvent) {
        emit(UserLoadingState());
        try {
          print('11111');
          var url = Uri.parse("https://randomuser.me/api/");
          var responce = await get(url);
          print('2222222');
          if (responce.statusCode == 200) {
            UserModel userModel = UserModel.fromRawJson(responce.body);
            emit(UserInfoState(userModel: userModel));
          } else {
            emit(UserErrorState(error: "Ошибка системы"));
          }
        } on SocketException catch (e) {
          print(e);
          emit(UserErrorState(error: 'Нет интернет соединения'));
        } catch (e) {
          print('e ==== $e');
          emit(UserErrorState(error: e.toString()));
        }
      }
    });
  }
}
