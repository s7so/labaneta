import 'package:flutter/material.dart';
import 'package:labaneta_sweet/utils/constants.dart';

class PromotionalBanner extends StatefulWidget {
  final List<Map<String, String>> promotions;

  const PromotionalBanner({Key? key, required this.promotions}) : super(key: key);

  @override
  _PromotionalBannerState createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _autoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_currentPage < widget.promotions.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _animationController.reset();
      _animationController.forward();
      _autoScroll();
    });
  }

  void _handlePromotionAction(String action) {
    // TODO: Implement actions for each promotion
    switch (action) {
      case 'cakes':
        print('Navigate to cakes category');
        break;
      case 'cupcakes':
        print('Navigate to cupcakes category');
        break;
      case 'delivery':
        print('Show delivery information');
        break;
      case 'specials':
        print('Navigate to special offers');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.promotions.length,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Constants.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.promotions[index]['text']!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _handlePromotionAction(widget.promotions[index]['action']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('اكتشف المزيد'),
                  ),
                ],
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          _animationController.reset();
          _animationController.forward();
        },
      ),
    );
  }
}