import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:provider/provider.dart';

import '../../widgets/flutter_bottom_navigator.dart';
import '../../widgets/show_image_cached_network.dart';
import '../../models/Food.dart';
import '../../stores/foods.store.dart';
import '../../stores/restaurant.store.dart';

class CartScreen extends StatelessWidget {
  FoodsStore _foodsStore;
  RestaurantsStore _restaurantsStore;

  /* Aqui nó vamos construir nosso carrinho */
  @override
  Widget build(BuildContext context) {
    _foodsStore = Provider.of<FoodsStore>(context);
    /* Aqui ja temos todos os dados do restaurants que preciso */
    _restaurantsStore = Provider.of<RestaurantsStore>(context);

    final String titlePage = _restaurantsStore.restaurant != null
        ? "Carrinho - ${_restaurantsStore.restaurant.name}"
        : 'Carrinho';

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(titlePage),
        centerTitle: true,
      ),
      body: _bodyContentCart(context),
      bottomNavigationBar: FlutterFoodBottomNavigator(2),
    );
  }

  Widget _bodyContentCart(context) {
    return ListView(
      children: <Widget>[
        _buildHeader(),
        _buildCartList(context),
        _buildTextTotalCart(),
        _buildFormComment(context),
        _buttonCheckout(context),
      ],
    );
  }

  Widget _buildHeader() {
    /* Adicionamos um Observer para ficar monitorando as alterações */
    return Observer(
      builder: (context) => Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(16),
        child: Text("Total (${_foodsStore.cartItems.length})",
            style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildCartList(context) {
    return Observer(
      builder: (context) => ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: _foodsStore.cartItems.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> itemCart = _foodsStore.cartItems[index];
          return _buildCartItem(itemCart, context);
        },
      ),
    );
  }

  /* Aqui construimos os items  da lista */
  Widget _buildCartItem(Map<String, dynamic> itemCart, context) {
    final Food food = itemCart['product'];

    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          height: 80,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey[200]),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Container(
            padding: EdgeInsets.all(2),
            child: Row(
              children: <Widget>[
                ShowImageCachedNetwork(food.image != null
                    ? food.image
                    : 'https://florinafood.gr/imgs/logos/fresh.png'),
                _showDetailItemCart(food, itemCart, context),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => _foodsStore.removeFoodCart(food),
            child: Container(
              height: 24,
              width: 24,
              margin: EdgeInsets.only(top: 2, right: 4),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _showDetailItemCart(
      Food food, Map<String, dynamic> itemCart, context) {
    return Expanded(
        child: Container(
            padding: EdgeInsets.only(top: 4, right: 4, left: 4),
            child: Column(
                /* jogando para o inicio ao lado da imagem */
                crossAxisAlignment: CrossAxisAlignment.start,
                /* alinhar verticalmente ao centro */
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    food.title,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                  ),
                  Container(height: 6),
                  Container(
                      //color: Colors.black,

                      child: Row(
                          /* alinhar verticalmente ao espaço entre */
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        Text(
                          "R\$ ${food.price}",
                          style: TextStyle(color: Colors.green),
                        ),
                        Container(height: 6),
                        Container(
                          child: Row(children: <Widget>[
                            GestureDetector(
                              onTap: () => _foodsStore.decrementFoodCart(food),
                              child: Icon(Icons.remove,
                                  size: 24, color: Colors.grey.shade700),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 4, bottom: 4, left: 12, right: 12),
                              color: Theme.of(context).primaryColor,
                              child: Text(itemCart['qty'].toString(),
                                  style: TextStyle(color: Colors.white)),
                            ),
                            GestureDetector(
                              onTap: () => _foodsStore.incrementFoodCart(food),
                              child: Icon(Icons.add,
                                  size: 24, color: Colors.grey.shade700),
                            ),
                          ]),
                        )
                      ]))
                ])));
  }

  /* Método para fazer a somatória */
  Widget _buildTextTotalCart() {
    return Observer(
      builder: (context) => Container(
        //margin: EdgeInsets.only(left: 10, right: 10, top: 26, bottom: 16),
        margin: EdgeInsets.all(10),
        child: Text(
          "(${_foodsStore.cartItems.length}) Total: ${_foodsStore.totalCart} ",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFormComment(context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        autocorrect: true,
        style: TextStyle(color: Theme.of(context).primaryColor),
        cursorColor: Theme.of(context).primaryColor,
        onSaved: (value) {
          //print(value);
        },
        decoration: InputDecoration(
            labelText: 'Comentário (ex: sem cebola)',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            )),
      ),
    );
  }

  Widget _buttonCheckout(context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 50, right: 10, left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.orange[800],
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 6,
            )
          ]),
      child: RaisedButton(
        onPressed: () {
          //print("checkout");
        },
        child: Text("Finaliza pedido"),
        color: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
