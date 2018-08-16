# valutex_app

A new Flutter project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

Impediments:
- TextField can not align to right
- Hero text in animation lose the style

flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localization.dart 

flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localization.dart lib/l10n/intl_*.arb
    
Bug arrange countries
When Europe is in favourites and is moved 
Then disappears from favourites