import 'package:chitchat/Pages/auth/widgets/loginForm.dart';
import 'package:chitchat/Pages/auth/widgets/signUp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AuthPageBody extends StatelessWidget {
  const AuthPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool islogin = true.obs;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            islogin.value = true;
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width / 2.5,
                            child: Column(
                              children: [
                                Text(
                                  "Login",
                                  style: islogin.value
                                      ? Theme.of(context).textTheme.bodyLarge
                                      : Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(height: 5),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: islogin.value ? 100 : 0,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            islogin.value = false;
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width / 2.7,
                            child: Column(
                              children: [
                                Text(
                                  "SignUp",
                                  style: islogin.value
                                      ? Theme.of(context).textTheme.labelLarge
                                      : Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 5),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: islogin.value ? 0 : 100,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Obx(() => islogin.value
                    ? const LoginPage()
                    : const SignUp())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
