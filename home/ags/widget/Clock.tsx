
import { Gdk } from "astal/gtk3"
import { bind, Variable } from "astal"
import { SECOND } from "./util";


const time = Variable("").poll(SECOND, "date");

export default function Clock() {
  return <box>
    <label label={bind(time).as(t => `${t.slice(0, 10)}`)} />
  </box>
}
