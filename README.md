# Homebrew Tap

Homebrew packages for [tingfeng347](https://github.com/tingfeng347) tools.

## Install mactools

CLI:

```sh
brew install tingfeng347/tap/mactools
```

Desktop GUI:

```sh
brew install --cask tingfeng347/tap/mactools-gui
```

Or add the tap first:

```sh
brew tap tingfeng347/tap
brew install mactools
```

Requires macOS. Homebrew installs Python and fzf automatically.

```sh
ma --help
maci firefox
```

## Upgrade and uninstall

```sh
brew update
brew upgrade mactools
brew upgrade --cask mactools-gui
brew uninstall mactools
brew uninstall --cask mactools-gui
```

## Available packages

| Package | Type | Project |
| --- | --- | --- |
| `mactools` | formula | [macOS terminal toolkit](https://github.com/tingfeng347/mactools) |
| `mactools-gui` | cask | [Desktop GUI](https://github.com/tingfeng347/mactools/blob/dev/docs/gui.md) |
