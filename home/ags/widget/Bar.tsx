import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { bind, Variable } from "astal"
import Battery from "gi://AstalBattery"

const time = Variable("").poll(1000, "date");
const battery = Battery.get_default();

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const batter_pers = Variable(battery.get_percentage()).poll(500, _ => battery.get_percentage());

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
        Welcome to AGS!
      </button>
      <box />
      <button
        onClick={() => print("hello")}
        halign={Gtk.Align.CENTER} >
        <label label={time()} />
      </button>
      <box>
        <button>
          What about this?
        </button>
        <label label={batter_pers(v => `Bat: ${v}%`)} />
      </box>
    </centerbox>
  </window>
}
