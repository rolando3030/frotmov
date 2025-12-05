// lib/pages/entradas/entradas_page.dart
import 'package:flutter/material.dart';

import '../../models/order_result.dart';
import '../../services/session_service.dart';
import 'entradas_controller.dart';

class EntradasPage extends StatefulWidget {
  const EntradasPage({
    super.key,
    this.movieTitle = 'AVENGERS ENDGAME (TEST)',
    this.cinemaLine =
        'CP ALCAZAR  |  2D, REGULAR DOBLADA\n15:20  |  Hoy, Miércoles 8 de Octubre de 2025',
    this.baseAmount = 0.0,
  });

  final String movieTitle;
  final String cinemaLine;
  final double baseAmount;

  @override
  State<EntradasPage> createState() => _EntradasPageState();
}

class _EntradasPageState extends State<EntradasPage>
    with SingleTickerProviderStateMixin {
  int tab = 0;

  late EntradasController _controller;
  bool _loading = false;

  final List<_TicketType> promo = [
    _TicketType(
      title: '50% Promo Amex 2025',
      subtitle: 'Exclusivo con tu tarjeta American Express',
      price: 17.0,
    ),
  ];

  final List<_TicketType> generales = [
    _TicketType(
      title: 'GENERAL 2D OL',
      subtitle: 'INCLUYE SERVICIO ONLINE',
      price: 34,
    ),
    _TicketType(
      title: 'MAYORES 60 AÑOS 2D OL',
      subtitle: 'INCLUYE SERVICIO ONLINE',
      price: 32,
    ),
    _TicketType(
      title: 'NIÑOS 2D OL',
      subtitle: 'PARA NIÑOS DE 2 A 11 AÑOS',
      price: 30,
    ),
    _TicketType(
      title: 'BOLETO CONADIS 2D OL',
      subtitle: 'DESCUENTO PARA PERSONAS DISCAPACITADAS',
      price: 28,
    ),
  ];

  double get ticketsAmount {
    double s = 0;
    for (final t in promo) {
      s += t.price * t.qty;
    }
    for (final t in generales) {
      s += t.price * t.qty;
    }
    return s;
  }

  double get total => widget.baseAmount + ticketsAmount;

  bool get _hasSelectedTickets => ticketsAmount > 0;

  void _setTab(int i) => setState(() => tab = i);

  @override
  void initState() {
    super.initState();
    _controller = EntradasController(SessionService.instance);
  }

  Future<void> _onContinuar() async {
    // 1) Intentamos leer args reales que vengan de AsientosPage
    final Object? rawArgs = ModalRoute.of(context)?.settings.arguments;

    int showtimeId;
    List<int> seatIds;

    if (rawArgs is Map<String, dynamic> &&
        rawArgs['showtimeId'] != null &&
        rawArgs['seatIds'] != null) {
      showtimeId = rawArgs['showtimeId'] as int;
      seatIds = (rawArgs['seatIds'] as List).cast<int>();
    } else {
      // 2) Si no llegaron argumentos, usamos valores de prueba
      showtimeId = 1;
      seatIds = [1];
    }

    final tickets = <Map<String, dynamic>>[];

    for (final t in promo) {
      if (t.qty > 0) {
        tickets.add({
          'type': t.title,
          'qty': t.qty,
          'price': t.price,
        });
      }
    }
    for (final t in generales) {
      if (t.qty > 0) {
        tickets.add({
          'type': t.title,
          'qty': t.qty,
          'price': t.price,
        });
      }
    }

    setState(() => _loading = true);

    try {
      final OrderResult result = await _controller.crearOrden(
        showtimeId: showtimeId,
        seatIds: seatIds,
        tickets: tickets,
        userId: SessionService.instance.userId,
      );

      setState(() => _loading = false);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Orden creada'),
          content: Text(
            'ID: ${result.orderId}\n'
            'Total: S/ ${result.totalAmount.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la orden: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2B4A7B);
    const red = Color(0xFFC8102E);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Entradas',
          style: TextStyle(color: blue, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'S/ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info cabecera
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Text(
              widget.movieTitle,
              style: const TextStyle(
                color: blue,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.cinemaLine,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Iconos decorativos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                _HeaderIcon(icon: Icons.event_seat, color: Color(0xFFDE4D4D)),
                _HeaderDivider(),
                _HeaderIcon(
                  icon: Icons.confirmation_num_outlined,
                  color: Color(0xFFDE4D4D),
                ),
                _HeaderDivider(),
                _HeaderIcon(
                  icon: Icons.local_pizza_outlined,
                  color: Color(0xFFDE4D4D),
                ),
                _HeaderDivider(),
                _HeaderIcon(
                  icon: Icons.point_of_sale_outlined,
                  color: Color(0xFFDE4D4D),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tabs
          _TabsBar(
            left: 'Entradas',
            right: 'Canjea tus Codigos',
            selected: tab,
            onChanged: _setTab,
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: tab == 0
                  ? _EntradasList(
                      promo: promo,
                      generales: generales,
                      onChanged: () => setState(() {}),
                    )
                  : const _RedeemTab(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: _loading || !_hasSelectedTickets ? null : _onContinuar,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Continuar'),
            ),
          ),
        ),
      ),
    );
  }
}

/* ====== Widgets auxiliares ====== */

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _HeaderIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: Icon(icon, color: color),
    );
  }
}

