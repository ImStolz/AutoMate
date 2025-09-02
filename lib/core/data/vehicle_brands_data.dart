/// Base de datos completa de marcas y modelos de vehículos
class VehicleBrandsData {
  static const Map<String, List<String>> brandsAndModels = {
    'Audi': [
      'A1', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'Q2', 'Q3', 'Q5', 'Q7', 'Q8',
      'TT', 'R8', 'e-tron GT', 'RS3', 'RS4', 'RS5', 'RS6', 'RS7', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'
    ],
    'BMW': [
      'Serie 1', 'Serie 2', 'Serie 3', 'Serie 4', 'Serie 5', 'Serie 6', 'Serie 7', 'Serie 8',
      'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'Z4', 'i3', 'i4', 'iX', 'iX3',
      'M2', 'M3', 'M4', 'M5', 'M8'
    ],
    'Mercedes-Benz': [
      'Clase A', 'Clase B', 'Clase C', 'Clase E', 'Clase S', 'CLA', 'CLS', 'GLA', 'GLB', 'GLC', 'GLE', 'GLS',
      'AMG GT', 'SL', 'SLC', 'EQA', 'EQB', 'EQC', 'EQS', 'EQV', 'Vito', 'Sprinter'
    ],
    'Volkswagen': [
      'Polo', 'Golf', 'Jetta', 'Passat', 'Arteon', 'Tiguan', 'Touareg', 'T-Cross', 'T-Roc',
      'ID.3', 'ID.4', 'ID.5', 'Up!', 'Beetle', 'Amarok', 'Caddy', 'Crafter'
    ],
    'Toyota': [
      'Yaris', 'Corolla', 'Camry', 'Avalon', 'Prius', 'RAV4', 'Highlander', 'Land Cruiser', 'Prado',
      'C-HR', '4Runner', 'Tacoma', 'Tundra', 'Sienna', 'Hiace', 'Hilux'
    ],
    'Honda': [
      'Civic', 'Accord', 'Fit', 'City', 'CR-V', 'HR-V', 'Pilot', 'Passport', 'Ridgeline',
      'Insight', 'Clarity', 'Odyssey'
    ],
    'Nissan': [
      'Versa', 'Sentra', 'Altima', 'Maxima', 'Kicks', 'Qashqai', 'X-Trail', 'Pathfinder', 'Armada',
      'Frontier', 'Titan', 'Leaf', 'Ariya', '370Z', 'GT-R'
    ],
    'Ford': [
      'Fiesta', 'Focus', 'Fusion', 'Mustang', 'EcoSport', 'Escape', 'Edge', 'Explorer', 'Expedition',
      'F-150', 'Ranger', 'Bronco', 'Mach-E', 'Transit'
    ],
    'Chevrolet': [
      'Spark', 'Sonic', 'Cruze', 'Malibu', 'Camaro', 'Corvette', 'Trax', 'Equinox', 'Traverse', 'Tahoe',
      'Silverado', 'Colorado', 'Suburban', 'Bolt EV', 'Volt'
    ],
    'Hyundai': [
      'i10', 'i20', 'i30', 'Elantra', 'Sonata', 'Genesis', 'Kona', 'Tucson', 'Santa Fe', 'Palisade',
      'Ioniq', 'Ioniq 5', 'Ioniq 6', 'Nexo'
    ],
    'Kia': [
      'Picanto', 'Rio', 'Forte', 'Optima', 'Stinger', 'Soul', 'Seltos', 'Sportage', 'Sorento', 'Telluride',
      'Niro', 'EV6', 'Carnival'
    ],
    'Mazda': [
      'Mazda2', 'Mazda3', 'Mazda6', 'CX-3', 'CX-30', 'CX-5', 'CX-9', 'MX-5 Miata', 'CX-50'
    ],
    'Subaru': [
      'Impreza', 'Legacy', 'Outback', 'Forester', 'Ascent', 'WRX', 'BRZ', 'Crosstrek'
    ],
    'Mitsubishi': [
      'Mirage', 'Lancer', 'Eclipse Cross', 'Outlander', 'Pajero', 'ASX', 'L200'
    ],
    'Peugeot': [
      '208', '308', '508', '2008', '3008', '5008', 'Partner', 'Boxer', 'e-208', 'e-2008'
    ],
    'Renault': [
      'Clio', 'Megane', 'Fluence', 'Talisman', 'Captur', 'Kadjar', 'Koleos', 'Duster', 'Kangoo', 'Master'
    ],
    'Citroën': [
      'C1', 'C3', 'C4', 'C5', 'C3 Aircross', 'C5 Aircross', 'Berlingo', 'Jumper', 'ë-C4'
    ],
    'Fiat': [
      '500', 'Panda', 'Tipo', 'Punto', '500X', '500L', 'Ducato', 'Fiorino', '500e'
    ],
    'Alfa Romeo': [
      'Giulia', 'Stelvio', 'Giulietta', '4C', 'Tonale'
    ],
    'Jeep': [
      'Renegade', 'Compass', 'Cherokee', 'Grand Cherokee', 'Wrangler', 'Gladiator', 'Wagoneer'
    ],
    'Land Rover': [
      'Defender', 'Discovery', 'Discovery Sport', 'Range Rover', 'Range Rover Sport', 'Range Rover Evoque', 'Range Rover Velar'
    ],
    'Jaguar': [
      'XE', 'XF', 'XJ', 'F-Type', 'E-Pace', 'F-Pace', 'I-Pace'
    ],
    'Volvo': [
      'S60', 'S90', 'V60', 'V90', 'XC40', 'XC60', 'XC90', 'C40', 'EX30', 'EX90'
    ],
    'Porsche': [
      '911', 'Boxster', 'Cayman', 'Panamera', 'Cayenne', 'Macan', 'Taycan'
    ],
    'Tesla': [
      'Model S', 'Model 3', 'Model X', 'Model Y', 'Cybertruck', 'Roadster'
    ],
    'Lexus': [
      'IS', 'ES', 'GS', 'LS', 'UX', 'NX', 'RX', 'GX', 'LX', 'LC', 'RC'
    ],
    'Infiniti': [
      'Q50', 'Q60', 'QX50', 'QX60', 'QX80'
    ],
    'Acura': [
      'ILX', 'TLX', 'RLX', 'RDX', 'MDX', 'NSX'
    ],
    'Genesis': [
      'G70', 'G80', 'G90', 'GV60', 'GV70', 'GV80'
    ],
    'Mini': [
      'Cooper', 'Cooper S', 'Countryman', 'Clubman', 'Convertible', 'Electric'
    ],
    'Smart': [
      'ForTwo', 'ForFour', 'EQForTwo', 'EQForFour'
    ],
    'Suzuki': [
      'Swift', 'Baleno', 'Vitara', 'S-Cross', 'Jimny', 'Ignis', 'Alto'
    ],
    'Isuzu': [
      'D-Max', 'MU-X', 'NPR', 'FRR'
    ],
    'Great Wall': [
      'Haval H6', 'Haval H9', 'Wingle', 'Poer'
    ],
    'BYD': [
      'Atto 3', 'Han', 'Tang', 'Song', 'Qin', 'Dolphin', 'Seal'
    ],
    'Chery': [
      'Tiggo 2', 'Tiggo 4', 'Tiggo 7', 'Tiggo 8', 'Arrizo 6'
    ],
    'JAC': [
      'S2', 'S3', 'S4', 'T6', 'T8'
    ],
    'MG': [
      'MG3', 'MG5', 'MG6', 'HS', 'ZS', 'Marvel R'
    ]
  };

