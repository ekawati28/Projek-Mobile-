
import 'package:flutter/material.dart';

class BottomNavbarAdmin extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavbarAdmin({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color biru = Color(0xFF2563EB);
  static const Color abu = Color(0xFF94A3B8);

  static const List<IconData> _icons = [
    Icons.bar_chart_outlined,
    Icons.description_outlined,
    Icons.people_alt_outlined,
    Icons.person_outline,
  ];

  static const List<String> _labels = [
    'Dashboard',
    'Laporan',
    'Petugas',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE8EDF5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(4, (index) {
            final bool aktif = currentIndex == index;

            final Color warna = aktif ? biru : abu;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: SizedBox(
                  height: 68,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _icons[index],
                        size: 23,
                        color: warna,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _labels[index],
                        style: TextStyle(
                          color: warna,
                          fontSize: 11,
                          fontWeight: aktif
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
