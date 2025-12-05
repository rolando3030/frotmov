import 'package:flutter/material.dart';

// Si ya creaste las pantallas de filtros, deja estos imports.
// Si aún no las tienes, puedes comentar estas 3 líneas.
import '../Filtros/city_filter_screen.dart';
import '../Filtros/cinema_filter_screen.dart';
import '../Filtros/date_filter_screen.dart';

import '../asientos/asientos_page.dart';

class MovieDetailPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final bool isEstreno;
  final String synopsis;
  final List<String> idiomas; // p. ej. ["DOBLADA"]
  final List<String> formatos; // p. ej. ["2D","REGULAR"]
  final List<String> genres; // p. ej. ["Acción","Comedia"]

  const MovieDetailPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isEstreno,
    required this.synopsis,
    required this.idiomas,
    required this.formatos,
    this.genres = const [], // 👈 opcional
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Texto que usaremos para mostrar los géneros
    final genresText =
        widget.genres.isEmpty ? 'Sin géneros' : widget.genres.join(' · ');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Películas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 14,
              child: Icon(Icons.person, size: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // -------- Banner + etiqueta ESTRENO + botón Play ----------
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(widget.imagePath, fit: BoxFit.cover),
              ),
              if (widget.isEstreno)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.red.shade700,
                    alignment: Alignment.center,
                    child: const Text(
                      'ESTRENO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.9),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 42,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ---------------- Tabs Detalle / Comprar ----------------
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tab,
              labelColor: Colors.red.shade700,
              unselectedLabelColor: Colors.black87,
              indicatorColor: Colors.red.shade700,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Detalle'),
                Tab(text: 'Comprar'),
              ],
            ),
          ),

          // ---------------- Contenido de tabs ----------------
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                // ======== Detalle ========
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 👇 NUEVO: línea de géneros
                      Text(
                        genresText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const _SectionTitle('Sinopsis'),
                      Text(
                        widget.synopsis,
                        style: const TextStyle(height: 1.35),
                      ),
                      const SizedBox(height: 16),

                      const _SectionTitle('Idioma'),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.idiomas
                            .map((t) => _OutlinedChip(text: t))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      const _SectionTitle('Disponible'),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.formatos
                            .map((t) => _OutlinedChip(text: t))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                // ======== Comprar ========
                _BuyTab(movieTitle: widget.title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF3860A6),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OutlinedChip extends StatelessWidget {
  final String text;
  const _OutlinedChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3860A6), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF3860A6),
          fontWeight: FontWeight.w700,
          letterSpacing: .3,
        ),
      ),
    );
  }
}

/// ======================= COMPRAR TAB =======================

class _BuyTab extends StatefulWidget {
  const _BuyTab({required this.movieTitle});
  final String movieTitle;

  @override
  State<_BuyTab> createState() => _BuyTabState();
}

class _BuyTabState extends State<_BuyTab> {
  // Para mostrar la línea roja bajo el filtro seleccionado
  int _selectedFilter = -1;

  // Data de ejemplo de cines / horarios
  final List<_Cinema> cinemas = [
    _Cinema(
      name: 'CP ALCAZAR',
      address: 'AV. SANTA CRUZ 814 MIRAFLORES LIMA-LIMA',
      groups: const [
        _ShowGroup(label: '2D, REGULAR DOBLADA', times: ['15:20', '21:40']),
      ],
    ),
    _Cinema(
      name: 'CP BRASIL',
      address: 'AV. BRASIL 50 PISO 3 BREÑA LIMA-LIMA',
      groups: const [
        _ShowGroup(label: '2D, DOBLADA', times: ['16:00', '18:40', '21:10']),
      ],
    ),
    _Cinema(
      name: 'CP MALL DEL SUR',
      address: 'CARR. ATCONGO LOTE 1 MALL SJM LIMA-LIMA',
      groups: const [
        _ShowGroup(label: '3D, SUBTITULADA', times: ['17:30', '20:15']),
      ],
    ),
    _Cinema(
      name: 'CP SAN MIGUEL',
      address: 'CALLE MANTARO 356 SAN MIGUEL LIMA-LIMA',
      groups: const [
        _ShowGroup(label: '2D, REGULAR DOBLADA', times: ['14:10', '19:20']),
      ],
    ),
  ];

