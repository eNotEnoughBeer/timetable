import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:timetable/feature/presentation/pages/calendar_page.dart';
import 'package:timetable/feature/presentation/pages/home_page.dart';
import 'package:timetable/feature/presentation/pages/teacher_menu_page.dart';
import 'package:timetable/feature/presentation/pages/user_details_page.dart';
import '../../../core/app_colors.dart';
import '../bloc/user_credentials/user_credentials_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;
  bool isTeacher = false;
  List<dynamic> pages = [
    const HomePage(),
    const CalendarPage(),
    null,
    const UserDetailsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCredentialsCubit, UserCredentialsState>(
      builder: (context, state) {
        if (state is Succeed) {
          final data = state.personData;
          if (data.role == 'teacher') {
            isTeacher = true;
            pages = [
              const HomePage(),
              const CalendarPage(),
              null,
              const TeacherMenuPage(),
              const UserDetailsPage(),
            ];
          }
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: pages[_selectedItemIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.lightTextColor,
            unselectedItemColor: AppColors.greyTextColor,
            selectedItemColor: AppColors.darkTextColor,
            selectedIconTheme:
                const IconThemeData(color: AppColors.darkTextColor),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedItemIndex,
            elevation: 0,
            onTap: (int index) {
              setState(() {
                _selectedItemIndex = index;
              });
            },
            items: isTeacher
                ? const [
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.home),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.tasks),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.book),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.calendar),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.cog_alt),
                      label: '',
                    ),
                  ]
                : const [
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.home),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.tasks),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.book),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesome.cog_alt),
                      label: '',
                    ),
                  ],
          ),
        );
      },
    );
  }
}
