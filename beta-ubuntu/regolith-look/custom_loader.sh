#! /bin/bash

# This script updates the desktop UI configuration based on Xresources
set -eE -u -o pipefail

load_look() {
    # Set GNOME interface options from Xresources values if specifed by Xresources
    GTK_THEME=$(xrescat gtk.theme_name || :)
    if [[ -n ${GTK_THEME:-} ]]; then
        gsettings set org.gnome.desktop.interface gtk-theme "${GTK_THEME}"
    fi

    ICON_THEME=$(xrescat gtk.icon_theme_name || :)
    if [[ -n ${ICON_THEME:-} ]]; then
        gsettings set org.gnome.desktop.interface icon-theme "${ICON_THEME}"
    fi

    WM_FONT=$(xrescat gtk.font_name || :)
    if [[ -n ${WM_FONT:-} ]]; then
        gsettings set org.gnome.desktop.interface font-name "${WM_FONT}"
    fi

    DOC_FONT=$(xrescat gtk.document_font_name || :)
    if [[ -n ${DOC_FONT:-} ]]; then
        gsettings set org.gnome.desktop.interface document-font-name "${DOC_FONT}"
    fi

    MONO_FONT=$(xrescat gtk.monospace_font_name || :)
    if [[ -n ${MONO_FONT:-} ]]; then
        gsettings set org.gnome.desktop.interface monospace-font-name "${MONO_FONT}"
    fi
    
    # Set the wallpaper
    WALLPAPER_FILE=$(xrescat regolith.wallpaper.file || :)
    WALLPAPER_FILE_RESOLVED=$(realpath -e "${WALLPAPER_FILE/#~/${HOME}}" 2>/dev/null || :)
    WALLPAPER_FILE_OPTIONS=$(xrescat regolith.wallpaper.options || :)
    WALLPAPER_PRIMARY_COLOR=$(xrescat regolith.wallpaper.color.primary || :)

    if [[ -f ${WALLPAPER_FILE_RESOLVED:-} ]]; then
        gsettings set org.gnome.desktop.background picture-uri "file://${WALLPAPER_FILE_RESOLVED}"
        gsettings set org.gnome.desktop.background picture-options "${WALLPAPER_FILE_OPTIONS:-wallpaper}"
    elif [[ -n ${WALLPAPER_FILE:-} ]]; then
        printf 'Path to wallpaper file ('%s') is invalid"' "${WALLPAPER_FILE}" >&2
    elif [[ -n ${WALLPAPER_PRIMARY_COLOR:-} ]]; then
        gsettings set org.gnome.desktop.background picture-options none
        gsettings set org.gnome.desktop.background picture-uri none        
        gsettings set org.gnome.desktop.background primary-color "${WALLPAPER_PRIMARY_COLOR}"

        WALLPAPER_SECONDARY_COLOR=$(xrescat regolith.wallpaper.color.secondary || :)
        WALLPAPER_COLOR_SHADE_TYPE=$(xrescat regolith.wallpaper.color.shading.type || :)

        if [[ -n ${WALLPAPER_SECONDARY_COLOR:-} ]] && [[ -n ${WALLPAPER_COLOR_SHADE_TYPE} ]]; then
            gsettings set org.gnome.desktop.background secondary-color "${WALLPAPER_SECONDARY_COLOR}"
            gsettings set org.gnome.desktop.background color-shading-type "${WALLPAPER_COLOR_SHADE_TYPE}"
        else
            gsettings set org.gnome.desktop.background color-shading-type 'solid'
        fi
    fi

    # Set the lockscreen (screensaver) wallpaper
    LOCKSCREEN_WALLPAPER_FILE=$(xrescat regolith.lockscreen.wallpaper.file || :)
    LOCKSCREEN_WALLPAPER_FILE_RESOLVED=$(realpath -e "${LOCKSCREEN_WALLPAPER_FILE/#~/${HOME}}" 2>/dev/null || :)
    LOCKSCREEN_WALLPAPER_FILE_OPTIONS=$(xrescat regolith.lockscreen.wallpaper.options || :)
    LOCKSCREEN_WALLPAPER_PRIMARY_COLOR=$(xrescat regolith.lockscreen.wallpaper.color.primary || :)

    if [[ -f ${LOCKSCREEN_WALLPAPER_FILE_RESOLVED:-} ]]; then
        gsettings set org.gnome.desktop.screensaver picture-uri "file://${LOCKSCREEN_WALLPAPER_FILE_RESOLVED}"
        gsettings set org.gnome.desktop.screensaver picture-options "${LOCKSCREEN_WALLPAPER_FILE_OPTIONS:-wallpaper}"
    elif [[ -n ${LOCKSCREEN_WALLPAPER_FILE:-} ]]; then
        printf 'Path to lockscreen wallpaper file ('%s') is invalid"' "${WALLPAPER_FILE}" >&2
    elif [[ -n ${LOCKSCREEN_WALLPAPER_PRIMARY_COLOR:-} ]]; then
        gsettings set org.gnome.desktop.screensaver picture-options none
        gsettings set org.gnome.desktop.screensaver picture-uri none        
        gsettings set org.gnome.desktop.screensaver primary-color "${LOCKSCREEN_WALLPAPER_PRIMARY_COLOR}"

        LOCKSCREEN_WALLPAPER_SECONDARY_COLOR=$(xrescat regolith.lockscreen.wallpaper.color.secondary || :)
        LOCKSCREEN_WALLPAPER_COLOR_SHADE_TYPE=$(xrescat regolith.lockscreen.wallpaper.color.shading.type || :)

        if [[ -n ${LOCKSCREEN_WALLPAPER_SECONDARY_COLOR:-} ]] && [[ -n ${LOCKSCREEN_WALLPAPER_COLOR_SHADE_TYPE} ]]; then
            gsettings set org.gnome.desktop.screensaver secondary-color "${LOCKSCREEN_WALLPAPER_SECONDARY_COLOR}"
            gsettings set org.gnome.desktop.screensaver color-shading-type "${LOCKSCREEN_WALLPAPER_COLOR_SHADE_TYPE}"
        else
            gsettings set org.gnome.desktop.screensaver color-shading-type 'solid'
        fi
    fi

    # Configure the gnome-terminal profile
    if command -v gnome-terminal &>/dev/null; then # check if gnome-terminal is in ${PATH}
        UPDATE_TERM_FLAG=$(xrescat gnome.terminal.update true || :) # if unspecified, default to true
        if [[ "${UPDATE_TERM_FLAG:-}" == 'true' ]] && \
           [[ -f '/usr/share/regolith-ftue/regolith-init-term-profile' ]] ; then
            /usr/share/regolith-ftue/custom-regolith-init-term-profile
        fi
    fi
}
