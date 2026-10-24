import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/features/home/domain/entities/profile_entity.dart';
import 'package:mt/features/home/domain/usecases/get_user_profile.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderConfirmation extends StatefulWidget {
  final int? orderId;
  final List<CartItemDetailsEntity> cartItems;

  const OrderConfirmation({
    super.key,
    required this.orderId,
    required this.cartItems,
  });

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  ProfileEntity? _profile;
  final _confirmedAt = DateTime.now();

  num get _total =>
      widget.cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = sl<SupabaseClient>().auth.currentUser;
      if (user == null) return;
      final profile = await sl<GetUserProfile>().call(user.id);
      if (mounted) setState(() => _profile = profile);
    } catch (error) {
      AppHelpers.logger().error(error);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fallbackAvatar =
        'https://static.wikia.nocookie.net/zenless-zone-zero/images/5/53/Avatar_Default_Anonymous.png/revision/latest?cb=20240725210433';
    String fallbackImageUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIVapXPpvWb8ds1BaPIHsUEKnobPWCWI3srk7Wc5hFNA&s=10';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 2,
                vertical: defaultPadding * 2,
              ),
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 72,
                    color: Colors.green,
                  ),
                ),
                const Gap(defaultPadding),
                Text(
                  'Order Confirmed',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(defaultPadding / 2),
                Text(
                  widget.orderId == null
                      ? 'Your order has been placed.'
                      : 'Order #${widget.orderId} has been placed successfully.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(defaultPadding * 1.5),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: CachedNetworkImageProvider(
                            _profile?.avatarUrl ?? fallbackAvatar,
                          ),
                        ),
                        const Gap(defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profile?.displayName ?? 'Customer',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                AppHelpers.formattedDatetime(_confirmedAt),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(defaultPadding),
                Text(
                  'Items in your order',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(defaultPadding / 2),
                for (final item in widget.cartItems) ...[
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding / 1.5),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              defaultBorderRadius,
                            ),
                            child: SizedBox(
                              width: 64,
                              height: 64,
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl ?? fallbackImageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      height: 64,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: imageProvider,
                                        ),
                                      ),
                                    ),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const SizedBox.expand(),
                                errorBuilder: (context, url, error) =>
                                    const Icon(Icons.image_outlined),
                              ),
                            ),
                          ),
                          const Gap(defaultPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Variant: ${item.variantName}'),
                                Text('Quantity: ${item.quantity}'),
                              ],
                            ),
                          ),
                          const Gap(defaultPadding / 2),
                          Text(
                            AppHelpers.pesoFormatter(
                              item.price * item.quantity,
                            ),
                            style: TextStyle(
                              color: AppHelpers.primaryColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(defaultPadding / 3),
                ],
                const Gap(defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppHelpers.pesoFormatter(_total),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Gap(defaultPadding * 1.5),
                FilledButton.icon(
                  onPressed: () => context.pushReplacementNamed(AppRoute.home),
                  label: const Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
