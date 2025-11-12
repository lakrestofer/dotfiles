{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  # silent boot configuration
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    initrd.verbose = false;
  };

  networking.hostName = "selbeiskami"; # Define your hostname.

  services.tlp.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  environment.systemPackages = with pkgs; [
    kanata
  ];

  services.kanata = {
    enable = true;
    keyboards = {
      thinkpadt14gen2 = {
        extraDefCfg = ''
          concurrent-tap-hold yes
        '';
        config = ''
          (deflocalkeys-linux
            ;; , 59
            ;; . 60
            disp 235
            wlan 246
            noti 452
            phon 453
            noph 454
            favo 164
            \ 51
          )

          (defsrc
                  mute   volu  vold        brdn  brup  disp  wlan  noti  phon  noph  favo
            esc   f1     f2    f3    f4    f5    f6    f7    f8    f9    f10   f11   f12   home  end   ins   del
            grv   1      2     3     4     5     6     7     8     9     0     -     =     bspc                 
            tab   q      w     e     r     t     y     u     i     o     p     [     ]     ret                  
            caps  a      s     d     f     g     h     j     k     l     ;     '     bksl                           
            lsft  lsgt   z     x     c     v     b     n     m     comm  .     /     rsft
            wkup  lctl  lmet   lalt              spc               ralt  ssrq  rctl  pgup  up    pgdn
          		                                                                   left  down  rght
          )

          (defalias
            ecm (tap-hold 200 200 esc lmet)   ;; Escape    when tapped, Control when held
            qwr (layer-switch qwerty)
            col (layer-switch base)
            stab (tap-hold 200 200 tab  (layer-while-held nordic))
            å RA-w
            ö RA-p
            ä RA-q
          )
          (defchordsv2-experimental
                (j k l) ret 20 all-released (qwerty) ;; nei
                (a s) esc 20 all-released (qwerty) ;; nei
          )

          (deflayer base
                  mute  volu  vold        brdn  brup  disp  wlan  noti  phon  noph  @qwr
            esc   f1    f2    f3    f4    f5    f6    f7    f8    f9    f10   f11   f12   home  end   ins   del
            grv   1     2     3     4     5     6     7     8     9     0     -     =     bspc                 
            @stab q     w     f     p     b     j     l     u     y     ;     [     ]     ret                  
            @ecm  a     r     s     t     g     m     n     e     i     o     '     bksl                           
            lsft  z     x     c     d     v     _     k     h     comm  .     /     rsft
            wkup  lmet  lalt  lctl              spc               rctl  lalt  rmet  pgup  up    pgdn
                                                                                    left  down  rght
          )


          (deflayer qwerty
                  mute  volu  vold        brdn  brup  disp  wlan  noti  phon  noph  @col
            esc   f1    f2    f3    f4    f5    f6    f7    f8    f9    f10   f11   f12   home  end   ins   del
            grv   1     2     3     4     5     6     7     8     9     0     -     =     bspc                 
            @stab q     w     e     r     t     y     u     i     o     p     [     ]     ret                  
            @ecm  a     s     d     f     g     h     j     k     l     ;     '     bksl                           
            lsft  \     z     x     c     v     b     n     m     comm  .     /     rsft
            wkup  lmet  lalt  lctl              spc               rctl  lalt  rmet  pgup  up    pgdn
                                                                                    left  down  rght
          )


          (deflayer nordic
                  -     -     -           -     -     -     -     -     -     -     -
            -     -     -     -     -     -     -     -     -     -     -     -     -     -     -     -     -
            -     -     -     -     -     -     -     -     -     -     -     -     -     -                 
            -     -     -     -     -     -     -     -     -     -     -     @å    -     -                  
            -     -     -     -     -     -     -     -     -     -     @ö    @ä    -                           
            -     -     -     -     -     -     -     -     -     -     -     -     -
            -     -     -     -                 -                 -     -     -     -     -     -
                                                                                    -     -     -
          )

        '';
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
      };
    };
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam;
  };
}
