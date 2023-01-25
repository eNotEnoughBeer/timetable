import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/feature/domain/entities/lesson_entity.dart';
import 'package:timetable/feature/presentation/bloc/lessons/lessons_cubit.dart';
import 'package:timetable/feature/presentation/widgets/avatar_small.dart';
import 'package:timetable/feature/presentation/widgets/error_snackbar.dart';
import 'package:timetable/navigation.dart';

class LessonDetailsScreen extends StatefulWidget {
  final LessonEntity data;
  const LessonDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  int selectedIndex = 0;
  final controllerName = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerTeacher = TextEditingController();
  final controllerGKey = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data.uid.isNotEmpty) {
      selectedIndex = widget.data.iconIndex;
    }
    controllerName.text = widget.data.name;
    controllerDescription.text = widget.data.description;
    controllerTeacher.text = widget.data.teacherName;
    controllerGKey.text = widget.data.googleKey;
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerDescription.dispose();
    controllerTeacher.dispose();
    controllerGKey.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () async {
              final resEnt = LessonEntity(
                  uid: widget.data.uid,
                  name: controllerName.text.trim(),
                  description: controllerDescription.text.trim(),
                  iconIndex: selectedIndex,
                  googleKey: controllerGKey.text.trim(),
                  teacherName: controllerTeacher.text.trim(),
                  teacherAvatar: '');

              // перевірка на порожні поля
              if (resEnt.name.isEmpty ||
                  resEnt.description.isEmpty ||
                  resEnt.googleKey.isEmpty ||
                  resEnt.teacherName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  errorSnackBar(
                    message: 'Не всі поля заповнено',
                    durationInSeconds: 1,
                  ),
                );
                return;
              }

              if (widget.data.uid.isEmpty) {
                context.read<LessonsCubit>().addLesson(resEnt).then((_) =>
                    context.read<LessonsCubit>().getLessons().then((value) =>
                        NavigationActions.instance.returnToPreviousPage()));
              } else {
                context.read<LessonsCubit>().updateLesson(resEnt).then(
                    (value) => context.read<LessonsCubit>().getLessons().then(
                        (value) =>
                            NavigationActions.instance.returnToPreviousPage()));
              }
            },
            icon:
                const Icon(FontAwesome.floppy, color: AppColors.darkTextColor),
          )
        ],
        backgroundColor: AppColors.bottomBackgroundColor,
        elevation: 0,
        title: Text(
          widget.data.uid.isEmpty ? 'Новий урок' : 'Редагування уроку',
          style: const TextStyle(
              color: AppColors.darkTextColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          splashRadius: 20,
          onPressed: NavigationActions.instance.returnToPreviousPage,
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.darkTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 10),
                    _textField(
                      controllerName,
                      FontAwesome.tag,
                      'Назва предмету',
                      'Введіть назву предмету',
                      1,
                    ),
                    _textField(
                      controllerDescription,
                      FontAwesome.list,
                      'Короткий опис',
                      'Введіть, що буде вивчатись',
                      2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _textField(controllerTeacher, FontAwesome.user,
                              'Вчитель', 'Введіть ПІБ вчителя', 1),
                        ),
                        const SmallAvatar(diameter: 45, borderSize: 2),
                      ],
                    ),
                    _textField(controllerGKey, FontAwesome.key, 'Google-код',
                        'Введіть код Google', 1),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: _lessonIcons(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _lessonIcons() {
    return List<Widget>.generate(22, (index) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: index == selectedIndex
                ? Border.all(
                    color: AppColors.accentColor,
                    width: 10,
                    strokeAlign: StrokeAlign.center)
                : null,
            color: lessonsBackground[index],
          ),
          width: 80,
          height: 80,
          child: SvgPicture.asset(
            'assets/svg/${index + 1}.svg',
            color: Colors.white,
          ),
        ),
      );
    });
  }

  Widget _textField(TextEditingController? controller, IconData icon,
      String labelText, String hintText, int maxLines) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(
              icon,
              color: AppColors.greyTextColor,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
            hintText: hintText,
            hintStyle:
                const TextStyle(color: AppColors.greyTextColor, fontSize: 14)),
      ),
    );
  }
}
