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
  const show_icon = Variable(true);
  const toggle_show_icon = () => show_icon.set(!show_icon.get())

  const speaker = Wp.get_default()?.audio.defaultSpeaker!
  const speaker_binding = Variable.derive(
    [bind(show_icon), bind(speaker, "volume"), bind(speaker, "mute")],
    (i, v, m) => {
      if (i) {
        if (m) return icons[0];
        return percentage_to_icon(v);
      } else {
        if (m) return "Vol: mute";
        return `Vol: ${Math.floor(v * 100)}%`;
      }
    }
  );

  return (
    <button onClick={toggle_show_icon}>
      <label label={bind(speaker_binding)} />
    </button>
  );
}
