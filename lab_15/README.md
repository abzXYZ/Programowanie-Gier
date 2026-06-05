# Lab 15 - Projekt

## Opis
Gra utworzona została w silniku Godot 4.6.1. Jest to platformówka action-adventure bazowana na gameplayu z [Cave Story](https://pl.wikipedia.org/wiki/Cave_Story) z inspiracjami z [Rain World](https://en.wikipedia.org/wiki/Rain_World). Celem gry jest przemierzanie poziomów w celu znalezienia schronienia przed nadejściem śnieżycy walcząc przy tym z przeciwnikami. Niszczenie wrogów zwiększa poziom broni, która na maksymalnym poziomie zyskuje silny odrzut w kierunku przeciwnym do kierunku celowania, pozwalając na szybsze poruszanie się między poziomami. Otrzymywanie obrażeń zmniejsza poziom broni.

## Instrukcja
Uruchomienie:
Pobrać pliki i zaimportować do edytora Godot plik `cavern-tale/project.godot`. Następnie uruchomić główną scenę (F5).
Sterowanie:
- Ruch lewo/prawo - strzałki lewo/prawo
- Celowanie góra/dół - strzałki góra/dół
- Skok - **Z**
- Strzał - **X**
- Interakcja - strzałka w dół (stojąc na ziemi)

## Opis własnego mechanizmu
Gra **nie jest klonem** ani jednej, ani drugiej z wyżej wspomnianych gier. Zamiast tego łączy wybrane aspekty obu z nich, aby stworzyć coś nowego. W grze nacisk kładziony jest przede wszystkim na mechanikę **poruszania się po poziomach przy pomocy swojego arsenału**, inspirowane bronią *Machine Gun* z Cave Story, co bardzo dobrze komplementuje mechanikę **poszukiwania schronienia przed upływem czasu** w postaci śnieżycy, która w momencie nadejścia zaczyna zadawać graczowi 1 punkt obrażeń na sekundę.

## Znane bugi i ograniczenia
- Czasami gra nie zarejestruje próby interakcji z drzwiami. Raczej jest to problem z tym jak gra rejestruje pojedyncze kliknięcie przycisku interakcji.
- Zdarza się, że efekt fade out ekranu nie odegra się przy wychodzeniu z początkowego pokoju.
- Gra nie posiada ustawień w menu głównym.

## Źródła assetów
Soundfont: [Module'90 Atmospheric Edition](https://www.musical-artifacts.com/artifacts/5417)
- Autor: Vini
- Licencja: Domena Publiczna / CC0

Tileset: [Snowland](https://eduardscarpato.itch.io/snowland-gameboy-tileset-16x16)
- Autor: Eduardo Scarpato
- Licencja: *„This asset pack can be used in free and commercial projects. Credit is not required, but appreciated.”*

Tło in-game: [Seamless HD landscape in parts](https://opengameart.org/content/seamless-hd-landscape-in-parts)
- Autor: PWL
- Licencja: CC0

Czcionka: [Pixelated Elegance](https://www.fontspace.com/pixelated-elegance-font-f126145)
- Autor: GGBotNet
- Licencja: Domena Publiczna

Czcionka: [Ithaca](https://www.fontspace.com/ithaca-font-f144503)
- Autor: GGBotNet
- Licencja: SIL Open Font License (OFL)

SFX: [The Fireplace 3.wav](https://freesound.org/people/NoOneIsReal/sounds/387128/)
- Autor: NoOneIsReal
- Licencja: Creative Commons 0

SFX (narzędzie): [oplsfxr](https://libadlmidi-js.github.io/examples/oplsfxr.html)
- Autor: Tony Gies

SFX (narzędzie): [jsfxr](https://sfxr.me/)
- Autor: Eric Fredricksen, Chris McCormick
