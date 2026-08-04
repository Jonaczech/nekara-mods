# Nekara Menu Texture Sources

Put source textures for Minecraft menu customization here.

## menu_panorama

Use this legacy-named folder for the static Minecraft title-screen wallpaper.

Put one `.png`, `.jpg`, or `.jpeg` image here. The rebuild script preserves its
full aspect ratio and packages it as:

```text
assets/nekara/textures/gui/title/static_background.png
```

The client mixin renders this as a centered static `cover` image on the title
screen and throughout the out-of-game menus. It does not use Minecraft's
rotating panorama renderer.

## logo

Use this folder for the Nekara title/logo texture for the Minecraft menu.
The rebuild script takes the first `.png`, `.jpg`, or `.jpeg` image and packages
it as:

```text
assets/minecraft/textures/gui/title/minecraft.png
```
