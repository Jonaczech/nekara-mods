$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$SourceRoot = Join-Path $ProjectRoot "source_music"
$TextureSourceRoot = Join-Path $ProjectRoot "source_textures"
$ResourcesRoot = Join-Path $ProjectRoot "src/main/resources"
$SoundsRoot = Join-Path $ResourcesRoot "assets/minecraft/sounds/music/nekara"
$SoundsJsonPath = Join-Path $ResourcesRoot "assets/minecraft/sounds.json"
$TitleTextureRoot = Join-Path $ResourcesRoot "assets/minecraft/textures/gui/title"
$PanoramaOutputRoot = Join-Path $TitleTextureRoot "background"
$LogoOutputPath = Join-Path $TitleTextureRoot "minecraft.png"
$StaticBackgroundOutputPath = Join-Path $ResourcesRoot "assets/nekara/textures/gui/title/static_background.png"

$Categories = @(
  "menu",
  "overworld",
  "caves",
  "deep_dark",
  "nether",
  "end",
  "underwater",
  "music_discs"
)

$EventCategories = [ordered]@{
  "music.menu" = "menu"
  "music.game" = "overworld"
  "music.creative" = "overworld"
  "music.credits" = "end"
  "music.dragon" = "end"
  "music.end" = "end"
  "music.nether.basalt_deltas" = "nether"
  "music.nether.crimson_forest" = "nether"
  "music.nether.nether_wastes" = "nether"
  "music.nether.soul_sand_valley" = "nether"
  "music.nether.warped_forest" = "nether"
  "music.overworld.badlands" = "overworld"
  "music.overworld.bamboo_jungle" = "overworld"
  "music.overworld.cherry_grove" = "overworld"
  "music.overworld.deep_dark" = "deep_dark"
  "music.overworld.desert" = "overworld"
  "music.overworld.dripstone_caves" = "caves"
  "music.overworld.flower_forest" = "overworld"
  "music.overworld.forest" = "overworld"
  "music.overworld.frozen_peaks" = "overworld"
  "music.overworld.grove" = "overworld"
  "music.overworld.jagged_peaks" = "overworld"
  "music.overworld.jungle" = "overworld"
  "music.overworld.lush_caves" = "caves"
  "music.overworld.meadow" = "overworld"
  "music.overworld.old_growth_taiga" = "overworld"
  "music.overworld.snowy_slopes" = "overworld"
  "music.overworld.sparse_jungle" = "overworld"
  "music.overworld.stony_peaks" = "overworld"
  "music.overworld.swamp" = "overworld"
  "music.under_water" = "underwater"
  "music_disc.11" = "music_discs"
  "music_disc.13" = "music_discs"
  "music_disc.5" = "music_discs"
  "music_disc.blocks" = "music_discs"
  "music_disc.cat" = "music_discs"
  "music_disc.chirp" = "music_discs"
  "music_disc.creator" = "music_discs"
  "music_disc.creator_music_box" = "music_discs"
  "music_disc.far" = "music_discs"
  "music_disc.lava_chicken" = "music_discs"
  "music_disc.mall" = "music_discs"
  "music_disc.mellohi" = "music_discs"
  "music_disc.otherside" = "music_discs"
  "music_disc.pigstep" = "music_discs"
  "music_disc.precipice" = "music_discs"
  "music_disc.relic" = "music_discs"
  "music_disc.stal" = "music_discs"
  "music_disc.strad" = "music_discs"
  "music_disc.tears" = "music_discs"
  "music_disc.wait" = "music_discs"
  "music_disc.ward" = "music_discs"
}

function Get-Ffmpeg {
  $candidates = @()
  if ($env:FFMPEG_PATH) {
    $candidates += $env:FFMPEG_PATH
  }
  $command = Get-Command ffmpeg -ErrorAction SilentlyContinue
  if ($command) {
    $candidates += $command.Source
  }
  $candidates += Get-ChildItem -Recurse -Filter ffmpeg.exe (Join-Path $env:TEMP "nekara-ffmpeg-*") -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName

  $ffmpeg = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
  if (-not $ffmpeg) {
    throw "Could not find ffmpeg.exe. Install ffmpeg or run this after the temporary ffmpeg download used for earlier builds is present."
  }

  return $ffmpeg
}

function Convert-ToSoundId([string] $Name) {
  $baseName = [System.IO.Path]::GetFileNameWithoutExtension($Name).ToLowerInvariant()
  $baseName = $baseName -replace "^\d+[\.\s_-]*", ""
  $baseName = $baseName -replace "[^a-z0-9]+", "_"
  $baseName = $baseName.Trim("_")

  if (-not $baseName) {
    throw "Could not derive a sound id from '$Name'"
  }

  return $baseName
}

