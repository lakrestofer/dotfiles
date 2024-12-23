import { Variable, GLib } from "astal"

export default function Time() {
  const time = Variable<GLib.DateTime>(GLib.DateTime.new_now_local())
    .poll(1000, () => GLib.DateTime.new_now_local());

  const label = time(t => t.format("%d/%m/%y @ %H:%M") || "");
  const tooltip = time(t => t.format("%d/%m/%Y @ %H:%M:%S") || "");

  return <label
    className="Time"
    onDestroy={() => time.drop()}
    tooltipText={tooltip}
    label={label}
  />
}
