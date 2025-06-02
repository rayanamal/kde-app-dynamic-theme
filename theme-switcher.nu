#!/usr/bin/env nu

# Edit the two constants below if you have them different on your system.
const alacritty_config_file: path = '~/.config/alacritty/alacritty.toml'
const alacritty_theme_dir: path = '~/.config/alacritty/themes/'

def main [] {
    let alacritty_config_file = $alacritty_config_file | path expand
    let alacritty_theme_dir = (
        let sub_theme_dir = $alacritty_theme_dir | path join 'themes';
        if ($sub_theme_dir | path exists) { $sub_theme_dir } else { $alacritty_theme_dir }
        | path expand
    )
    let global_theme = (
        open ~/.config/kdeglobals 
        | from kconfig 
        | get -i KDE.LookAndFeelPackage
    )

    let new_alacritty_theme = (
        match $global_theme {
            # You can add or modify the KDE theme -> Alacritty theme mappings below as shown.
            # You can only add the Alacritty themes that exist in your theme directory.
            # You can find the name of your current KDE theme in ~/.config/kdeglobals file, under KDE > LookAndFeelPackage.
            'org.kde.breezedark.desktop' => 'github_dark_high_contrast',
            'org.kde.breezetwilight.desktop' => 'zenburn',
            # The default KDE6 theme 'Breeze' has no name, hence it's represented by null.
            null => 'github_light_high_contrast', 
            # Fallback: other KDE themes map to null (they don't change the Alacritty theme.)
            _ => null
        }
        | if ($in | is-not-empty) {
            [$alacritty_theme_dir, ($in + '.toml')] | path join
        }
    )
    
    if $new_alacritty_theme != null {
        open $alacritty_config_file
        | update general.import { 
            filter {not ($in starts-with $alacritty_theme_dir)}
            | append $new_alacritty_theme
        }
        | collect
        | save -f $alacritty_config_file
    } 
}

def "from kconfig" []: string -> record {
    split row "\n\n"
    | parse "[{key}]\n{value}"
    | update value {
        lines 
        | each {
            parse "{key}={value}" 
            | transpose -dr 
        }
        | into record
    }
    | transpose -dr
}