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
  const { wifi } = network;
  const primary = bind(network, "primary");

  const ssid = bind(wifi, "ssid");
  const strength = bind(wifi, "strength");

  // const name = bind(wired, "connection").as(c => c.controller.interface);

  const label = Variable.derive([primary], (primary) => {
    switch (primary) {
      case (Network.Primary.UNKNOWN): return "?";
      case (Network.Primary.WIFI): return `${icons[0]}`;
      case (Network.Primary.WIRED): return `${icons[1]}`;
    }
  });

  const tooltip = Variable.derive(
    [primary, ssid, strength],
    (primary, ssid, strength) => {
      switch (primary) {
        case (Network.Primary.UNKNOWN): return "unknown connection";
        case (Network.Primary.WIFI): return `${ssid}: ${strength}%`;
        case (Network.Primary.WIRED): return "wired";
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

