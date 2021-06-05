import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/item_menu_bloc/item_menu_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/models/objects/category.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/constants.dart';
import 'package:sales_force/shared/widgets/thumbnail_listTile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ItemsMenuPage extends StatelessWidget {
  final List<dynamic> arguments;
  ItemsMenuPage({this.arguments});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerboseBloc, VerboseState>(
      listenWhen: (previous, current) => current is VerboseSnackBarState,
      listener: (context, state) {
        AppTheme.snackbar(context, state.message);
      },
      child: BlocListener<ItemMenuBloc, ItemMenuState>(
        listener: (context, state) {
          if (state is ValidSubmission) {
            state.customerOrder.customer = arguments[1];
            Navigator.of(context)
                .pushNamed('/orderPayment', arguments: state.customerOrder);
          } else if (state is InvalidSubmission) {
            AppTheme.snackbar(context, state.message);
          } else if (state is ItemMenuErrorState) {
            AppTheme.snackbar(context, state.message, error: true);
          }
        },
        child: BlocBuilder<ItemMenuBloc, ItemMenuState>(
          buildWhen: (previous, current) {
            if (current is LoadItemMenuState || current is SearchItemState) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is LoadItemMenuState) {
              return ItemsTabsView(
                paymentType: arguments[0],
              );
            } else {
              return ItemsSearchView();
            }
          },
        ),
      ),
    );
  }

  void passEvent(BuildContext context, ItemMenuEvent event) =>
      context.read<ItemMenuBloc>().add(event);
}

class ItemsSearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemMenuBloc, ItemMenuState>(
      buildWhen: (previous, current) => current is SearchItemState,
      builder: (context, state) {
        if (state is SearchItemState) {
          return WillPopScope(
            onWillPop: () async {
              passEvent(context, CancelSearchPressed());
              return false;
            },
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: TextField(
                    onChanged: (value) =>
                        passEvent(context, ItemNameChanged(name: value)),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: "Search Items Here",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                  actions: <Widget>[
                    BlocBuilder<ItemMenuBloc, ItemMenuState>(
                      buildWhen: (previous, current) =>
                          current is SearchItemState,
                      builder: (context, state) {
                        if (state is SearchItemState) {
                          return IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () =>
                                passEvent(context, CancelSearchPressed()),
                          );
                        }
                      },
                    ),
                  ],
                ),
                body: productsListView(state.products)),
          );
        } else {
          return Container(
            child: AppTheme.progIndicator,
          );
        }
      },
    );
  }

  void passEvent(BuildContext context, ItemMenuEvent event) =>
      context.read<ItemMenuBloc>().add(event);

  Widget productsListView(List<Product> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            CustomListItem(
              thumbnail: GestureDetector(
                  child: AppTheme.loadNetworkImage(
                      url: list[index].getNetworkImage(),
                      height: MediaQuery.of(context).size.height * 0.2,
                      boxFit: BoxFit.fill),
                  onTap: () => passEvent(
                      context, ItemAddEvent(productId: list[index].productId))),
              title: list[index].title.toUpperCase(),
              secondLine: 'RS: ${list[index].price}',
            ),
            Divider(),
          ],
        );
      },
    );
  }
}

