import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/core/platform/cache_folder_path.dart';
import 'package:timetable/feature/presentation/bloc/auth/auth_cubit.dart';
import 'package:timetable/feature/presentation/bloc/user_credentials/user_credentials_cubit.dart';
import '../widgets/error_snackbar.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String picturePath = '';
  String avatarURL = '';
  String userRole = '';
  bool unHidePassword = false;
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  void savePressed() {
    String picturePathUpload = '';
    picturePathUpload = '$temDirPath/avatar_new.jpg';
    if (File(picturePathUpload).existsSync()) {
      File(picturePathUpload).rename('$temDirPath/avatar.jpg');
      picturePathUpload = '$temDirPath/avatar.jpg';
    } else {
      picturePathUpload = avatarURL;
    }
    if (picturePath.isNotEmpty) {
      picturePath = '$temDirPath/avatar.jpg';
    }
    // зберегти всі зміни до Firebase та зробити локальну копію
    bool checkPassed = context.read<AuthCubit>().checkInput(
          false,
          email: controllerEmail.text,
          name: controllerName.text,
          password: controllerPassword.text,
        );
    if (checkPassed) {
      context.read<UserCredentialsCubit>().updateUserData(
            controllerName.text,
            controllerEmail.text,
            controllerPassword.text,
            picturePathUpload,
            userRole,
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(message: 'Не всі поля заповнено'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (context.read<UserCredentialsCubit>().state is Succeed) {
      final data =
          (context.read<UserCredentialsCubit>().state as Succeed).personData;
      controllerName.text = data.name;
      controllerEmail.text = data.email;
      controllerPassword.text =
          context.read<UserCredentialsCubit>().getUserPassword;
      if (data.avatar.isNotEmpty) {
        picturePath = '$temDirPath/avatar.jpg';
        avatarURL = data.avatar;
      }
      userRole = data.role;
    }
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCredentialsCubit, UserCredentialsState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is Failed) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar(message: state.message!),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is Succeed) {
            return _bodyWidget(context);
          } else {
            return _loadingWidget(context);
          }
        });
  }

  Widget _loadingWidget(context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.topBackgroundColor.withOpacity(0.3),
                AppColors.lightTextColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.8],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(FontAwesome.logout, color: AppColors.darkTextColor),
                  SizedBox(width: 3),
                  Text(
                    'Вийти',
                    style: TextStyle(
                      color: AppColors.darkTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(FontAwesome.floppy, color: AppColors.darkTextColor),
            ],
          ),
        ),
        Positioned(
          top: 100,
          child: Container(
            height: MediaQuery.of(context).size.height - 160,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade200,
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        color: AppColors.loadingWidgetColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.loadingWidgetColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.loadingWidgetColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.loadingWidgetColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bodyWidget(BuildContext context) {
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.topBackgroundColor.withOpacity(0.3),
                AppColors.lightTextColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.2, 0.4],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(children: [_appBarForPage(context)]),
        ),
        Positioned(
          top: 100,
          child: Container(
            height: viewInsets.bottom == 0
                ? MediaQuery.of(context).size.height - 160
                : MediaQuery.of(context).size.height -
                    100 -
                    viewInsets.bottom, // минус высота клавы
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.lightTextColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        /* physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,*/
                        children: [
                          const SizedBox(height: 25),
                          _profileImage(),
                          const SizedBox(height: 40),
                          _textField(
                              controllerName,
                              FontAwesome.user,
                              'Ім\'я користувача',
                              'Введіть iм\'я користувача',
                              false,
                              false),
                          _textField(controllerEmail, FontAwesome.mail,
                              'e-mail', 'Введіть e-mail', false, true),
                          _textField(controllerPassword, FontAwesome.lock,
                              'Пароль', 'Введіть пароль', true, false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textField(TextEditingController? controller, IconData icon,
      String labelText, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !unHidePassword : false,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(
              icon,
              color: AppColors.greyTextColor,
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onLongPressStart: (_) {
                      setState(() {
                        unHidePassword = true;
                      });
                    },
                    onLongPressEnd: (_) {
                      setState(() {
                        unHidePassword = false;
                      });
                    },
                    child: const Icon(FontAwesome.eye_off,
                        color: AppColors.greyTextColor))
                : null,
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

  Widget _profileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(1, 3),
                ),
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: (picturePath.isNotEmpty)
                    ? FileImage(File(picturePath)) as ImageProvider
                    : const AssetImage('assets/images/avatar.jpg'),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                    context: context, builder: ((builder) => _bottomSheet()));
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.white),
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      height: 120,
      width: double.infinity,
      color: AppColors.bottomBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            const Text('Взяти аватарку з...', style: TextStyle(fontSize: 25)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    picturePath = await _getImage(ImageSource.camera);
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.greyTextColor,
                    minimumSize: const Size(155.0, 40.0),
                  ),
                  child: Row(
                    children: const [
                      Icon(FontAwesome.camera),
                      SizedBox(width: 5),
                      Text('Камера', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    picturePath = await _getImage(ImageSource.gallery);
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.greyTextColor,
                    minimumSize: const Size(155.0, 40.0),
                  ),
                  child: Row(
                    children: const [
                      Icon(FontAwesome.file_image),
                      SizedBox(width: 5),
                      Text('Галерея', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: source, maxHeight: 400, imageQuality: 80);
    if (image != null) {
      final result = await image.readAsBytes();

      final imagePath = await File('$temDirPath/avatar_new.jpg').create();
      imagePath.writeAsBytesSync(result);
      return imagePath.path;
    }
    return picturePath;
  }

  Widget _appBarForPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: context.read<AuthCubit>().logOut,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(FontAwesome.logout, color: AppColors.darkTextColor),
              SizedBox(width: 3),
              Text(
                'Вийти',
                style: TextStyle(
                  color: AppColors.darkTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: savePressed,
          child: const Icon(FontAwesome.floppy, color: AppColors.darkTextColor),
        ),
      ],
    );
  }
}
