import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // Skip Button
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text("Skip"),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _controller,

                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },

                children: const [

                  OnboardingPage(
                    icon: Icons.account_balance_wallet,
                    title: "Track Every Expense",
                    subtitle:
                        "Record your daily income and expenses with ease.",
                  ),

                  OnboardingPage(
                    icon: Icons.savings,
                    title: "Manage Your Budget",
                    subtitle:
                        "Plan your monthly budget and stay financially healthy.",
                  ),

                  OnboardingPage(
                    icon: Icons.show_chart,
                    title: "Grow Your Savings",
                    subtitle:
                        "Analyze reports and build better financial habits.",
                  ),
                ],
              ),
            ),

            // Bottom Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 25,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colors.green,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {

                      if (isLastPage) {

                        // TODO : Login Screen

                      } else {

                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );

                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),

                    child: Text(
                      isLastPage ? "Get Started" : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}