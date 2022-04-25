# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import os


home = os.path.expanduser("~")

config_home = os.environ.get(
    "XDG_CONFIG_HOME",
    os.path.join(home, ".config")
)

# The wallpaper can be set through the enviroment variable "QTILE_WALLPAPER"
# or with a link named "wallpaper" under the config directory.
wallpaper = os.environ.get(
    "QTILE_WALLPAPER",
    os.path.join(config_home, "wallpaper")
)

mod = "mod4"
terminal = guess_terminal()
browser = "firefox"


class PulseAudio():
    @lazy.function
    def set_sink_volume(qtile, volume="+1%"):
        cmd = f"pactl set-sink-volume @DEFAULT_SINK@ {volume}".split()
        qtile.cmd_spawn(cmd)

    @lazy.function
    def set_sink_mute(qtile, mute=None):
        mute_arg = "toggle"

        if mute == True:
            mute_arg = "1"
        elif mute == False:
            mute_arg = "0"

        cmd = f"pactl set-sink-mute @DEFAULT_SINK@ {mute_arg}".split()
        qtile.cmd_spawn(cmd)


@lazy.function
def increase_margin(qtile, step=5):
    qtile.current_layout.margin += step
    qtile.current_layout.group.layout_all()

@lazy.function
def decrease_margin(qtile, step=5):
    current_margin = qtile.current_layout.margin
    current_margin -= step

    if current_margin < 0:
        current_margin = 0

    qtile.current_layout.margin = current_margin
    qtile.current_layout.group.layout_all()


keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod], "y", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod], "o", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod], "u", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod], "i", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "equal", lazy.layout.normalize(),
        desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),

    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),

    # Move between groups.
    Key([mod], "n", lazy.screen.next_group(skip_empty=True),
        desc="Move to next group"),
    Key([mod], "p", lazy.screen.prev_group(skip_empty=True),
        desc="Move to previous group"),

    # Move to next screen.
    Key([mod], "semicolon", lazy.next_screen(), desc="Move to next screen"),

    # Hide and show bar.
    Key([mod, "shift"], "minus", lazy.hide_show_bar(),
        desc="Hide and show bar"),

    # Increase and decrease layout margin.
    Key([mod], "m", decrease_margin(), desc="Decrease margin"),
    Key([mod, "shift"], "m", increase_margin(), desc="Increase margin"),

    # Volume control.
    Key([], "XF86AudioRaiseVolume", PulseAudio.set_sink_volume("+1%")),
    Key([], "XF86AudioLowerVolume", PulseAudio.set_sink_volume("-1%")),
    Key(["shift"], "XF86AudioRaiseVolume", PulseAudio.set_sink_volume("+5%")),
    Key(["shift"], "XF86AudioLowerVolume", PulseAudio.set_sink_volume("-5%")),
    Key([], "XF86AudioMute", PulseAudio.set_sink_mute()),
]


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
        #     desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.Columns(
        border_width=2,
        border_on_single=True,
        border_normal="#00111a",
        border_focus="#00aaff",
        margin=5,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall().
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="monospace",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper=wallpaper,
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),
                widget.Clock(format="%d<b>%H%MR</b>%^b%y"),
            ],
            24,
            background="#040404",
        ),
    ),
    Screen(
        wallpaper=wallpaper,
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Clock(format="%d<b>%H%MR</b>%^b%y"),
            ],
            24,
            background="#040404",
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus="#00aaff",
    border_normal="#00111a",
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
