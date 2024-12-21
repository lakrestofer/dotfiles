import { bind, Variable } from "astal"
import Battery from "gi://AstalBattery"

const battery_icons = ["", "", "", "", "",];

function percentage_to_icon(p_: number) {
  let p = Math.floor(p_ * 100);
  if (0 <= p && p <= 20) return battery_icons[0];
  if (20 <= p && p <= 40) return battery_icons[1];
  if (40 <= p && p <= 60) return battery_icons[2];
  if (60 <= p && p <= 80) return battery_icons[3];
  if (80 <= p && p <= 100) return battery_icons[4];
}

const percentage_to_label = (p: number) => `Bat: ${Math.floor(p * 100)} %`

export default function BatteryLevel() {
  const show_icon = Variable(true);
  const toggle_show_icon = () => show_icon.set(!show_icon.get())

  const bat = Battery.get_default()
  const present = bind(bat, "isPresent")
  const percentage = bind(bat, "percentage")

  return (
    <button className="Battery" onClick={toggle_show_icon}
      visible={present}>
      {bind(show_icon).as(show_icon => show_icon
        ? (<label label={percentage.as(percentage_to_icon)} />)
        : (<label label={percentage.as(percentage_to_label)} />)
      )}
    </button >
  );
}
