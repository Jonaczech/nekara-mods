# Roadmap Nekara Mods

Tento plán vymezuje práci pouze pro klientský Fabric mod Nekara. Není to plán
pro launcher, server ani veřejný modpack katalog.

## Dokončeno

- [x] Založen samostatný repozitář `Jonaczech/nekara-mods`.
- [x] Přenesen Fabric zdroj, Gradle wrapper, build skripty a menu grafika.
- [x] Odděleny nepublikované hudební binárky od verzovaného zdroje.
- [x] Zachována prázdná struktura audio kategorií pomocí `.gitkeep`.
- [x] Ověřena kompilace Java zdrojů příkazem `.\gradlew.bat build`.

## Před prvním distribuovatelným buildem

- [ ] Potvrdit práva k použití a distribuci každého hudebního podkladu.
- [ ] Rozhodnout schválený neveřejný nebo licenčně vhodný kanál pro kompletní
  zvukový artefakt.
- [ ] Obnovit autorizované assety lokálně a spustit
  `scripts\rebuild-from-source.ps1`.
- [ ] Ověřit obsah JARu: `fabric.mod.json`, mixin konfiguraci, menu textury,
  OGG soubory a konzistentní `sounds.json`.
- [ ] Zapsat SHA-256, velikost artefaktu a přesný postup reprodukce buildu.

## Funkční akceptace na klientovi

- [ ] Ověřit start na Fabric Loader `0.19.3+`, Minecraft `26.1.2` a Java 25.
- [ ] Ověřit statické pozadí na title screen, Options, výběru světa a multiplayeru.
- [ ] Ověřit, že pause menu ve světě dál ukazuje herní svět.
- [ ] Ověřit `cover` ořez na běžných i ultrawide rozlišeních bez natažení obrazu.
- [ ] Ověřit spuštění a náhodný výběr hudby pro každou mapovanou vanilla událost.
- [ ] Ověřit chování bez chybějících souborů a bez chyb v klientském logu.

## Další údržba

- [ ] Při změně Minecraftu ověř oficiální dostupnost metadat, Fabric Loader,
  Fabric API, Loom i Java před změnou `gradle.properties`.
- [ ] Udržovat `README.md`, `HANDOFF.md` a `PROJECT_MEMORY.md` synchronní s
  ověřeným stavem a případným release.
- [ ] Přidat automatizovaný obsahový test JARu až ve chvíli, kdy existuje
  licenčně schválený a reprodukovatelný testovací asset set.
