import { bind } from "astal"
import Hyprland from "gi://AstalHyprland"

const icon = ["ⅰ", "ⅱ", "ⅲ", "ⅳ", "ⅴ", "ⅵ", "ⅶ", "ⅷ", "ⅸ", "ⅹ", "ⅺ", "ⅻ"];

export function Workspaces() {
  const hypr = Hyprland.get_default();
  const wss = bind(hypr, "workspaces");
  const fws = bind(hypr, "focusedWorkspace");

  return <box className="Workspaces">
    {wss.as(wss => wss
      .sort((a, b) => a.id - b.id)
      .map((ws: Hyprland.Workspace) => (
        <button
          className={fws.as(fw => (ws.id === fw.id) ? "focused" : "")}
          onClicked={() => ws.focus()}
          tooltipText={ws.name}
        >
          {
            icon[ws.id - 1] ||
            (ws.name === "special:special" && "ひで") ||
            ws.id
          }
        </button>
      ))
    )}
  </box>
}

export function FocusedClient() {
  const hypr = Hyprland.get_default()
  const focused = bind(hypr, "focusedClient")

  return <box
    className="Focused"
    visible={focused.as(Boolean)}>
    {focused.as(client => (
      client && <label label={bind(client, "title").as(s => (s.length > 20) ? `${s.slice(0, 20)}...` : s)} />
    ))}
  </box>
}
