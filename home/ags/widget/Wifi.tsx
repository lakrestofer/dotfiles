import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import SysTray from "./SysTray"

const icons = [
  "直",
  "",
];

export default function Wifi() {
  const network = Network.get_default();
  const { wifi, wired } = network;
  const primary = bind(network, "primary");

  const ssid = bind(wifi, "ssid");
  const strength = bind(wifi, "strength");

  const wired_speed = bind(wired, "speed");
  const wired_name = bind(wired.device, "interface");

  // const name = bind(wired, "connection").as(c => c.controller.interface);

  const label = Variable.derive([primary], (primary) => {
    switch (primary) {
      case (Network.Primary.UNKNOWN): return "?";
      case (Network.Primary.WIFI): return `${icons[0]}`;
      case (Network.Primary.WIRED): return `${icons[1]}`;
    }
  });

  const tooltip = Variable.derive(
    [primary, ssid, strength, wired_name, wired_speed],
    (primary, ssid, strength, wired_name, wired_speed) => {
      switch (primary) {
        case (Network.Primary.UNKNOWN): return "unknown connection";
        case (Network.Primary.WIFI): return `${ssid}: ${strength}%`;
        case (Network.Primary.WIRED): return `${wired_name}`;
      }
    }
  );


  return (
    <box>
      <label
        tooltipText={bind(tooltip)}
        label={bind(label)}
      />
    </box>
  );
}

