# Nekara Mods

Zdrojový repozitář klientského Fabric modu pro Minecraft `26.1.2`. Mod mění
statické pozadí a logo Minecraft menu a mapuje hudební události Minecraftu na
zvukové soubory Nekary.

## Rozsah

- Pouze klientský mod pro jedinou podporovanou sestavu Nekara.
- Fabric Loader `0.19.3+`, Fabric API `0.154.0+26.1.2` a Java 25.
- Statické pozadí je vykreslováno v menu mimo samotný svět; pause menu ve hře
  zachovává běžné pozadí světa.
- Nejde o obecný modpack manager ani o serverový mod.

## Zvukové podklady

Do Git repozitáře nepatří MP3, vygenerované OGG ani výsledné JAR soubory.
Adresáře `source_music/` a
`src/main/resources/assets/minecraft/sounds/music/nekara/` proto obsahují jen
`.gitkeep`. Do nich lze lokálně obnovit pouze podklady s ověřeným právem k
použití a distribuci. Pravidla a důvody jsou v
[PROJECT_MEMORY.md](PROJECT_MEMORY.md).

## Sestavení

Pro kontrolu samotného zdroje stačí:

```powershell
.\gradlew.bat build
```

Pro lokální sestavení s autorizovanou hudbou doplň zdroje do
`source_music/<category>/`, nainstaluj `ffmpeg` (nebo nastav `FFMPEG_PATH`) a
spusť:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-from-source.ps1
```

Skript přegeneruje OGG, `sounds.json`, menu assety a vytvoří lokální JAR v
`dist/`. Bez hudebních podkladů nevznikne funkční zvukový build, což je záměr.

## Dokumentace

- [HANDOFF.md](HANDOFF.md) — aktuální stav a bezpečné navázání práce.
- [PROJECT_MEMORY.md](PROJECT_MEMORY.md) — dlouhodobá technická rozhodnutí.
- [ROADMAP.md](ROADMAP.md) — plán dalších kroků a akceptační kritéria.

