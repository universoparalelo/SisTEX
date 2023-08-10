import 'package:flutter/material.dart';

class Responsive {
  double calculateColumnSpacing(BuildContext context, int numberOfColumns) {
    /*
    double totalWidth = MediaQuery.of(context).size.width;
    double availableWidth =
        totalWidth * 0.8; // El 80% del ancho total disponible para el DataTable

    double totalSpacing = (numberOfColumns - 1) *
        15.0; // Espacio total entre las columnas (ajusta este valor según tus necesidades)
    double spacing = (availableWidth - totalSpacing) / numberOfColumns;
    return spacing;*/

    double totalWidth = MediaQuery.of(context).size.width;
    double availableWidth = totalWidth * 0.8;
    double totalSpacing = (numberOfColumns - 1) * 15.0;
    double spacing = (availableWidth - totalSpacing) / numberOfColumns;
    return spacing;
  }
}
