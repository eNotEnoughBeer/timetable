import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:timetable/core/app_colors.dart';
import 'package:timetable/feature/presentation/bloc/auth/auth_cubit.dart';
import 'package:timetable/feature/presentation/widgets/error_snackbar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  static const animationDuration = Duration(milliseconds: 700);
  static const animationCurve = Curves.linear;
  bool isSignUpScreen = false;
  bool unHidePassword = false;
  bool preventFromClicking = false;

  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void authorize() {
    if (preventFromClicking) return;
    if (isSignUpScreen) {
      bool checkPassed = context.read<AuthCubit>().checkInput(
            true,
            email: controllerEmail.text,
            password: controllerPassword.text,
            name: controllerName.text,
          );
      if (checkPassed) {
        context.read<AuthCubit>().signUp(
              controllerEmail.text,
              controllerPassword.text,
              controllerName.text,
            );
      }
    } else {
      bool checkPassed = context.read<AuthCubit>().checkInput(
            true,
            email: controllerEmail.text,
            password: controllerPassword.text,
          );
      if (checkPassed) {
        context
            .read<AuthCubit>()
            .logIn(controllerEmail.text, controllerPassword.text);
      }
    }
  }

  void forgotPassword() {
    if (preventFromClicking) return;
    if (context
        .read<AuthCubit>()
        .checkInput(true, email: controllerEmail.text)) {
      context.read<AuthCubit>().forgotPassword(controllerEmail.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is UnAuthenticated) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(message: state.message!),
            );
          }
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.bottomBackgroundColor,
        body: Stack(
          children: [
            // задній план
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.backgroundImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 90, left: 20),
                  color: AppColors.topBackgroundColor.withOpacity(0.85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: isSignUpScreen ? 'Вітаємо у ' : 'З поверненням',
                          style: const TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: AppColors.accentColor,
                          ),
                          children: [
                            TextSpan(
                              text: isSignUpScreen ? 'eTimetable' : '',
                              style: const TextStyle(
                                fontSize: 25,
                                color: AppColors.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isSignUpScreen
                            ? 'Зареєструйтеся, щоб продовжити'
                            : 'Увійдіть, щоб продовжити',
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //головний контейнер для Login/SignUp
            _buildButtonBackground(),
            AnimatedPositioned(
              duration: animationDuration,
              top: isSignUpScreen ? 170 : 190,
              child: AnimatedContainer(
                duration: animationDuration,
                curve: animationCurve,
                padding: const EdgeInsets.all(20.0),
                height: isSignUpScreen ? 295 : 245,
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (preventFromClicking) return;
                              setState(() {
                                isSignUpScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'ВХІД',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSignUpScreen
                                        ? AppColors.greyTextColor
                                        : AppColors.buttonColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Visibility(
                                  visible: !isSignUpScreen,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 3,
                                    width: 55,
                                    color: AppColors.accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (preventFromClicking) return;
                              setState(() {
                                isSignUpScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'РЕЄСТРАЦІЯ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSignUpScreen
                                        ? AppColors.buttonColor
                                        : AppColors.greyTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Visibility(
                                  visible: isSignUpScreen,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 3,
                                    width: 125,
                                    color: AppColors.accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Visibility(
                              visible: isSignUpScreen,
                              child: _textField(
                                  controllerName,
                                  FontAwesome.user,
                                  'Ім\'я користувача',
                                  false,
                                  false),
                            ),
                            _textField(controllerEmail, FontAwesome.mail,
                                'e-mail', false, true),
                            _textField(controllerPassword, FontAwesome.lock,
                                'Пароль', true, false),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: isSignUpScreen ? 10.0 : 0.0, left: 10.0),
                              child: Row(
                                children: isSignUpScreen
                                    ? <Widget>[]
                                    : <Widget>[
                                        Expanded(child: Container()),
                                        TextButton(
                                          onPressed: forgotPassword,
                                          child: const Text(
                                            'Забув пароль?',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.buttonColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //кругла кнопка зі стрілочкою
            AnimatedPositioned(
              duration: animationDuration,
              curve: animationCurve,
              top: isSignUpScreen ? 420 : 390,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentColor,
                          AppColors.googleColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    // у залежності від поточного state, тут або іконка, або scroll
                    child: state is InProgress
                        ? const Center(
                            child: SizedBox(
                              width: 35,
                              height: 35,
                              child: CircularProgressIndicator(
                                backgroundColor: AppColors.greyTextColor,
                                color: AppColors.accentColor,
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: authorize,
                            icon: const Icon(
                              FontAwesome.forward,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonBackground() {
    return AnimatedPositioned(
      duration: animationDuration,
      curve: animationCurve,
      top: isSignUpScreen ? 420 : 390,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController? controller, IconData icon,
      String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        readOnly: preventFromClicking,
        controller: controller,
        obscureText: isPassword ? !unHidePassword : false,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: AppColors.greyTextColor,
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onLongPressStart: (_) {
                      if (preventFromClicking) return;
                      setState(() {
                        unHidePassword = true;
                      });
                    },
                    onLongPressEnd: (_) {
                      if (preventFromClicking) return;
                      setState(() {
                        unHidePassword = false;
                      });
                    },
                    child: const Icon(FontAwesome.eye_off,
                        color: AppColors.greyTextColor))
                : null,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.greyTextColor),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.greyTextColor),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            contentPadding: const EdgeInsets.all(10),
            hintText: hintText,
            hintStyle:
                const TextStyle(color: AppColors.greyTextColor, fontSize: 14)),
      ),
    );
  }
}