  /// Obtiene todas las marcas disponibles
  static List<String> getAllBrands() {
    return brandsAndModels.keys.toList()..sort();
  }

  /// Obtiene todos los modelos de una marca específica
  static List<String> getModelsForBrand(String brand) {
    return brandsAndModels[brand] ?? [];
  }

  /// Busca marcas que coincidan con el texto de búsqueda
  static List<String> searchBrands(String query) {
    if (query.isEmpty) return getAllBrands();
    
    return getAllBrands()
        .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Busca modelos que coincidan con el texto de búsqueda dentro de una marca
  static List<String> searchModels(String brand, String query) {
    final models = getModelsForBrand(brand);
    if (query.isEmpty) return models;
    
    return models
        .where((model) => model.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Busca en todas las marcas y modelos
  static Map<String, List<String>> searchAll(String query) {
    if (query.isEmpty) return brandsAndModels;
    
    final result = <String, List<String>>{};
    final queryLower = query.toLowerCase();
    
    for (final entry in brandsAndModels.entries) {
      final brand = entry.key;
      final models = entry.value;
      
      // Buscar en nombre de marca
      if (brand.toLowerCase().contains(queryLower)) {
        result[brand] = models;
        continue;
      }
      
      // Buscar en modelos
      final matchingModels = models
          .where((model) => model.toLowerCase().contains(queryLower))
          .toList();
      
      if (matchingModels.isNotEmpty) {
        result[brand] = matchingModels;
      }
    }
    
    return result;
  }
}
