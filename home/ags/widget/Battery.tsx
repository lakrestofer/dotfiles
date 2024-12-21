import { bind } from "astal"
import Battery from "gi://AstalBattery"

export default function BatteryLevel() {
  const bat = Battery.get_default()

  return <box className="Battery"
    visible={bind(bat, "isPresent")}>
    <label label={bind(bat, "percentage").as(p =>
      `Bat: ${Math.floor(p * 100)} %`
    )} />
  </box>
}