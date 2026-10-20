import 'package:flutter/material.dart';
import 'package:mt/features/home/domain/entities/order_card_entity.dart';
import 'package:mt/features/home/domain/usecases/get_order_details.dart';
import 'package:mt/features/home/presentation/widgets/appbar_sub.dart';
import 'package:mt/features/home/presentation/widgets/order_card.dart';
import 'package:mt/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          final loading = snapshot.connectionState == ConnectionState.waiting;

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orderItems = loading
              ? List.generate(
                  7,
                  (index) => OrderCardEntity(
                    id: -index - 1,
                    status: 'shipped',
                    createdAt: DateTime(2000),
                    items: const [],
                  ),
                )
              : snapshot.data ?? const <OrderCardEntity>[];

          if (!loading && orderItems.isEmpty) {
            return const Center(child: Text('No orders recorded yet.'));
          }

          return Skeletonizer(
            enabled: loading,
            ignorePointers: true,
            child: ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final orderItem = orderItems[index];

                return OrderCard(orderItem: orderItem);
              },
            ),
          );
        },
      ),
    );
  }
}
