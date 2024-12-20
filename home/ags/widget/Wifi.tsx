
import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import SysTray from "./SysTray"

export default function Wifi() {
  const { wifi } = Network.get_default()

  return <box>
    <label label={bind(wifi, "ssid").as(String)} />
  </box>
}

