# Projektová paměť Nekara Mods

Tento dokument zachycuje rozhodnutí, která mají zůstat platná i při další práci.
Aktualizuj jej pouze při vědomé změně směru projektu.

## Produktová hranice

- Repozitář obsahuje jeden klientský Fabric mod pro podporovanou sestavu Nekara,
  nikoliv obecný launcher, modpack ani serverový plugin.
- Cílová verze Minecraftu je centralizována v `gradle.properties` jako
  `minecraft_version=26.1.2`.
- Mod je výhradně klientský (`environment: client`). Server nesmí vyžadovat
  jeho logiku ani na něm nesmí vznikat autoritativní herní stav.

## Menu a vykreslování

- `PanoramaMixin` nahrazuje panorama statickým vlastním pozadím s centrovaným
  `cover` ořezem bez deformace a bez otáčení panoramatu.
- Pozadí patří pouze do obrazovek mimo hru. Herní pause menu ponechává pozadí
  skutečného světa.
- Zdrojové logo a tapeta jsou v `source_textures/`; build script z nich vytvoří
  runtime textury. Jejich rozměry musí odpovídat konstantám v mixinu nebo se
  musí tyto konstanty a vizuální test aktualizovat společně.

## Hudba a práva k assetům

- MP3 zdroje, vygenerované OGG a sestavené JAR jsou záměrně ignorované Gitem.
  Neobcházej toto pravidlo přes Git LFS, release asset nebo jiný veřejný upload.
- Prázdná struktura se drží přes `.gitkeep`, aby lokální build měl stabilní
  cesty bez přenosu binárních dat.
- Do `source_music/` patří jen vlastní nebo prokazatelně licencované podklady.
  Neověřené materiály třetích stran se nesmějí veřejně distribuovat.
- `sounds.json` se generuje skriptem z aktuálních lokálních zdrojů. Neupravuj
  jej ručně jako náhradu za chybějící audio.

## Build a kompatibilita

- Build používá Gradle wrapper a Java 25. `scripts/build.ps1` ověřuje dostupnost
  JDK 25 a kopíruje artefakt do ignorovaného `dist/`.
- `scripts/rebuild-from-source.ps1` vyžaduje `ffmpeg`; může využít proměnnou
  `FFMPEG_PATH`.
- Vývoj používá Fabric API `0.155.2+26.1.2`; manifest deklaruje kompatibilitu od
  `0.154.0+26.1.2`. Při změně API ověř obě hodnoty i skutečnou sestavu launcheru.
- Běžný `gradlew.bat build` ověří kompilaci zdrojů i bez hudby, ale takto
  vzniklý JAR není zvukově kompletní a nesmí se považovat za release.

## Release pravidla

- `build/`, `dist/`, `.gradle/`, `run/`, MP3 a OGG nikdy necommituj.
- Před případným vydáním ověř licenci assetů, obsah JARu, hash, kompatibilitu s
  launcherem a funkci menu i zvuků v čistém klientovi.
- GitHub release nevytvářej, dokud není jasné, jak lze legálně a spolehlivě
  distribuovat kompletní artefakt.

