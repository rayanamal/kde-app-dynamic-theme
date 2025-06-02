A theme switcher to automatically change application themes based on KDE global theme. 

Currently, only `alacritty` terminal emulator and `micro` text editor are supported.

<div align="center">
  <video src="https://github.com/user-attachments/assets/a782a28b-2312-42e3-a829-c2b9f11c3279" controls></video>
  <em>Alacritty theme syncing with the global theme.</em>
</div>

You can define custom KDE theme - app theme mappings as you wish.

## Installation

<details>
    <summary>For traditional Linux users</summary>

### For traditional Linux users

1. Download Nushell v0.104 [from here.](https://github.com/nushell/nushell/releases/download/0.104.0/nu-0.104.0-x86_64-unknown-linux-gnu.tar.gz)
2. Clone this repository:
```bash
git clone https://github.com/rayanamal/kde-app-dynamic-theme.git
```
3. Extract the binary (the file named 'nu') from the archive, and put it somewhere, preferably into the repo you just cloned. 
4. Open `theme-switcher.nu` in your text editor.
  - Edit the constants at the start if you need to, as explained in the file.
  - Edit the KDE theme -> app theme mappings to match your preferences.
5. Open `theme-switcher.service` file in your editor, and put in the location of the `nu` binary and the script, as explained.
6. Create `~/.config/systemd/user/` directory if it doesn't exist.
7. Put `theme-switcher.path` and `theme-switcher.service` into `~/.config/systemd/user/`:
```bash
mv theme-switcher.path theme-switcher.service ~/.config/systemd/user/
```
8. Run these commands:
```bash
systemctl --user daemon-reload
systemctl --user enable theme-switcher.path
systemctl --user start theme-switcher.path
```
9. Enjoy. If it didn't work for you, open an issue, and I'll do my best.

</details>

<details>
    <summary>For NixOS users</summary>

### For NixOS users

1. Download `theme-switcher.nu` script.
```bash
curl -LO https://raw.githubusercontent.com/rayanamal/kde-app-dynamic-theme/refs/heads/main/theme-switcher.nu
```
2. Open `theme-switcher.nu` in your text editor.
  - Edit the constants at the start if you need to, as explained in the file.
  - Edit the KDE theme -> app theme mappings to match your preferences.
3. Add the below to your `configuration.nix`. Fix the part in `FIXME`:
```nix
  systemd.user.paths.theme-switcher = {
   	wantedBy = [ "default.target" ];
   	pathConfig.PathChanged="%h/.config/kdeglobals";
  };
  
  systemd.user.services.theme-switcher = {
    ## FIXME fix the path to point to the real location of the script.
   	script = "/home/username/.config/nushell/scripts/theme-switcher.nu";
   	path = [ pkgs.nushell ];
  };
```
4. Enjoy. If it didn't work for you, open an issue, and I'll do my best.

Note that this doesn't guarantee `nu` version will stay same, and thus may break in the future.

</details>

## Contributing 

I welcome contributions.