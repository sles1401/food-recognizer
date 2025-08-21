import 'package:flutter/material.dart';

class ClassificationItem extends StatelessWidget {
  final String item;
  final String value;

  const ClassificationItem({
    super.key,
    required this.item,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(item, style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class ClassificationItemShimmer extends StatelessWidget {
  const ClassificationItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(width: 120, height: 24, color: Colors.black12,
          ),
          const Spacer(),
          Container(width: 50, height: 24, color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
