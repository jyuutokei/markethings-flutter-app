import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _cardController = TextEditingController();
  var _cardDisplay = '•••• •••• •••• ••••';

  @override
  void initState() {
    super.initState();
    _cardController.addListener(() {
      final text = _cardController.text.replaceAll(RegExp(r'\s'), '');
      final formatted = StringBuffer();
      for (var i = 0; i < text.length; i++) {
        if (i > 0 && i % 4 == 0) formatted.write(' ');
        formatted.write(text[i]);
      }
      setState(() => _cardDisplay = formatted.toString());
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding * 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _cardDisplay,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Gap(defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Exp: MM/YY',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      'CVV: ***',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Gap(defaultPadding * 1.5),
        TextFormField(
          controller: _cardController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
            hintText: '1234 5678 9012 3456',
          ),
          keyboardType: TextInputType.number,
          maxLength: 19,
        ),
        const Gap(defaultPadding),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'MM/YY',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const Gap(defaultPadding),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const Gap(defaultPadding),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Name on Card',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
