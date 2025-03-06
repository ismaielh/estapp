import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var medaiQuery = MediaQuery.of(context).size;
    return Material(
      child: SizedBox(
        width: medaiQuery.width,
        height: medaiQuery.height,
        child: Stack(
          children: [
            Container(
              width: medaiQuery.width,
              height: medaiQuery.height / 1.6,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              width: medaiQuery.width,
              height: medaiQuery.height / 1.6,
              decoration: const BoxDecoration(
                  color: Color(0xff674AEF),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(70))),
              child: Center(
                child: Image.asset(
                  "assets/images/books.png",
                  scale: 0.8,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: medaiQuery.width,
                height: medaiQuery.height / 2.6,
                decoration: const BoxDecoration(
                  color: Color(0xff674AEF),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: medaiQuery.width,
                height: medaiQuery.height / 2.590,
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(70))),
                child: Column(
                  children: [
                    const Text(
                      "Learning is Everything",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Learning with Pleasure with Dear Programmer, Wherever you are",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Material(
                      color: const Color(0xff674AEF),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}