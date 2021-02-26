import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FlutterFoodBottomNavigator extends StatelessWidget {
  int _active_item = 0;

  FlutterFoodBottomNavigator(this._active_item);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).backgroundColor,
      height: 45,
      index: _active_item,
      items: <Widget>[
        Icon(Icons.home),
        Icon(Icons.list),
        Icon(Icons.shopping_cart),
        Icon(Icons.supervised_user_circle)
      ],
      /* adicionamos onTap para saber exatamente onde o usuario clicou */
      onTap: (index) {
        switch (index) {
          case 2:
            /* Usamo pushReplacementNamed no lugar do push para evitar empilhar um screen sobre outra */
            Navigator.pushReplacementNamed(context, "/cart");
            break;
          default:
            Navigator.pushReplacementNamed(context, "/restaurants");
        }
      },
    );
  }
}