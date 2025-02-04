import { Astal, Gtk, Gdk } from "astal/gtk3"
import SysTray from "./SysTray"
import Wifi from "./Wifi"
import Audio from "./Audio"
import Battery from "./Battery"
// import Media from "./Media"
import { Workspaces, FocusedClient } from "./Hyprland"
import Time from "./Time"

export default function Bar(monitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

  return <window
    className="Bar"
    gdkmonitor={monitor}
    exclusivity={Astal.Exclusivity.EXCLUSIVE}
    anchor={BOTTOM | LEFT | RIGHT}>
    <centerbox>
      <box hexpand halign={Gtk.Align.START}>
        <Workspaces />
        <FocusedClient />
      </box>
      <box>
        <label className="quote" label={"P(A|B) = (P(A) * P(B|A)) / P(B)"} />
      </box>
      <box hexpand halign={Gtk.Align.END} >
        <SysTray />
        <Wifi />
        <Audio />
        <Battery />
        <Time />
      </box>
    </centerbox>
  </window>
}
