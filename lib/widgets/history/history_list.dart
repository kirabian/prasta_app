// lib/widgets/history/history_list.dart
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:prasta/models/history_absen_model.dart';
import 'package:prasta/widgets/history/history_list_item_card.dart';
import 'package:prasta/widgets/history/no_data_history.dart';

class HistoryList extends StatelessWidget {
  final List<Datum> historyList;

  const HistoryList({super.key, required this.historyList});

  @override
  Widget build(BuildContext context) {
    if (historyList.isEmpty) {
      return const NoDataHistory();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        final history = historyList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FadeInUp(
            delay: Duration(milliseconds: 100 + (index * 50)),
            child: HistoryListItemCard(history: history),
          ),
        );
      },
    );
  }
}
