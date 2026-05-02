/// Maps a country name to one of six standard regions.
class RegionMapper {
  static const List<String> regions = [
    'North America',
    'South America',
    'Europe',
    'Asia',
    'Africa',
    'Oceania',
    'Other',
  ];

  static const Map<String, String> _countryToRegion = {
    // North America
    'usa': 'North America',
    'us': 'North America',
    'united states': 'North America',
    'united states of america': 'North America',
    'canada': 'North America',
    'mexico': 'North America',

    // South America
    'brazil': 'South America',
    'argentina': 'South America',
    'chile': 'South America',
    'colombia': 'South America',
    'peru': 'South America',
    'venezuela': 'South America',

    // Europe
    'uk': 'Europe',
    'united kingdom': 'Europe',
    'england': 'Europe',
    'germany': 'Europe',
    'france': 'Europe',
    'spain': 'Europe',
    'italy': 'Europe',
    'netherlands': 'Europe',
    'sweden': 'Europe',
    'norway': 'Europe',
    'finland': 'Europe',
    'denmark': 'Europe',
    'poland': 'Europe',
    'ireland': 'Europe',
    'switzerland': 'Europe',
    'belgium': 'Europe',
    'austria': 'Europe',
    'portugal': 'Europe',
    'greece': 'Europe',
    'czech republic': 'Europe',
    'romania': 'Europe',
    'hungary': 'Europe',
    'russia': 'Europe',
    'ukraine': 'Europe',

    // Asia
    'india': 'Asia',
    'china': 'Asia',
    'japan': 'Asia',
    'south korea': 'Asia',
    'korea': 'Asia',
    'singapore': 'Asia',
    'indonesia': 'Asia',
    'vietnam': 'Asia',
    'thailand': 'Asia',
    'philippines': 'Asia',
    'malaysia': 'Asia',
    'pakistan': 'Asia',
    'bangladesh': 'Asia',
    'israel': 'Asia',
    'uae': 'Asia',
    'united arab emirates': 'Asia',
    'saudi arabia': 'Asia',
    'turkey': 'Asia',
    'taiwan': 'Asia',
    'hong kong': 'Asia',

    // Africa
    'south africa': 'Africa',
    'nigeria': 'Africa',
    'egypt': 'Africa',
    'kenya': 'Africa',
    'morocco': 'Africa',
    'ghana': 'Africa',
    'ethiopia': 'Africa',

    // Oceania
    'australia': 'Oceania',
    'new zealand': 'Oceania',
  };

  static String regionFor(String country) {
    return _countryToRegion[country.trim().toLowerCase()] ?? 'Other';
  }
}