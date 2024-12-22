import { bind, Variable } from "astal"
import Wp from "gi://AstalWp"

const icons = ["婢", "奄", "奔", "墳"];


function percentage_to_icon(p_: number) {
  let p = Math.floor(p_ * 100);
  if (p == 0) return icons[0];
  if (0 < p && p <= 33) return icons[1];
  if (33 <= p && p <= 66) return icons[2];
  return icons[3];
}


export default function Audio() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!
  const speaker_binding = Variable.derive(
    [bind(speaker, "volume"), bind(speaker, "mute")],
    (v, m) => {
      const icon = m ? icons[0] : percentage_to_icon(v);
      const text = m ? "mute" : `${Math.floor(v * 100)}%`
      return `${icon} ${text}`;
    }
  );

  return (
    <box>
      <label label={bind(speaker_binding)} />
    </box>
  );
}