class ItemsTabsView extends StatelessWidget {
  final PAYMENTMODE paymentType;
  ItemsTabsView({this.paymentType});
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return BlocBuilder<ItemMenuBloc, ItemMenuState>(
      buildWhen: (previous, current) => current is LoadItemMenuState,
      builder: (context, state) {
        if (state is LoadItemMenuState) {
          List<Tab> tabs = state.categories
              .map((e) => Tab(
                    text: e.title,
                  ))
              .toList();
          List<Category> categories = state.categories;
          List<Product> products = state.products;
          TabBarView tabBarView = TabBarView(
              children: tabs
                  .map((Tab tab) => productsListView(
                      categories
                          .where((c) => c.title == tab.text)
                          .first
                          .categoryId,
                      products,
                      false))
                  .toList());
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text(
                  'ITEMS (${paymentType.toString().split('.').last})',
                  style: TextStyle(fontSize: 16),
                ),
                actions: <Widget>[
                  BlocBuilder<ItemMenuBloc, ItemMenuState>(
                    buildWhen: (previous, current) {
                      if (current is AllMenuState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      if (state is SearchItemState) {
                        return IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () =>
                              passEvent(context, CancelSearchPressed()),
                        );
                      } else {
                        return IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => passEvent(context, SearchPressed()),
                        );
                      }
                    },
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: tabs,
                ),
              ),
              body: SlidingUpPanel(
                minHeight: 60,
                maxHeight: 500,
                border: Border(top: BorderSide(color: Colors.blue)),
                panel: slideUpPanelPanel(state),
                collapsed: slideUpPanelCollapsed(state),
                body: Container(
                  color: Colors.grey[50],
                  margin: EdgeInsets.only(bottom: 170),
                  child: BlocBuilder<ItemMenuBloc, ItemMenuState>(
                    buildWhen: (previous, current) {
                      if (current is SearchItemState ||
                          current is AllMenuState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      if (state is SearchItemState) {
                        return productsListView('', state.products, true);
                      } else {
                        return tabBarView;
                      }
                    },
                  ),
                ),
                onPanelClosed: () => passEvent(context, PanelCollasped()),
              ),
            ),
          );
        } else {
          return Container(
            child: AppTheme.progIndicator,
          );
        }
      },
    );
  }

  void passEvent(BuildContext context, ItemMenuEvent event) =>
      context.read<ItemMenuBloc>().add(event);

  Widget productsListView(
      String categoryId, List<Product> products, bool search) {
    List<Product> list;
    if (search) {
      list = products;
    } else {
      list = products.where((p) => p.categoryId == categoryId).toList();
    }
    if (list.length == 0) {
      return Container();
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => passEvent(
                  context,
                  ItemAddEvent(
                    productId: list[index].productId,
                  ),
                ),
                child: CustomListItem(
                  thumbnail: AppTheme.loadNetworkImage(
                      url: list[index].getNetworkImage(),
                      height: MediaQuery.of(context).size.height * 0.2,
                      boxFit: BoxFit.fill),
                  title: list[index].title.toUpperCase(),
                  secondLine: 'RS: ${list[index].price}',
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget slideUpPanelCollapsed(ItemMenuState state) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue[600]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<ItemMenuBloc, ItemMenuState>(
                builder: (context, state) {
                  return AppTheme.text(
                      text: 'TOTAL: ${state.totalAmount ?? 0}',
                      color: Colors.white,
                      fontSize: 18);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slideUpPanelPanel(ItemMenuState state) {
    return Column(children: <Widget>[
      Container(
          color: Colors.blue[600],
          child: Center(
              heightFactor: 2,
              child: AppTheme.text(
                  text: 'YOUR ITEMS',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),
      Expanded(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ItemMenuBloc, ItemMenuState>(
              buildWhen: (previous, current) => current is CartItemsState,
              builder: (context, state) {
                if (state is CartItemsState) {
                  return ListView(
                    children: state.products
                        .map((e) => getCartItemsWidgets(e))
                        .toList(),
                  );
                } else {
                  return Container(
                    child: AppTheme.progIndicator,
                  );
                }
              },
            )),
      ),
      Container(
          color: Colors.blue[400],
          child: Row(children: <Widget>[
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppTheme.text(
                        color: Colors.white,
                        text: 'TOTAL: ${state.totalAmount}'))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTheme.roundElevatedButton(
                text: 'Checkout',
                onPressed: () => passEvent(
                  context,
                  SubmitOrder(),
                ),
              ),
            )
          ]))
    ]);
  }

  Widget getCartItemsWidgets(Product product) {
    final quantityController =
        TextEditingController(text: product.quantity.toString());
    final focController =
        TextEditingController(text: product.focQuantity.toString());
    quantityController.selection = TextSelection(
        baseOffset: quantityController.text.length,
        extentOffset: quantityController.text.length);

    focController.selection = TextSelection(
        baseOffset: focController.text.length,
        extentOffset: focController.text.length);
    return AppTheme.card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: AppTheme.text(
                    text: 'ItemName:${product.title}\n'
                        'Unit Price: ${product.packPrice}\n'
                        'Quantity: ${product.quantity}\n'
                        'FOC Qty: ${product.focQuantity}\n'
                        'Amount: ${product.getPrice()}')),
            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(right: 8.0),
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(style: BorderStyle.solid, width: 0.5)),
              child: TextField(
                controller: focController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'FOC'),
                onChanged: (value) => passEvent(
                  context,
                  FOCQuantityChanged(
                    productId: product.productId,
                    quantity: int.tryParse(value) ?? 0,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(style: BorderStyle.solid, width: 0.5)),
              width: 80,
              child: TextField(
                controller: quantityController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
                onChanged: (value) => passEvent(
                  context,
                  QuantityChanged(
                    productId: product.productId,
                    quantity: int.tryParse(value) ?? 0,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.blue,
              ),
              onPressed: () => passEvent(
                  context, ItemRemoveEvent(productId: product.productId)),
            ),
          ],
        ),
      ),
    );
  }
}