  Future<void> _openFilter(int i) async {
    setState(() => _selectedFilter = i);
    // Abre las páginas de filtro si las tienes
    switch (i) {
      case 0:
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CityFilterScreen()),
        );
        break;
      case 1:
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CinemaFilterScreen()),
        );
        break;
      case 2:
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DateFilterScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final divider = Container(height: 1, color: Colors.black12);

    return Column(
      children: [
        // --------- Barra de filtros ---------
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  _FilterCell(
                    index: 0,
                    selectedIndex: _selectedFilter,
                    icon: Icons.location_on_outlined,
                    label: 'Ciudad',
                    onTap: _openFilter,
                  ),
                  _VSep(),
                  _FilterCell(
                    index: 1,
                    selectedIndex: _selectedFilter,
                    icon: Icons.local_movies_outlined,
                    label: 'Cine',
                    onTap: _openFilter,
                  ),
                  _VSep(),
                  _FilterCell(
                    index: 2,
                    selectedIndex: _selectedFilter,
                    icon: Icons.today_outlined,
                    label: 'Hoy',
                    onTap: _openFilter,
                  ),
                ],
              ),
              divider,
            ],
          ),
        ),

        // --------- Lista de cines expandibles ---------
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: cinemas.length,
            separatorBuilder: (_, __) => divider,
            itemBuilder: (_, i) =>
                _CinemaTile(cinema: cinemas[i], movieTitle: widget.movieTitle),
          ),
        ),
      ],
    );
  }
}

class _VSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 48, color: Colors.black12);
  }
}

class _FilterCell extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final String label;
  final ValueChanged<int> onTap;

  const _FilterCell({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: Colors.black87),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 3,
                width: isSelected ? 48 : 0,
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CinemaTile extends StatefulWidget {
  final _Cinema cinema;
  final String movieTitle;
  const _CinemaTile({required this.cinema, required this.movieTitle});

  @override
  State<_CinemaTile> createState() => _CinemaTileState();
}

class _CinemaTileState extends State<_CinemaTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.cinema;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => expanded = !expanded),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite_border, color: Colors.blueGrey.shade400),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF3565AA),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        c.address,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expanded ? Icons.remove : Icons.add,
                  color: Colors.blueGrey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          for (final g in c.groups)
            _ShowGroupBlock(
              cinemaName: c.name,
              group: g,
              movieTitle: widget.movieTitle,
            ),
      ],
    );
  }
}

class _ShowGroupBlock extends StatelessWidget {
  final String cinemaName;
  final _ShowGroup group;
  final String movieTitle;

  const _ShowGroupBlock({
    required this.cinemaName,
    required this.group,
    required this.movieTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black12),
              bottom: BorderSide(color: Colors.black12),
            ),
          ),
          child: Text(
            group.label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: group.times.map((t) {
              return _TimeChip(
                time: t,
                onPressed: () {
                  final line =
                      '$cinemaName  |  ${group.label}\n$t  |  Hoy, Miércoles 8 de Octubre de 2025';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AsientosPage(
                        // 👇 Por ahora usamos un id fijo de prueba (1).
                        // Cuando tengas el id real de la función lo reemplazas aquí.
                        showtimeId: 1,
                        movieTitle: movieTitle,
                        cinemaLine: line,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;
  final VoidCallback onPressed;
  const _TimeChip({required this.time, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF3860A6), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Color(0xFF3860A6),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// ======================= MODELOS =======================

class _Cinema {
  final String name;
  final String address;
  final List<_ShowGroup> groups;

  _Cinema({required this.name, required this.address, this.groups = const []});
}

class _ShowGroup {
  final String label; // "2D, REGULAR DOBLADA"
  final List<String> times; // ["15:20","21:40"]

  const _ShowGroup({required this.label, this.times = const []});
}
