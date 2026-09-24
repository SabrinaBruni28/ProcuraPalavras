import 'package:flutter/material.dart';

Widget sliderVolume({
  required IconData icone,
  required String titulo,
  required double volume,
  required ValueChanged<double> onChanged,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final pequeno = constraints.maxWidth < 400;

      if (pequeno) {
        return Column(
          children: [
            Row(
              children: [
                Icon(icone, size: 30),

                const SizedBox(width: 15),

                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                  width: 50,
                  child: Text(
                    '${(volume * 100).round()}%',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            Slider(
              value: volume,
              min: 0,
              max: 1,
              divisions: 20,
              label: '${(volume * 100).round()}%',
              onChanged: onChanged,
            ),
          ],
        );
      }

      return Row(
        children: [
          Icon(icone, size: 30),

          const SizedBox(width: 15),

          SizedBox(
            width: 80,
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Slider(
              value: volume,
              min: 0,
              max: 1,
              divisions: 20,
              label: '${(volume * 100).round()}%',
              onChanged: onChanged,
            ),
          ),

          SizedBox(
            width: 50,
            child: Text(
              '${(volume * 100).round()}%',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
    },
  );
}
