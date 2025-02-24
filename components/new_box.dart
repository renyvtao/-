import 'package:flutter/material.dart';
import 'package:flutter_music/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NewBox extends StatelessWidget {
  final Widget? child;

  const NewBox({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey.shade500,
            blurRadius: 15,
            offset: const Offset(4, 4),
          ),

          
          BoxShadow(
            color:  isDarkMode ? Colors.grey.shade800:Colors.white,
            blurRadius: 15,
            offset: const Offset(-4, -4),
          ),
        ]
        ),
        padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}