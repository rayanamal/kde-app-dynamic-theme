#!/usr/bin/env nu

# Edit the constants below if you have them different on your system.
# You don't need to change anything if you don't use one of the applications.
const alacritty_config_file = '~/.config/alacritty/alacritty.toml'
const alacritty_theme_dir = '~/.config/alacritty/themes/'
const micro_config_file = '~/.config/micro/settings.json'

def main [] {
    let alacritty_config_file = $alacritty_config_file | path expand
    let micro_config_file = $micro_config_file | path expand
    let alacritty_theme_dir = (
        let sub_theme_dir = $alacritty_theme_dir | path join 'themes';
        if ($sub_theme_dir | path exists) { $sub_theme_dir } else { $alacritty_theme_dir }
        | path expand
    )
    let global_theme = open ~/.config/kdeglobals | from kconfig | get -i KDE.LookAndFeelPackage | default 'org.kde.breeze.desktop'

    ######################## CUSTOMIZE THEMES HERE ##########################
    
    # Below you can see and modify KDE theme -> application theme mappings.
    # You can find the name of your current KDE theme in ~/.config/kdeglobals file, under KDE > LookAndFeelPackage.
    
    # Alacritty terminal emulator
    let new_alacritty_theme = (match $global_theme {
        # To see available Alacritty themes, check out your Alacritty theme directory.
        # If you didn't download any themes for Alacritty yet, you can check out https://github.com/rajasegar/alacritty-themes
        'org.kde.breeze.desktop' => 'github_light_high_contrast', 
        'org.kde.breezedark.desktop' => 'github_dark_high_contrast',
        'org.kde.breezetwilight.desktop' => 'zenburn',
        # Fallback: let other KDE themes map to null (don't change the app theme.)
        _ => null
    })
    
    # Micro text editor
    let new_micro_theme = (match $global_theme {
        # You can add or modify the KDE theme -> micro editor theme mappings below as shown.
        # To see all available micro themes refer to micro's documentation.
        'org.kde.breeze.desktop' => 'dukelight-tc', 
        'org.kde.breezedark.desktop' => 'monokai-dark',
        'org.kde.breezetwilight.desktop' => 'zenburn',
        # Fallback: other KDE themes map to null (they don't change the app theme.)
        _ => null
    })
    
    ###########################################################################
    
    let new_alacritty_theme = (
        if ($new_alacritty_theme | is-not-empty) {
            [$alacritty_theme_dir, ($new_alacritty_theme + '.toml')] | path join
        }
    )
    
    if ($micro_config_file | path exists) and ($new_micro_theme != null) {
        open $micro_config_file
        | upsert colorscheme $new_micro_theme    
        | collect
        | save -f $micro_config_file
    }
    
    if ($alacritty_config_file | path exists) and ($new_alacritty_theme != null) {
        open $alacritty_config_file
        | upsert general.import { 
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