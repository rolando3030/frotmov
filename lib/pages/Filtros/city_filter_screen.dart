import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../widgets/filter_shell.dart';
import '../../theme/app_theme.dart';

const String baseUrl = 'http://10.0.2.2:4567';

class CityFilterScreen extends StatefulWidget {
  const CityFilterScreen({super.key});

  @override
  State<CityFilterScreen> createState() => _CityFilterScreenState();
}

class _CityFilterScreenState extends State<CityFilterScreen> {
  List<Map<String, dynamic>> _cities = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      final resp = await http.get(Uri.parse('$baseUrl/cities'));
      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body);
        setState(() {
          _cities = data.cast<Map<String, dynamic>>();
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
        _error = 'No se pudo cargar ciudades';
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
        itemCount: _cities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final city = _cities[i];
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.purple,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white70, width: 1),
            ),
            child: ListTile(
              title: Text(
                city['name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {
                Navigator.pop(context, {
                  'id': city['id'],
                  'name': city['name'],
                });
              },
            ),
          );
        },
      );
    }

    return FilterShell(
      headerColor: AppTheme.purple,
      titleLink: 'Filtra por ciudad',
      titleIcon: Icons.location_on_outlined,
      child: child,
    );
  }
}
