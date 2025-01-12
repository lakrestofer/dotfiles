import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import AstalNetwork from "gi://AstalNetwork"

const icons = [
  "直",
  "",
];

const network = AstalNetwork.get_default();
export default function Network() {
  const primary = bind(network, "primary");


  return (
    <>
      {primary.as(p => {
        switch (p) {
          case (AstalNetwork.Primary.UNKNOWN): return <Unknown />
          case (AstalNetwork.Primary.WIFI): return <Wifi />
          case (AstalNetwork.Primary.WIRED): return <Wired />
        }
      })}
    </>
  );

}

function Unknown() {
  return (
    <box>
      <label tooltipText="Unknown connection type" label="?" />
    </box>
  )
}

function Wifi() {
  const { wifi } = network;

  if (!wifi) return <Error error={"could not retrieve wifi property"} />

  const ssid = bind(wifi, "ssid");
  const strength = bind(wifi, "strength");

  const tooltip = Variable.derive(
    [ssid, strength],
    (ssid, strength) => `${ssid}: ${strength}%`
  );

  return (
    <box>
      <label
        tooltipText={bind(tooltip)}
        label={icons[0]}
      />
    </box>
  );
}

function Wired() {
  return (
    <box>
      <label
        tooltipText={"wired connection"}
        label={icons[1]}
      />
    </box>
  );
}

function Error({ error }: { error: string }) {
  return (
    <box>
      <label
        tooltip_text={error}
        label="⏼"
      />
    </box>
  );
}
