## str to oscode map

the below codeblock contains the mapping from str to oscode used by
kanata

```rust
/// Convert a `&str` to an `OsCode`.
///
/// kmonad's str to key mapping is found here as a reference:
/// https://github.com/kmonad/kmonad/blob/master/src/KMonad/Keyboard/Keycode.hs
///
/// Do your best to keep the str side a maximum character length of 4 so that configuration file
/// can stay clean.
#[rustfmt::skip]
pub fn str_to_oscode(s: &str) -> Option<OsCode> {
    if let Some(osc) = CUSTOM_STRS_TO_OSCODES.lock().get(s) {
        return Some(*osc);
    }
    Some(match s {
        "Backquote" | "grv" | "ˋ" | "˜" => OsCode::KEY_GRAVE,
        "Digit1" | "1" => OsCode::KEY_1,
        "Digit2" | "2" => OsCode::KEY_2,
        "Digit3" | "3" => OsCode::KEY_3,
        "Digit4" | "4" => OsCode::KEY_4,
        "Digit5" | "5" => OsCode::KEY_5,
        "Digit6" | "6" => OsCode::KEY_6,
        "Digit7" | "7" => OsCode::KEY_7,
        "Digit8" | "8" => OsCode::KEY_8,
        "Digit9" | "9" => OsCode::KEY_9,
        "Digit0" | "0" => OsCode::KEY_0,
        "Minus" | "min" | "‐" => OsCode::KEY_MINUS,
        "Equal" | "eql" | "₌" => OsCode::KEY_EQUAL,
        "Backspace" | "bspc" | "bks" | "␈" | "⌫"  => OsCode::KEY_BACKSPACE,
        "Tab" | "tab" | "⭾" | "↹" => OsCode::KEY_TAB,
        "KeyQ" | "q" => OsCode::KEY_Q,
        "KeyW" | "w" => OsCode::KEY_W,
        "KeyE" | "e" => OsCode::KEY_E,
        "KeyR" | "r" => OsCode::KEY_R,
        "KeyT" | "t" => OsCode::KEY_T,
        "KeyY" | "y" => OsCode::KEY_Y,
        "KeyU" | "u" => OsCode::KEY_U,
        "KeyI" | "i" => OsCode::KEY_I,
        "KeyO" | "o" => OsCode::KEY_O,
        "KeyP" | "p" => OsCode::KEY_P,
        "BracketLeft" | "lbrc" | "【" | "「" | "〔" | "⎡" => OsCode::KEY_LEFTBRACE,
        "BracketRight" | "rbrc" | "】" | "」" | "〕" | "⎣" => OsCode::KEY_RIGHTBRACE,
        "CapsLock" | "caps" | "⇪" => OsCode::KEY_CAPSLOCK,
        "KeyA" | "a" => OsCode::KEY_A,
        "KeyS" | "s" => OsCode::KEY_S,
        "KeyD" | "d" => OsCode::KEY_D,
        "KeyF" | "f" => OsCode::KEY_F,
        "KeyG" | "g" => OsCode::KEY_G,
        "KeyH" | "h" => OsCode::KEY_H,
        "KeyJ" | "j" => OsCode::KEY_J,
        "KeyK" | "k" => OsCode::KEY_K,
        "KeyL" | "l" => OsCode::KEY_L,
        "Semicolon" | "scln" | "︔" => OsCode::KEY_SEMICOLON,
        "Quote" | "apo" | "apos" => OsCode::KEY_APOSTROPHE,
        "Enter" | "ret" | "return" | "ent" | "enter" | "⏎" | "↩" | "↵" | "↲" | "⤶" | "⎆" | "⌤" | "␤" => OsCode::KEY_ENTER,
        "ShiftLeft" | "lshift" | "lshft" | "lsft" | "shft" | "sft" | "‹⇧" => OsCode::KEY_LEFTSHIFT,
        "KeyZ" | "z" => OsCode::KEY_Z,
        "KeyX" | "x" => OsCode::KEY_X,
        "KeyC" | "c" => OsCode::KEY_C,
        "KeyV" | "v" => OsCode::KEY_V,
        "KeyB" | "b" => OsCode::KEY_B,
        "KeyN" | "n" => OsCode::KEY_N,
        "KeyM" | "m" => OsCode::KEY_M,
        "Comma" | "comm" | "⸴" => OsCode::KEY_COMMA,
        "Period" | "．" => OsCode::KEY_DOT,
        "Slash" | "⁄" => OsCode::KEY_SLASH,
        "Backslash" | "bksl" | "⧵" | "＼" =>  OsCode::KEY_BACKSLASH,
        "kp=" | "clr" => OsCode::KEY_CLEAR,
        // The kp<etc> keys are also known as the numpad keys. E.g. below is numpad enter.
        "Numpad0" | "kp0" | "🔢₀" => OsCode::KEY_KP0,
        "Numpad1" | "kp1" | "🔢₁" => OsCode::KEY_KP1,
        "Numpad2" | "kp2" | "🔢₂" => OsCode::KEY_KP2,
        "Numpad3" | "kp3" | "🔢₃" => OsCode::KEY_KP3,
        "Numpad4" | "kp4" | "🔢₄" => OsCode::KEY_KP4,
        "Numpad5" | "kp5" | "🔢₅" => OsCode::KEY_KP5,
        "Numpad6" | "kp6" | "🔢₆" => OsCode::KEY_KP6,
        "Numpad7" | "kp7" | "🔢₇" => OsCode::KEY_KP7,
        "Numpad8" | "kp8" | "🔢₈" => OsCode::KEY_KP8,
        "Numpad9" | "kp9" | "🔢₉" => OsCode::KEY_KP9,
        "NumpadEnter" | "kprt" | "🔢⏎" | "🔢↩" | "🔢↵" | "🔢↲" | "🔢⤶" | "🔢⎆" | "🔢⌤" | "🔢␤" => OsCode::KEY_KPENTER,
        "NumpadDivide" | "kp/" | "🔢⁄" => OsCode::KEY_KPSLASH,
        "NumpadAdd" | "kp+" | "🔢₊" => OsCode::KEY_KPPLUS,
        "NumpadMultiply" | "kp*" | "🔢∗" => OsCode::KEY_KPASTERISK,
        "NumpadEqual" | "🔢₌" => OsCode::KEY_KPEQUAL,
        "NumpadSubtract" | "kp-" | "🔢₋" => OsCode::KEY_KPMINUS,
        "NumpadDecimal" | "kp." | "🔢．" => OsCode::KEY_KPDOT,
        "NumpadComma" | "kp," | "🔢⸴" =>OsCode::KEY_KPCOMMA,
        "ssrq" | "sys" => OsCode::KEY_SYSRQ,
        // Typically the Non-US backslash, near the left shift key
        "IntlBackslash" | "102d" | "lsgt" | "nubs" | "nonusbslash" | "﹨" | "<" => OsCode::KEY_102ND,
        "ScrollLock" | "scrlck" | "slck" | "⇳🔒" => OsCode::KEY_SCROLLLOCK,
        "Pause" | "pause" | "break" | "brk" => OsCode::KEY_PAUSE,
        "WakeUp" | "wkup" => OsCode::KEY_WAKEUP,
        "Escape" | "esc" | "⎋" => OsCode::KEY_ESC,
        "ShiftRight" | "RightShift" | "rshift" | "rshft" | "rsft" | "⇧›" => OsCode::KEY_RIGHTSHIFT,
        "ControlLeft" | "lctrl" | "lctl" | "ctl" | "‹⎈" | "‹⌃" => OsCode::KEY_LEFTCTRL,
        "AltLeft" | "lalt" | "alt" | "‹⎇" | "‹⌥" => OsCode::KEY_LEFTALT,
        "Space" | "spc" | "␠" | "␣" => OsCode::KEY_SPACE,
        "AltRight" | "ralt" | "altgr" | "⎇›" | "⌥›" | "⇮" => OsCode::KEY_RIGHTALT,
        "ContextMenu" | "comp" | "cmps" | "cmp" | "menu" | "apps" | "▤" | "☰" | "𝌆" => OsCode::KEY_COMPOSE,
        "🎛" => OsCode::KEY_DASHBOARD,
        // Also known as Windows, GUI, Comand, Super
        "MetaLeft" | "lmeta" | "lmet" | "met" | "‹◆" | "‹⌘" | "‹❖" | "‹⊞" => OsCode::KEY_LEFTMETA,
        "MetaRight" | "rmeta" | "rmet" | "◆›" | "⌘›" | "❖›" | "⊞›" => OsCode::KEY_RIGHTMETA,
        "ControlRight" | "rctrl" | "rctl" | "⎈›" | "⌃›" => OsCode::KEY_RIGHTCTRL,
        "Delete" | "del" | "␡" | "⌦" => OsCode::KEY_DELETE,
        "Insert" | "ins" | "⎀" => OsCode::KEY_INSERT,
        "BrowserBack" | "bck" => OsCode::KEY_BACK,
        "BrowserForward" | "fwd" => OsCode::KEY_FORWARD,
        "PageUp" | "pgup" | "⇞" | "⎗" => OsCode::KEY_PAGEUP,
        "PageDown" | "pgdn" | "⇟" | "⎘" => OsCode::KEY_PAGEDOWN,
        "ArrowUp" | "up" | "▲" | "↑" => OsCode::KEY_UP,
        "ArrowDown" | "down" | "▼" | "↓" => OsCode::KEY_DOWN,
        "ArrowLeft" | "lft" | "left" | "◀" | "←" => OsCode::KEY_LEFT,
        "ArrowRight" | "rght" | "▶" | "→" => OsCode::KEY_RIGHT,
        "Home" | "home" | "⇤" | "⤒" | "↖" | "⇱" => OsCode::KEY_HOME,
        "End" | "end" | "⇥" | "⤓" | "↘" | "⇲" => OsCode::KEY_END,
        "NumLock" | "nlck" | "nlk" | "⇭"=> OsCode::KEY_NUMLOCK,
        "VolumeMute" | "mute"  | "🔇" | "🔈⓪" | "🔈⓿" | "🔈₀" => OsCode::KEY_MUTE,
        "VolumeUp" | "volu" | "🔊" | "🔈+" | "🔈➕" | "🔈₊" | "🔈⊕" => OsCode::KEY_VOLUMEUP,
        "VolumeDown" | "voldwn" | "vold" | "🔉" | "🔈−" | "🔈➖" | "🔈₋" | "🔈⊖" => OsCode::KEY_VOLUMEDOWN,
        "brup" | "bru" | "🔆" => OsCode::KEY_BRIGHTNESSUP,
        "brdown" | "brdwn" | "brdn" | "🔅" => OsCode::KEY_BRIGHTNESSDOWN,
        "blup" | "⌨💡+" | "⌨💡➕" | "⌨💡₊" | "⌨💡⊕" => OsCode::KEY_KBDILLUMUP,
        "bldn" | "⌨💡−" | "⌨💡➖" | "⌨💡₋" | "⌨💡⊖" => OsCode::KEY_KBDILLUMDOWN,
        "MediaTrackNext" | "next" | "▶▶" => OsCode::KEY_NEXTSONG,
        "MediaPlayPause" | "pp" | "▶⏸" => OsCode::KEY_PLAYPAUSE,
        "MediaTrackPrevious" | "prev" | "◀◀" => OsCode::KEY_PREVIOUSSONG,
        "F1" | "f1" => OsCode::KEY_F1,
        "F2" | "f2" => OsCode::KEY_F2,
        "F3" | "f3" => OsCode::KEY_F3,
        "F4" | "f4" => OsCode::KEY_F4,
        "F5" | "f5" => OsCode::KEY_F5,
        "F6" | "f6" => OsCode::KEY_F6,
        "F7" | "f7" => OsCode::KEY_F7,
        "F8" | "f8" => OsCode::KEY_F8,
        "F9" | "f9" => OsCode::KEY_F9,
        "F10" | "f10" => OsCode::KEY_F10,
        "F11" | "f11" => OsCode::KEY_F11,
        "F12" | "f12" => OsCode::KEY_F12,
        "F13" | "f13" => OsCode::KEY_F13,
        "F14" | "f14" => OsCode::KEY_F14,
        "F15" | "f15" => OsCode::KEY_F15,
        "F16" | "f16" => OsCode::KEY_F16,
        "F17" | "f17" => OsCode::KEY_F17,
        "F18" | "f18" => OsCode::KEY_F18,
        "F19" | "f19" => OsCode::KEY_F19,
        "F20" | "f20" => OsCode::KEY_F20,
        "F21" | "f21" => OsCode::KEY_F21,
        "F22" | "f22" => OsCode::KEY_F22,
        "F23" | "f23" => OsCode::KEY_F23,
        "F24" | "f24" => OsCode::KEY_F24,
        #[cfg(any(target_os = "macos", target_os = "unknown"))]
        "fn" | "🌐" | "ƒ" | "ⓕ" | "Ⓕ" | "🄵" | "🅕" | "🅵" => OsCode::KEY_FN,
        #[cfg(target_os = "windows")]
        "kana" | "katakana" | "katakanahiragana" => OsCode::KEY_HANGEUL,
        #[cfg(any(target_os = "linux", target_os = "unknown"))]
        "kana" | "katakanahiragana" => OsCode::KEY_KATAKANAHIRAGANA,
        #[cfg(any(target_os = "linux", target_os = "unknown"))]
        "hiragana" => OsCode::KEY_HIRAGANA,
        #[cfg(any(target_os = "linux", target_os = "unknown"))]
        "katakana" => OsCode::KEY_KATAKANA,
        "cnv" | "conv" | "henk" | "hnk" | "henkan" => OsCode::KEY_HENKAN,
        "ncnv" | "mhnk" | "muhenkan" => OsCode::KEY_MUHENKAN,
        "IntlRo" | "ro" => OsCode::KEY_RO,
        #[cfg(any(target_os = "macos", target_os = "unknown"))]
        "Lang1" | "kana" => OsCode::KEY_HANGEUL,
        #[cfg(any(target_os = "macos", target_os = "unknown"))]
        "Lang2" | "eisu" => OsCode::KEY_HANJA,

        #[cfg(any(target_os = "linux", target_os = "unknown"))]
        "PrintScreen" | "prtsc" | "prnt" | "⎙" => OsCode::KEY_SYSRQ,
        #[cfg(target_os = "windows")]
        "PrintScreen" | "prtsc" | "prnt" | "⎙" => OsCode::KEY_PRINT,

        // NOTE: these are linux and interception-only due to missing implementation for LLHOOK.
        "mlft" | "mouseleft" | "🖰1" | "‹🖰" => OsCode::BTN_LEFT,
        "mrgt" | "mouseright" | "🖰2" | "🖰›" => OsCode::BTN_RIGHT,
        "mmid" | "mousemid" | "🖰3" => OsCode::BTN_MIDDLE,
        "mbck" | "mousebackward" | "🖰4" => OsCode::BTN_SIDE,
        "mfwd" | "mouseforward" | "🖰5" => OsCode::BTN_EXTRA,
        "mwu" | "mousewheelup" => OsCode::MouseWheelUp,
        "mwd" | "mousewheeldown" => OsCode::MouseWheelDown,
        "mwl" | "mousewheelleft" => OsCode::MouseWheelLeft,
        "mwr" | "mousewheelright" => OsCode::MouseWheelRight,

        "hmpg" | "homepage" => OsCode::KEY_HOMEPAGE,
        "mdia" | "media" => OsCode::KEY_MEDIA,
        "LaunchMail" | "mail" => OsCode::KEY_MAIL,
        "email" => OsCode::KEY_EMAIL,
        "calc" => OsCode::KEY_CALC,

        // NOTE: these are linux-only right now due to missing the mappings in windows.rs
        #[cfg(any(target_os = "linux", target_os = "unknown"))]
        "plyr" | "player" => OsCode::KEY_PLAYER,
        #[cfg(any(target_os = "linux", target_os = "unknown"))]
        "powr" | "power" => OsCode::KEY_POWER,
        #[cfg(any(target_os = "linux", target_os = "unknown"))]
        "zzz" | "sleep" => OsCode::KEY_SLEEP,

        "sls" | "SpotLightSearch" => OsCode::KEY_249,
        "dtn" | "Dictation" => OsCode::KEY_250,
        "dnd" | "DoNotDisturb" => OsCode::KEY_251,
        "mctl" | "MissionControl" => OsCode::KEY_252,
        "lpad" | "LaunchPad" => OsCode::KEY_253,
        
        // Keys that behave as no-ops but can be used in sequences.
        // Also see: POTENTIAL PROBLEM - G-keys
        "nop0" => OsCode::KEY_676,
        "nop1" => OsCode::KEY_677,
        "nop2" => OsCode::KEY_678,
        "nop3" => OsCode::KEY_679,
        "nop4" => OsCode::KEY_680,
        "nop5" => OsCode::KEY_681,
        "nop6" => OsCode::KEY_682,
        "nop7" => OsCode::KEY_683,
        "nop8" => OsCode::KEY_684,
        "nop9" => OsCode::KEY_685,

        // has no output mapping. only intended to be used in the input
        // position, in conjunction with `mouse-movement-key mvmt`
        "mvmt" | "mousemovement" | "🖰mv" => OsCode::KEY_766,

        _ => return None,
    })
}

fn add_default_str_osc_mappings(mapping: &mut HashMap<String, OsCode>) {
    const DEFAULT_MAPPINGS: &[(&str, OsCode)] = &[
        ("+", OsCode::KEY_KPPLUS),
        ("[", OsCode::KEY_LEFTBRACE),
        ("]", OsCode::KEY_RIGHTBRACE),
        ("{", OsCode::KEY_LEFTBRACE),
        ("}", OsCode::KEY_RIGHTBRACE),
        ("/", OsCode::KEY_SLASH),
        (";", OsCode::KEY_SEMICOLON),
        ("`", OsCode::KEY_GRAVE),
        ("=", OsCode::KEY_EQUAL),
        ("-", OsCode::KEY_MINUS),
        ("'", OsCode::KEY_APOSTROPHE),
        (",", OsCode::KEY_COMMA),
        (".", OsCode::KEY_DOT),
        ("\\", OsCode::KEY_BACKSLASH),
        // Mapped as backslash because in some locales/fonts, yen=backslash
        ("yen", OsCode::KEY_BACKSLASH),
        // Unicode yen is probably the yen key, so map this to a separate oscode by default.
        ("¥", OsCode::KEY_YEN),
        ("right", OsCode::KEY_RIGHT),
        ("grave", OsCode::KEY_GRAVE),
    ];
    for dm in DEFAULT_MAPPINGS {
        mapping.entry(dm.0.into()).or_insert(dm.1);
    }
}
```