function Get-SourceTracks([string] $Category) {
  $path = Join-Path $SourceRoot $Category
  if (-not (Test-Path $path)) {
    return @()
  }

  return Get-ChildItem -File $path |
    Where-Object { $_.Extension -in @(".mp3", ".ogg") } |
    Sort-Object Name
}

function Get-CategorySounds([string] $Category, [hashtable] $TracksByCategory) {
  $fallbacks = @($Category, "overworld", "caves", "menu")
  foreach ($fallback in $fallbacks) {
    if ($TracksByCategory.ContainsKey($fallback) -and $TracksByCategory[$fallback].Count -gt 0) {
      return $TracksByCategory[$fallback]
    }
  }

  throw "No source music found in any usable category."
}

function Convert-ImageToPng([string] $InputPath, [string] $OutputPath) {
  $script = @"
from pathlib import Path
from PIL import Image

input_path = Path(r'''$InputPath''')
output_path = Path(r'''$OutputPath''')

with Image.open(input_path) as image:
    image = image.convert('RGBA')
    output_path.parent.mkdir(parents=True, exist_ok=True)
    image.save(output_path, 'PNG')
"@

  $script | python -
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to convert image '$InputPath' to '$OutputPath'"
  }
}

function Copy-MenuTextures {
  $panoramaSourceRoot = Join-Path $TextureSourceRoot "menu_panorama"
  $logoSourceRoot = Join-Path $TextureSourceRoot "logo"

  New-Item -ItemType Directory -Force -Path $PanoramaOutputRoot | Out-Null
  New-Item -ItemType Directory -Force -Path $TitleTextureRoot | Out-Null

  Get-ChildItem -Path $PanoramaOutputRoot -File -Filter "panorama_*.png" -ErrorAction SilentlyContinue |
    Remove-Item -Force

  if (Test-Path $panoramaSourceRoot) {
    $staticBackground = Get-ChildItem -File $panoramaSourceRoot |
      Where-Object { $_.Extension -in @(".png", ".jpg", ".jpeg") -and $_.Name -ne ".gitkeep" } |
      Sort-Object Name |
      Select-Object -First 1

    if ($staticBackground) {
      Convert-ImageToPng $staticBackground.FullName $StaticBackgroundOutputPath
    }
  }

  if (Test-Path $logoSourceRoot) {
    $logo = Get-ChildItem -File $logoSourceRoot |
      Where-Object { $_.Extension -in @(".png", ".jpg", ".jpeg") -and $_.Name -ne ".gitkeep" } |
      Sort-Object Name |
      Select-Object -First 1

    if ($logo) {
      Convert-ImageToPng $logo.FullName $LogoOutputPath
    }
  }
}

$resolvedSoundsRoot = [System.IO.Path]::GetFullPath($SoundsRoot)
$resolvedProjectRoot = [System.IO.Path]::GetFullPath($ProjectRoot)
if (-not $resolvedSoundsRoot.StartsWith($resolvedProjectRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Refusing to clean sounds outside the project root: $resolvedSoundsRoot"
}

$ffmpeg = Get-Ffmpeg
New-Item -ItemType Directory -Force -Path $SoundsRoot | Out-Null
Get-ChildItem -Path $SoundsRoot -Recurse -File -Include *.ogg -ErrorAction SilentlyContinue |
  Remove-Item -Force

$tracksByCategory = @{}
foreach ($category in $Categories) {
  $tracksByCategory[$category] = @()
  $categoryOutput = Join-Path $SoundsRoot $category
  New-Item -ItemType Directory -Force -Path $categoryOutput | Out-Null

  foreach ($track in Get-SourceTracks $category) {
    $soundId = Convert-ToSoundId $track.Name
    $outputPath = Join-Path $categoryOutput "$soundId.ogg"

    if ($track.Extension -eq ".ogg") {
      Copy-Item -LiteralPath $track.FullName -Destination $outputPath -Force
    } else {
      & $ffmpeg -hide_banner -loglevel error -y -i $track.FullName -vn -c:a libvorbis -q:a 5 $outputPath
      if ($LASTEXITCODE -ne 0) {
        throw "ffmpeg failed for $($track.FullName)"
      }
    }

    $tracksByCategory[$category] += "minecraft:music/nekara/$category/$soundId"
  }
}

$soundEvents = [ordered]@{}
foreach ($eventName in $EventCategories.Keys) {
  $category = $EventCategories[$eventName]
  $sounds = @(Get-CategorySounds $category $tracksByCategory | ForEach-Object {
    [ordered]@{
      name = $_
      stream = $true
    }
  })

  $soundEvents[$eventName] = [ordered]@{
    replace = $true
    sounds = $sounds
  }
}

$soundEvents |
  ConvertTo-Json -Depth 8 |
  Set-Content -LiteralPath $SoundsJsonPath -Encoding UTF8

Copy-MenuTextures

& (Join-Path $PSScriptRoot "build.ps1")
