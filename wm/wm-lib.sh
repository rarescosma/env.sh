# Launches chrome/chromium
function browser::launch() {
    local kind="${1}"
    local dot=$(cd -P "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))" && pwd)
    local scale=$(cat $dot/.browser-scale)

    exec $kind --force-device-scale-factor=$scale
}

# Sets the scale for chrome/chromium
function browser::set_scale() {
    local scale="${1}"
    local dot=$(cd -P "$(dirname $(readlink -f "${BASH_SOURCE[0]}"))" && pwd)

    echo $scale > $dot/.browser-scale
}

# Sets the keyboard up
function io::keyboard() {
    setxkbmap -option ctrl:nocaps -layout ro
    xset r rate 300 25
}

# Sets sublime DPI
function dpi::sublime() {
    local dpi_scale="${1}"
    local font_size="${2}"

    sublime_config="${HOME}/.config/sublime-text-3/Packages/User/Preferences.sublime-settings"
    sed -i -e "s/\"dpi_scale\": [^,]\+/\"dpi_scale\": $dpi_scale/g" \
           -e "s/\"font_size\": [^,]\+/\"font_size\": $font_size/g" $sublime_config
}

# Sets terminal font-size
function dpi::terminal() {
    local font_size="${1}"

    xresources="${HOME}/.Xresources"
    sed -i -e "s/Inconsolata:pixelsize=[^:]\+/Inconsolata:pixelsize=$font_size/g" $xresources
    xrdb -merge $xresources
}

# Sets i3 font-size
function dpi::i3() {
    local font_size="${1}"

    i3_config="${HOME}/.i3/config"
    sed -i -e "s/Sans Mono [[:digit:]]\+/Sans Mono $font_size/g" $i3_config
    i3-msg reload 1>/dev/null
}

# Sets GTK font-size
function dpi::gtk() {
    local font_size="${1}"

    gtkrc="${HOME}/.config/gtk-3.0/settings.ini"
    sed -i -e "s/Cantarell [[:digit:]]\+/Cantarell $font_size/g" $gtkrc
}

# Sets Idea font sizes
function dpi::idea() {
    local editor_font_size="${1}"
    local ui_font_size="${2}"

    idea_options="${HOME}/.IntelliJIdea2017.2/config/options"
    sed -i -e "s/\"FONT_SIZE\" value=\"[[:digit:]]\+\"/\"FONT_SIZE\" value=\"$editor_font_size\"/g" \
    $idea_options/editor.xml
    sed -i -e "s/\"FONT_SIZE\" value=\"[[:digit:]]\+\"/\"FONT_SIZE\" value=\"$ui_font_size\"/g" \
    $idea_options/ui.lnf.xml
}

"$@"
