import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../widgets/filter_shell.dart';
import '../../theme/app_theme.dart';

const String baseUrl = 'http://10.0.2.2:4567';

class DateFilterScreen extends StatefulWidget {
  const DateFilterScreen({super.key});

  @override
  State<DateFilterScreen> createState() => _DateFilterScreenState();
}

class _DateFilterScreenState extends State<DateFilterScreen> {
  List<Map<String, dynamic>> _dates = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDates();
  }

  Future<void> _fetchDates() async {
    try {
      final resp = await http.get(Uri.parse('$baseUrl/filter_dates'));
      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body);
        setState(() {
          _dates = data.cast<Map<String, dynamic>>();
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Error backend: ${resp.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'No se pudieron cargar fechas';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_loading) {
      child = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      child = Center(child: Text(_error!));
    } else {
      child = ListView.separated(
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final d = _dates[i];
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.purple,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white70, width: 1),
            ),
            child: ListTile(
              title: Text(
                (d['label'] ?? d['iso']) as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {
                Navigator.pop(context, {
                  'iso': d['iso'],
                  'label': d['label'] ?? d['iso'],
                });
              },
            ),
          );
        },
      );
    }

    return FilterShell(
      headerColor: AppTheme.purple,
      titleLink: 'Filtra por fecha',
      titleIcon: Icons.event_note_outlined,
      child: child,
    );
  }
}
