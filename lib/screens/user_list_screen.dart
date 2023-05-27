import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';


class UserListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: Text('User List'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is UserLoadedState) {
          final users = state.users;
          return Scaffold(
            appBar: AppBar(
              title: Text('User List'),
            ),
            body: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            ),
          );
        } else if (state is UserErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: Text('User List'),
            ),
            body: Center(
              child: Text(state.errorMessage),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