class _HeaderDivider extends StatelessWidget {
  const _HeaderDivider();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 2,
        color: const Color(0xFF2B4A7B),
      ),
    );
  }
}

class _TabsBar extends StatelessWidget {
  final String left;
  final String right;
  final int selected;
  final ValueChanged<int> onChanged;

  const _TabsBar({
    required this.left,
    required this.right,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFC8102E);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onChanged(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    left,
                    style: TextStyle(
                      color: selected == 0 ? red : Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => onChanged(1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    right,
                    style: TextStyle(
                      color: selected == 1 ? red : Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 3,
                color: selected == 0 ? red : Colors.transparent,
              ),
            ),
            Expanded(
              child: Container(
                height: 3,
                color: selected == 1 ? red : Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EntradasList extends StatelessWidget {
  final List<_TicketType> promo;
  final List<_TicketType> generales;
  final VoidCallback onChanged;

  const _EntradasList({
    required this.promo,
    required this.generales,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 90),
      children: [
        const _SectionTitle('Tus beneficios'),
        const Text(
          'Descuentos exclusivos para ti. ¡Aprovéchalos!',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 10),
        for (final t in promo) _TicketTile(item: t, onChanged: onChanged),
        const SizedBox(height: 16),
        const _SectionTitle('Entradas Generales'),
        const SizedBox(height: 6),
        for (final t in generales) _TicketTile(item: t, onChanged: onChanged),
      ],
    );
  }
}

class _TicketTile extends StatelessWidget {
  final _TicketType item;
  final VoidCallback onChanged;

  const _TicketTile({required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9),
        border: Border.all(color: const Color(0xFF2B4A7B), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2B4A7B),
                    ),
                  ),
                  if (item.subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          height: 1.1,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'S/ ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _CircleIconButton(
                  icon: Icons.remove,
                  onPressed: item.qty > 0
                      ? () {
                          item.qty--;
                          onChanged();
                        }
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${item.qty}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _CircleIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    item.qty++;
                    onChanged();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RedeemTab extends StatelessWidget {
  const _RedeemTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: const [
        SizedBox(height: 8),
        _FakeCodes(),
        SizedBox(height: 16),
        _ScanButton(),
        SizedBox(height: 24),
        Center(
          child: Text(
            'Ingresa tu codigo aqui',
            style: TextStyle(
              color: Color(0xFF2B4A7B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8),
        _UnderlineInput(),
        SizedBox(height: 16),
        _RedeemButton(),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF2B4A7B),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _CircleIconButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2B4A7B), width: 2),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF2B4A7B)),
      ),
    );
  }
}

class _FakeCodes extends StatelessWidget {
  const _FakeCodes();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _FakeCodeBox(width: 120, height: 60),
        SizedBox(width: 16),
        _FakeCodeBox(width: 90, height: 90),
      ],
    );
  }
}

class _FakeCodeBox extends StatelessWidget {
  final double width, height;
  const _FakeCodeBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF2B4A7B)),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Text('•••', style: TextStyle(letterSpacing: 6)),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2B4A7B),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () {},
        child: const Text('Escanea tu codigo'),
      ),
    );
  }
}

class _UnderlineInput extends StatelessWidget {
  const _UnderlineInput();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.only(top: 4, bottom: 4),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2B4A7B), width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2B4A7B), width: 2),
        ),
      ),
    );
  }
}

class _RedeemButton extends StatelessWidget {
  const _RedeemButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2B4A7B),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () {},
        child: const Text('Canjear'),
      ),
    );
  }
}

/* ====== Modelo interno ====== */

class _TicketType {
  final String title;
  final String subtitle;
  final double price;
  final int initialQty;
  int qty;

  _TicketType({
    required this.title,
    required this.subtitle,
    required this.price,
    this.initialQty = 0,
  }) : qty = initialQty;
}
