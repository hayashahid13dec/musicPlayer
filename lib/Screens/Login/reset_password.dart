import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/gradient_containers.dart';
import 'package:blackhole/Helpers/backup_restore.dart';
import 'package:blackhole/Helpers/config.dart';
import 'package:blackhole/Helpers/supabase.dart';
import 'package:blackhole/model/reset_password_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen();

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;
  bool iscObscure = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 1.85,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage(
                      'assets/icon-white-trans.png',
                    ),
                  ),
                ),
              ),
              const GradientContainer(
                child: null,
                opacity: true,
              ),
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    text: 'Reset Password',
                                    style: TextStyle(
                                      height: 0.97,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    // children: <TextSpan>[
                                    //   const TextSpan(
                                    //     text: 'Music',
                                    //     style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 80,
                                    //       color: Colors.white,
                                    //     ),
                                    //   ),
                                    //   TextSpan(
                                    //     text: '.',
                                    //     style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 80,
                                    //       color: Theme.of(context)
                                    //           .colorScheme
                                    //           .secondary,
                                    //     ),
                                    //   ),
                                    // ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 10,
                                      right: 10,
                                    ),
                                    margin: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[900],
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: passwordController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      obscureText: isObscure,
                                      keyboardType: TextInputType.name,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isObscure = !isObscure;
                                            });
                                          },
                                          child: Icon(
                                            isObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Enter New Password',
                                        hintStyle: const TextStyle(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter valid password';
                                        } else if (value.length < 8) {
                                          return 'Paswword must be 8 digit';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      left: 10,
                                      right: 10,
                                    ),
                                    // height: 57.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[900],
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 3.0),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: confirmController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      obscureText: iscObscure,
                                      keyboardType: TextInputType.name,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 1.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              iscObscure = !iscObscure;
                                            });
                                          },
                                          child: Icon(
                                            iscObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Enter Confirm Password',
                                        hintStyle: const TextStyle(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter valid password';
                                        } else if (value !=
                                            passwordController.text) {
                                          return 'Password does not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (errorMessage != null)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          errorMessage!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (isLoading)
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  else
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          errorMessage = null;
                                          isLoading = true;
                                        });

                                        final bool valid =
                                            formKey.currentState!.validate();
                                        if (valid) {
                                          if (passwordController.text ==
                                              confirmController.text) {
                                            ResetPasswordResponse?
                                                resetPasswordResponse =
                                                await YogitunesAPI()
                                                    .resetPassword(
                                              passwordController.text,
                                            );

                                            if (resetPasswordResponse != null) {
                                              if (resetPasswordResponse
                                                  .status!) {
                                                var box = await Hive.openBox(
                                                    'api-token');
                                                box.put('token', null);
                                                Navigator.popAndPushNamed(
                                                    context, '/login');
                                              } else {
                                                errorMessage =
                                                    resetPasswordResponse.data
                                                        .toString();
                                              }
                                            } else {
                                              errorMessage = 'Server Down!!!';
                                            }
                                          } else {
                                            errorMessage =
                                                'Confirm password is not matched';
                                          }
                                        }

                                        // Navigator.popAndPushNamed(
                                        //     context, '/resetPassword');
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        height: 55.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 5.0,
                                              offset: Offset(0.0, 3.0),
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: const Text(
                                            'Reset Password',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .disclaimer,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .disclaimerText,
                                          style: TextStyle(
                                            color: Colors.grey.withOpacity(0.7),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}