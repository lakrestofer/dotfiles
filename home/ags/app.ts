import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"

App.start({
  css: style,
  instanceName: "js",
  main: () => App.get_monitors().map(Bar),
})