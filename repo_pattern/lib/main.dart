import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repo_pattern/bloc/user_bloc.dart';
import 'package:repo_pattern/bloc/user_event.dart';
import 'package:repo_pattern/bloc/user_state.dart';
import 'package:repo_pattern/data/model/user_model.dart';
import 'package:repo_pattern/data/provider/user_provider.dart';
import 'package:repo_pattern/data/repository/user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: RepositoryProvider(
            //we are using repository provider here because we are using the repository pattern and we want to provide the repository to the bloc
            create: (context) => UserRepository(UserProvider()),
            child: BlocProvider(
                create: (context) => UserBloc(context.read<UserRepository>()),
                child: const MyHomePage())));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repository Provider"),
      ),
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is UserLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UserErrorState) {
          return Center(child: Text(state.error));
        }
        if (state is UserSuccessState) {
          List<Datum> userList = state.userModel.data;

          return userList.isNotEmpty
              ? ListView.builder(
                itemCount: userList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Card(
                      child: ListTile(
                        title: Text(userList[index].firstName),
                        subtitle: Text(userList[index].email),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userList[index].avatar.toString()),
                        ),
                      ),
                    ),
                  ),
                )
              : const Center(child: Text("No Users found"));
        }

        return const Center(child: Text("Press the button to load users"));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserBloc>().add(LoadUserEvent());
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.api_outlined),
      ),
    );
  }
}
