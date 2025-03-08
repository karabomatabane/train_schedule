import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Image.asset(
          'assets/images/train.png',
          height: 40.0,
          color: Theme.of(context).colorScheme.secondary,
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56.0);
}
