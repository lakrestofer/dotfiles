import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { bind, Variable } from "astal"
import Battery from "gi://AstalBattery"

const time = Variable("").poll(1000, "date");
const battery = Battery.get_default();
const battery_per = Variable(0).poll(1000, () => battery.percentage);

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const is_sus = battery.device_type;


  return <window
    className="Bar"
    gdkmonitor={gdkmonitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    anchor={Astal.WindowAnchor.TOP
      | Astal.WindowAnchor.LEFT
      | Astal.WindowAnchor.RIGHT}
    application={App}>
    <centerbox>
      <button
        onClicked="echo hello"
        halign={Gtk.Align.CENTER} >
        Welcome to This baaaar
      </button>
      <box />
      <button
        onClick={() => print("hello")}
        halign={Gtk.Align.CENTER} >
        <label label={bind(battery_per).as(v => `Bat: ${v}%`)} />
      </button>
    </centerbox>
  </window>
}
