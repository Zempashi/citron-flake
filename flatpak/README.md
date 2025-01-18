## Build

```
flatpak install org.kde.Sdk//6.8 io.qt.qtwebengine.BaseApp//6.8
flatpak-builder build org.citron_emu.citron.json
flatpak build-export export build
flatpak build-bundle export citron.flatpak org.citron_emu.citron --runtime-repo=https://flathub.org/repo/flathub.flatpakrepo
flatpak install citron.flatpak
```
