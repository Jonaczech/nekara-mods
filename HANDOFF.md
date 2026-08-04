# Předání projektu Nekara Mods

## Aktuální stav

Repozitář je `Jonaczech/nekara-mods`, výchozí větev `main`. Aktuální zdrojový
stav odpovídá commitu `1307d62` z 4. srpna 2026.

Obsahuje Fabric mod `nekara` ve verzi `0.2.0+mc26.1.2` pro Minecraft `26.1.2`:

- klientský mixin vykresluje statické Nekara pozadí místo panorama;
- zdrojové logo a tapeta jsou součástí repozitáře;
- `sounds.json` obsahuje mapování hudebních událostí;
- Java implementace, Gradle wrapper a PowerShell build skripty jsou verzované.

Hudební soubory ani hotový JAR v repozitáři nejsou. Místo nich existuje prázdná
adresářová struktura s `.gitkeep`; `.gitignore` blokuje `*.mp3`, `*.ogg`,
`build/`, `dist/`, `.gradle/` a `run/`.

## Ověřený stav

4. srpna 2026 proběhl v tomto checkoutu úspěšně příkaz:

```powershell
.\gradlew.bat build
```

Sestavení zkompilovalo hlavní i klientskou Java část. Nebyl proveden živý test
v Minecraft klientovi ani sestavení s hudebními daty; tyto výsledky proto nelze
z uvedeného buildu vyvozovat.

## Bezpečné navázání práce

1. Ověř `git status`, větev a `origin/main`.
2. Přečti [PROJECT_MEMORY.md](PROJECT_MEMORY.md) a [ROADMAP.md](ROADMAP.md).
3. Pro změny kódu spusť `.\gradlew.bat build`.
4. Před vizuálním nebo hudebním testem použij izolovanou lokální kopii assetů;
   necommituj je a nevkládej jejich názvy ani obsah do veřejného release.
5. Při změně hudebních zdrojů spusť `scripts\rebuild-from-source.ps1`, ověř
   obsah JARu a teprve po ověření licencí řeš distribuční kanál.

## Důležité cesty

- `src/client/java/com/nekara/client/mixin/PanoramaMixin.java` — vykreslení
  pozadí menu.
- `src/main/resources/assets/minecraft/sounds.json` — generované mapování
  zvukových událostí.
- `scripts/rebuild-from-source.ps1` — lokální převod hudby, generování assetů a
  build.
- `source_textures/` — verzované zdroje menu grafiky.
- `source_music/` — nepublikované lokální hudební zdroje.

## Nejbližší práce

Nejprve ověř na čisté Fabric `26.1.2` instalaci vykreslení menu při různých
rozlišeních. Poté stanov licenčně bezpečný způsob práce s kompletním zvukovým
balíčkem; bez toho nevydávej JAR ani release.

