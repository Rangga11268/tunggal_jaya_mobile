import 'package:flutter/material.dart';

class TjBackground extends StatelessWidget {
  final Widget child;
  
  const TjBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(color: const Color(0xFFFCF9F8)),
        
        // Geometric Footer Pattern (TJ Colors)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 120,
            child: Stack(
              children: [
                // Red/Orange accent circle
                Positioned(
                  bottom: -20, left: -20,
                  child: Container(width: 140, height: 140, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE63946))), // Accent red
                ),
                // Dark Blue box
                Positioned(
                  bottom: 20, right: 40,
                  child: Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color(0xFF10207A), borderRadius: BorderRadius.circular(20))),
                ),
                // Gold/Yellow circle
                Positioned(
                  bottom: -30, right: -10,
                  child: Container(width: 100, height: 100, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF4A261))), // Accent Gold
                ),
                // Dark blue curved block
                Positioned(
                  bottom: 0, left: 80,
                  child: Container(width: 150, height: 60, decoration: const BoxDecoration(color: Color(0xFF10207A), borderRadius: BorderRadius.vertical(top: Radius.circular(60)))),
                ),
                // Small white dot
                Positioned(
                  bottom: 40, left: 160,
                  child: Container(width: 40, height: 40, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        
        // The actual page content goes on top
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
