
import 'package:flutter/material.dart';

class Palette { 
  static const MaterialColor kToDark = const MaterialColor( 
    0xff485fc7, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
    const <int, Color>{ 
      50: const Color(0xff4156b3 ),//10% 
      100: const Color(0xff3a4c9f),//20% 
      200: const Color(0xff32438b),//30% 
      300: const Color(0xff2b3977),//40% 
      400: const Color(0xff243064),//50% 
      500: const Color(0xff1d2650),//60% 
      600: const Color(0xff161c3c),//70% 
      700: const Color(0xff0e1328),//80% 
      800: const Color(0xff070914),//90% 
      900: const Color(0xff000000),//100% 
    }, 
  ); 
} // you can define define int 500 as the default shade and add your lighter tints above and darker tints below. 
