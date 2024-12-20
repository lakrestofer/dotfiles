import { bind } from "astal"
import Wp from "gi://AstalWp"

export default function Audio() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!
  const volume = bind(speaker, "volume");
  // const mute = bind(speaker, "mute");

  return (
    <box>
      <label label={volume.as(v => `Vol: ${Math.floor(v * 100)}%`)} />
    </box>
  );
}
