# Neovim Config

## Needed Packages
- cargo
- fzf
- go
- node/npm
- ripgrep
- yazi

## NPM Packages
- nodemon

## Fonts
Install the fonts from the `fonts/` directory to get nice symbols for vim-flog

## MacOS
Put this into `~/.cargo/config`:
```toml
[target.x86_64-apple-darwin]
rustflags = [
    "-C", "link-arg=-undefined",
    "-C", "link-arg=dynamic_lookup",
]

[target.aarch64-apple-darwin]
rustflags = [
    "-C", "link-arg=-undefined",
    "-C", "link-arg=dynamic_lookup",
]
```
