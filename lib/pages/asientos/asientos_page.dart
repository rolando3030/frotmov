// lib/pages/asientos/asientos_page.dart
import 'package:flutter/material.dart';

import '../../models/seat.dart';
import '../../services/session_service.dart';
import 'asientos_controller.dart';
import '../entradas/entradas_page.dart'; // 👈 IMPORTANTE, arriba del archivo

class AsientosPage extends StatefulWidget {
  // Id de la función (horario) que viene de la pantalla anterior
  final int showtimeId;
  final String movieTitle;
  final String cinemaLine;

  const AsientosPage({
    super.key,
    required this.showtimeId,
    this.movieTitle = 'AVENGERS ENDGAME (TEST)',
    this.cinemaLine =
        'CP ALCAZAR  |  2D, REGULAR DOBLADA\n15:20  |  Hoy, Miércoles 8 de Octubre de 2025',
  });

  @override
  State<AsientosPage> createState() => _AsientosPageState();
}

class _AsientosPageState extends State<AsientosPage> {
  late AsientosController _controller;
  late Future<List<Seat>> _futureSeats;
  final Set<int> _selectedSeatIds = {};

  @override
  void initState() {
    super.initState();
    _controller = AsientosController(SessionService.instance);
    _futureSeats = _controller.getSeatsForShowtime(widget.showtimeId);
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2B4A7B);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movieTitle,
          style: const TextStyle(color: blue),
        ),
        iconTheme: const IconThemeData(color: blue),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Seat>>(
        future: _futureSeats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final seats = snapshot.data ?? [];

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  widget.cinemaLine,
                  style: const TextStyle(fontSize: 11, height: 1.2),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pantalla',
                style: TextStyle(
                  color: blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemCount: seats.length,
                  itemBuilder: (context, index) {
                    final seat = seats[index];
                    final selected = _selectedSeatIds.contains(seat.id);

                    Color color;
                    if (seat.isSold) {
                      color = Colors.grey;
                    } else if (selected) {
                      color = Colors.orange;
                    } else {
                      color = blue;
                    }

                    return GestureDetector(
                      onTap: seat.isSold
                          ? null
                          : () {
                              setState(() {
                                if (selected) {
                                  _selectedSeatIds.remove(seat.id);
                                } else {
                                  _selectedSeatIds.add(seat.id);
                                }
                              });
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _LegendDot(color: blue, text: 'Disponible'),
                    _LegendDot(color: Colors.grey, text: 'Ocupado'),
                    _LegendDot(color: Colors.orange, text: 'Seleccionado'),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedSeatIds.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EntradasPage(
                                  movieTitle: widget.movieTitle,
                                  cinemaLine: widget.cinemaLine,
                                ),
                                settings: RouteSettings(
                                  arguments: {
                                    'showtimeId': widget.showtimeId,
                                    'seatIds': _selectedSeatIds.toList(),
                                  },
                                ),
                              ),
                            );
                          },
                    child: const Text('Continuar'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
