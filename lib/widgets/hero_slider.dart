import 'dart:async';
import 'package:flutter/material.dart';

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  final PageController _page = PageController();
  Timer? _timer;
  int current = 0;

  // Slides de ejemplo
  final List<_SlideData> slides = const [
    _SlideData(
      imagePath: 'assets/images/Avengers.jpg',
      title: 'Avengers\nEndgame',
      description:
          'El Conjuro: Último Ritos ofrece otro emocionante capítulo del icónico universo cinematográfico de El Conjuro, basado en hechos reales',
    ),
    _SlideData(
      imagePath: 'assets/images/Transformers.jpg',
      title: 'TRANSFORMERS',
      description:
          'La batalla por la Tierra continúa con nuevos aliados y amenazas inesperadas.',
    ),
    _SlideData(
      imagePath: 'assets/images/Rubias.jpg',
      title: '¿Y dónde están las rubias?',
      description:
          'Durante la misión, los hermanos se infiltran como millonarias y viven su plan de encubierto.',
    ),
    _SlideData(
      imagePath: 'assets/images/Norbit.jpg',
      title: 'NORBIT',
      description:
          'Norbit tiene una segunda oportunidad con su amor de infancia, Kate.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (current + 1) % slides.length;
      _page.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 👇 En lugar de un alto fijo, expandimos al espacio disponible
    return SizedBox.expand(
      child: Stack(
        children: [
          // Imagen a pantalla completa
          PageView.builder(
            controller: _page,
            itemCount: slides.length,
            onPageChanged: (i) => setState(() => current = i),
            itemBuilder: (_, i) => _HeroItem(data: slides[i]),
          ),

          // Degradado inferior
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0, 0.65),
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
            ),
          ),

          // Textos
          Positioned(
            left: 20,
            right: 20,
            bottom: 80,
            child: _SlideText(data: slides[current]),
          ),

          // Indicadores
          Positioned(
            left: 20,
            bottom: 28,
            child: Row(
              children: List.generate(slides.length, (i) {
                final active = i == current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 6),
                  width: active ? 26 : 12,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final String imagePath, title, description;
  const _SlideData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class _HeroItem extends StatelessWidget {
  final _SlideData data;
  const _HeroItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        data.imagePath,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

class _SlideText extends StatelessWidget {
  final _SlideData data;
  const _SlideText({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
