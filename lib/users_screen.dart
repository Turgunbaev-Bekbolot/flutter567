import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lesson43_practice/Location_info.dart';
import 'package:lesson43_practice/bloc/user_bloc.dart';
import 'package:lesson43_practice/email_info.dart';
import 'package:lesson43_practice/models/models.dart';
import 'package:lesson43_practice/main_info.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late UserBloc userBloc;
  late UserModel userModel;
  @override
  void initState() {
    userBloc = UserBloc();
    userBloc.add(GetUserEvent());
    super.initState();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 60),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: BlocConsumer<UserBloc, UserState>(
              bloc: userBloc,
              listener: (context, state) {
                if (state is UserErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                if (state is UserErrorState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              userBloc.add(GetUserEvent());
                            },
                            child: Text('Try again')),
                      ),
                    ],
                  );
                }
                if (state is UserLoadingState) {
                  return Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                  ));
                }
                if (state is UserInfoState) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.network(
                            state.userModel!.results.first.picture.large),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          state.userModel!.results.first.name.first,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TabBar(indicatorColor: Colors.pink, tabs: [
                        Tab(
                          child: Text(
                            'Main Info',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Location',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Email',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ]),
                      // UserInformation(userModel: state.userModel!),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: TabBarView(
                          children: [
                            MainInfo(userModel: state.userModel!),
                            LocationInfo(
                              userModel: state.userModel!,
                            ),
                            EmailInfo(userModel: state.userModel!)
                          ],
                        ),
                      ),

                      ElevatedButton(
                          onPressed: () {
                            userBloc.add(GetUserEvent());
                          },
                          child: Text(
                            'Поиск',
                          )),
                    ],
                  );
                }
                return SizedBox();
              }),
        ),
      ),
    );
  }
}
