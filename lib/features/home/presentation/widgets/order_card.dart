import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/core/utils/string_extension.dart';
import 'package:mt/features/home/domain/entities/order_card_entity.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:mt/features/home/domain/usecases/cancel_order.dart';
import 'package:mt/features/home/presentation/widgets/order_items_card.dart';
import 'package:mt/injection_container.dart';

class OrderCard extends StatefulWidget {
  final OrderCardEntity _orderItem;

  const OrderCard({super.key, required this._orderItem});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  OrderCardEntity get orderItem => widget._orderItem;
  bool _isCancelling = false;
  String? _statusOverride;
  String get _status => _statusOverride ?? orderItem.status;

  Future<void> _cancelOrder() async {
    final confirmed = await AppHelpers.showCenterModal(
      context,
      'Cancel this order?',
      'Order #${orderItem.id}',
    );

    if (!confirmed || !mounted) return;

    setState(() => _isCancelling = true);

    try {
      await sl<CancelOrder>().call(orderItem.id);

      if (!mounted) return;
      setState(() => _statusOverride = 'cancelled');

      AppHelpers.showSnackBar(
        context,
        'Order cancelled',
        'Order #${orderItem.id} was cancelled.',
        ContentType.success,
      );
    } catch (error) {
      if (!mounted) return;
      AppHelpers.showSnackBar(
        context,
        'Error',
        'Could not cancel this order.',
        ContentType.failure,
      );
      AppHelpers.logger().error(error);
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }

  Color? statusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green.withValues(alpha: 0.3);
      case 'shipped':
        return Colors.blue.withValues(alpha: 0.3);
      case 'cancelled':
        return Colors.red.withValues(alpha: 0.3);
      default:
        return Colors.orange.withValues(alpha: 0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding / 4),
      child: Card(
        child: ExpansionTile(
          expansionAnimationStyle: const AnimationStyle(
            curve: Curves.elasticOut,
            duration: Duration(milliseconds: 300),
            reverseCurve: Curves.easeOutCubic,
            reverseDuration: Duration(milliseconds: 300),
          ),
          leading: const Icon(Icons.receipt_long),
          title: Text(
            'Order #${orderItem.id}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(AppHelpers.formattedDatetime(orderItem.createdAt)),
          trailing: SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Chip(
                  label: Text(orderItem.status.capitalize()),
                  backgroundColor: statusColor(orderItem.status),
                ),
                const Gap(defaultPadding / 2),
                const Icon(Icons.expand_more),
              ],
            ),
          ),
          collapsedBackgroundColor: Colors.white,
          backgroundColor: AppHelpers.primaryColor(context),
          textColor: Colors.white,
          iconColor: Colors.white,
          collapsedTextColor: Colors.black,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(defaultBorderRadius),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(defaultBorderRadius),
          ),
          children: [
            ...orderItem.items.map(
              (item) => OrderItemsCard(orderLineItem: item),
            ),
            if (_status.toLowerCase() == 'processing')
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: _isCancelling ? null : _cancelOrder,
                        child: Text(
                          _isCancelling ? 'Cancelling...' : 'Cancel Order',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
