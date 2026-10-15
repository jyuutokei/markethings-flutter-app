import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mt/features/home/domain/entities/order_card_entity.dart';
import 'package:mt/features/home/domain/usecases/get_order_details.dart';
import 'package:mt/features/home/presentation/widgets/appbar_sub.dart';
import 'package:mt/features/home/presentation/widgets/order_card.dart';
import 'package:mt/injection_container.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late Future<List<OrderCardEntity>> _orderItemsFuture;

  @override
  void initState() {
    super.initState();
    _orderItemsFuture = sl<GetOrderDetails>().call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarSub(title: 'Orders'),
      body: FutureBuilder<List<OrderCardEntity>>(
        future: _orderItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitFadingCube(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orderItems = snapshot.data ?? [];

          return orderItems.isEmpty
              ? const Center(child: Text('No orders recorded yet.'))
              : ListView.builder(
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    final orderItem = orderItems[index];

                    return OrderCard(orderItem: orderItem);
                  },
                );
        },
      ),
    );
  }
}
