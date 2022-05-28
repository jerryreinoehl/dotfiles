import subprocess


class PulseAudio():
    def set_sink_volume(self, volume="+1%", sink="@DEFAULT_SINK@"):
        cmd = f"pactl set-sink-volume {sink} {volume}".split()
        subprocess.Popen(cmd)

    def set_sink_mute(self, mute=None, sink="@DEFAULT_SINK@"):
        mute_arg = "toggle"

        if mute == True:
            mute_arg = "1"
        elif mute == False:
            mute_arg = "0"

        cmd = f"pactl set-sink-mute {sink} {mute_arg}".split()
        subprocess.Popen(cmd)


pactl = PulseAudio()
