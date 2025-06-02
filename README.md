An Alacritty theme auto-switcher script based on KDE global theme.

You can define custom KDE theme - Alacritty theme mappings.

## Installation

1. Download Nushell v0.104 [from here.](https://github.com/nushell/nushell/releases/download/0.104.0/nu-0.104.0-x86_64-unknown-linux-gnu.tar.gz)
2. Clone this repository into your alacritty config directory:
```
cd <my-alacritty-config-directory> # Most likely, it's ~/.config/alacritty
git clone https://github.com/rayanamal/alacritty-kde-dynamic-theme.git
```
3. Extract the binary (the file named 'nu') from the archive, and put it somewhere, preferably into the repo you just cloned. 
4. Open `theme-switcher.nu` in your text editor.
  - Edit the two constants at the start, as explained in the file.
  - Edit the KDE theme -> Alacritty theme mappings to match your preferences, as explained in the file.
5. Open `theme-switcher.service` file in your editor, and fix the part indicated in the comments.
6. Put `theme-switcher.path` and `theme-switcher.service` into `~/.config/systemd/user/`. Create the directory if it doesn't exist.
7. Run these commands:
```
systemctl --user daemon-reload
systemctl --user enable theme-switcher.path
systemctl --user start theme-switcher.path
```
8. Enjoy. If it didn't work for you, open an issue, and I'll do my best.