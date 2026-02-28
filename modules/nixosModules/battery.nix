{ ... }:
{

  flake.nixosModules.batteryModule =
    { pkgs, config, ... }:
    {
      systemd.user.services."battery-low" = {
        enable = true;
        description = "Notify user if battery is below 10% and not charging";
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = pkgs.writeShellScript "battery-low-notification" ''
            # Read battery status and capacity
            bat_status=$(cat /sys/class/power_supply/BAT0/status)
            capacity=$(cat /sys/class/power_supply/BAT0/capacity)

            # Check if battery is not charging and capacity is low
            if [[ "$bat_status" != "Charging" ]] && [[ $capacity -lt 10 ]]; then
                ${config.home.homeDirectory}/.local/bin/battery_notification.py
            fi
          '';
        };
      };
      systemd.user.timers."battery-low" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          # Every Minute
          OnCalendar = "*-*-* *:*:00";
          Unit = "battery-low.service";
        };
      };
    };

}
