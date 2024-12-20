import { bind, Variable } from "astal"
import Wp from "gi://AstalWp"

export default function Audio() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!
  const speaker_binding = Variable.derive(
    [bind(speaker, "volume"), bind(speaker, "mute")],
    (v, m) => {
      if (m) return "Vol: mute";
      return `Vol: ${Math.floor(v * 100)}%`;
    }
  );

  return (
    <box>
      <label label={bind(speaker_binding).as(v => v)} />
    </box>
  );
}
