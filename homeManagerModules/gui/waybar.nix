{ lib, config, ... }: {
  options = { waybar.enable = lib.mkEnableOption "enables waybar"; };
  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 24;
          margin-top = 8;
          margin-bottom = -8;
          margin-left = 16;
          margin-right = 16;
          mode = "dock";
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "custom/media"
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "clock"
            "tray"
          ];
          "hyprland/workspaces" = { format = "{name}"; };
          mpd = {
            format =
              "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
            format-disconnected = "Disconnected ";
            format-stopped =
              "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            unknown-tag = "N/A";
            interval = 2;
            consume-icons = { on = " "; };
            random-icons = {
              off = ''<span color="#f53c3c"></span> '';
              on = " ";
            };
            repeat-icons = { on = " "; };
            single-icons = { on = "1 "; };
            state-icons = {
              paused = "";
              playing = "";
            };
            tooltip-format = "MPD (connected)";
            tooltip-format-disconnected = "MPD (disconnected)";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          tray = {
            # icon-size = 21;
            spacing = 10;
          };
          clock = {
            format = "{:%a %b %d, %I:%M %p}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            format-alt = "{:%Y-%m-%d}";
            tooltip = false;
          };
          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          memory = { format = "{}% "; };
          temperature = {
            # thermal-zone = 2;
            # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
            critical-threshold = 80;
            # format-critical = "{temperatureC}°C {icon}";
            format = "{temperatureC}°C {icon}";
            format-icons = [ "" "" "" ];
          };
          network = {
            # interface = "wlp2*"; // (Optional) To force the use of this interface
            format-wifi = "{essid} ({signalStrength}%) 󰖩";
            format-ethernet = "{ipaddr}/{cidr} 󰈀";
            format-linked = "{ifname} (No IP) 󱚵";
            format-disconnected = "Disconnected 󰖪";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          pulseaudio = {
            # scroll-step = 1; // %, can be a float
            format = "{volume}% {icon}   {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰝟 {icon} {format_source}";
            format-muted = "󰝟 {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "󰋋";
              headset = "󰋎";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };
          "custom/media" = {
            format = "{icon} {}";
            return-type = "json";
            max-length = 40;
            format-icons = {
              spotify = "";
              default = "🎜";
            };
            escape = true;
            exec =
              "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # Script in resources folder
          };
        };
      };

      style = ''
              @define-color base   #1e1e2e;
              @define-color mantle #181825;
              @define-color crust  #11111b;

              @define-color text     #cdd6f4;
              @define-color subtext0 #a6adc8;
              @define-color subtext1 #bac2de;

              @define-color surface0 #313244;
              @define-color surface1 #45475a;
              @define-color surface2 #585b70;

              @define-color overlay0 #6c7086;
              @define-color overlay1 #7f849c;
              @define-color overlay2 #9399b2;

              @define-color blue      #89b4fa;
              @define-color lavender  #b4befe;
              @define-color sapphire  #74c7ec;
              @define-color sky       #89dceb;
              @define-color teal      #94e2d5;
              @define-color green     #a6e3a1;
              @define-color yellow    #f9e2af;
              @define-color peach     #fab387;
              @define-color maroon    #eba0ac;
              @define-color red       #f38ba8;
              @define-color mauve     #cba6f7;
              @define-color pink      #f5c2e7;
              @define-color flamingo  #f2cdcd;
              @define-color rosewater #f5e0dc;

              * {
        	border: none;
        	font-family: "Iosevka Nerd Font";
        	font-weight: bold;
        	font-size: 12px;
        	min-height: 0;
        	border-radius: 4px;
              }

              window#waybar {
        	background: alpha(@base, 0.914);
        	color: @text;
        	border-width: 1px;
        	border-color: @blue;
        	border-style: solid;
        	border-radius: 8px;
              }

              tooltip {
        	background: @base;
        	opacity: 0.8;
        	border-radius: 4px;
        	border-width: 2px;
        	border-style: solid;
        	border-color: @blue;
              }

              tooltip label {
        	color: @text;
              }

              .modules-left {
        	margin-left: 4px;
              }

              .modules-right {
        	margin-right: 4px;
              }

              #workspaces button {
        	padding: 5px;
        	color: @surface2;
        	margin-right: 5px;
              }

              #workspaces button.active {
        	color: @text;
              }

              #workspaces button.focused {
        	color: @text;
        	border-radius: 4px;
              }

              #workspaces button.urgent {
        	color: @overlay0;
        	background: @lavender;
        	border-radius: 4px;
              }

              #workspaces button:hover {
        	background: @surface1;
        	color: @subtext0;
        	border-radius: 4px;
              }

              #custom-launch_wofi,
              #custom-lock_screen,
              #custom-light_dark,
              #custom-power_btm,
              #custom-power_profile,
              #custom-weather,
              #window,
              #cpu,
              #disk,
              #custom-updates,
              #memory,
              #clock,
              #battery,
              #pulseaudio,
              #network,
              #tray,
              #temperature,
              #workspaces,
              #backlight,
              #language {
        	padding: 0px 10px;
        	margin: 3px 0px;
        	border: 0px;
              }

              #tray,
              #custom-lock_screen,
              #temperature,
              #backlight,
              #custom-launch_wofi,
              #cpu {
        	border-radius: 4px 0px 0px 4px;
              }

              #custom-light_dark,
              #custom-power_btn,
              #workspaces,
              #pulseaudio.microphone,
              #battery,
              #disk {
        	border-radius: 0px 4px 4px 0px;
        	margin-right: 10px;
              }

              #temperature.critical {
        	color: #e92d4d;
              }

              #workspaces {
        	padding-right: 0px;
        	padding-left: 5px;
              }

              #custom-power_profile {
        	border-left: 0px;
        	border-right: 0px;
              }

              #window {
        	border-radius: 4px;
        	margin-left: 20px;
        	margin-right: 20px;
              }

              #custom-launch_wofi {
        	margin-left: 10px;
        	border-right: 20px;
              }

              #pulseaudio {
        	border-left: 0px;
        	border-right: 0px;
              }

              #battery,
              #temperature {
        	border-left: 0px;
              }
              #disk {
        	margin-right: 0px;
        	margin-left: 0px;
              }
              #clock {
        	margin-right: 5px;
              }

              #pulseaudio,
              #backlight {
        	color: #89dceb;
              }

              #custom-power_btn {
        	margin-left: 20px;
        	margin-right: 20px;
              }
              #tray > .passive,
              #tray > .active {
        	color: #cdd6f4;
              }
      '';
    };

    home.file.".config/waybar/mediaplayer.py" = {
      enable = true;
      executable = true;
      text = ''
              #!/usr/bin/env python3
              import gi
              gi.require_version("Playerctl", "2.0")
              from gi.repository import Playerctl, GLib
              from gi.repository.Playerctl import Player
              import argparse
              import logging
              import sys
              import signal
              import gi
              import json
              import os
              from typing import List

              logger = logging.getLogger(__name__)

              def signal_handler(sig, frame):
        	  logger.info("Received signal to stop, exiting")
        	  sys.stdout.write("\n")
        	  sys.stdout.flush()
        	  # loop.quit()
        	  sys.exit(0)


              class PlayerManager:
        	  def __init__(self, selected_player=None):
        	      self.manager = Playerctl.PlayerManager()
        	      self.loop = GLib.MainLoop()
        	      self.manager.connect(
        		  "name-appeared", lambda *args: self.on_player_appeared(*args))
        	      self.manager.connect(
        		  "player-vanished", lambda *args: self.on_player_vanished(*args))

        	      signal.signal(signal.SIGINT, signal_handler)
        	      signal.signal(signal.SIGTERM, signal_handler)
        	      signal.signal(signal.SIGPIPE, signal.SIG_DFL)
        	      self.selected_player = selected_player

        	      self.init_players()

        	  def init_players(self):
        	      for player in self.manager.props.player_names:
        		  if self.selected_player is not None and self.selected_player != player.name:
        		      logger.debug(f"{player.name} is not the filtered player, skipping it")
        		      continue
        		  self.init_player(player)

        	  def run(self):
        	      logger.info("Starting main loop")
        	      self.loop.run()

        	  def init_player(self, player):
        	      logger.info(f"Initialize new player: {player.name}")
        	      player = Playerctl.Player.new_from_name(player)
        	      player.connect("playback-status",
        			     self.on_playback_status_changed, None)
        	      player.connect("metadata", self.on_metadata_changed, None)
        	      self.manager.manage_player(player)
        	      self.on_metadata_changed(player, player.props.metadata)

        	  def get_players(self) -> List[Player]:
        	      return self.manager.props.players

        	  def write_output(self, text, player):
        	      logger.debug(f"Writing output: {text}")

        	      output = {"text": text,
        			"class": "custom-" + player.props.player_name,
        			"alt": player.props.player_name}

        	      sys.stdout.write(json.dumps(output) + "\n")
        	      sys.stdout.flush()

        	  def clear_output(self):
        	      sys.stdout.write("\n")
        	      sys.stdout.flush()

        	  def on_playback_status_changed(self, player, status, _=None):
        	      logger.debug(f"Playback status changed for player {player.props.player_name}: {status}")
        	      self.on_metadata_changed(player, player.props.metadata)

        	  def get_first_playing_player(self):
        	      players = self.get_players()
        	      logger.debug(f"Getting first playing player from {len(players)} players")
        	      if len(players) > 0:
        		  # if any are playing, show the first one that is playing
        		  # reverse order, so that the most recently added ones are preferred
        		  for player in players[::-1]:
        		      if player.props.status == "Playing":
        			  return player
        		  # if none are playing, show the first one
        		  return players[0]
        	      else:
        		  logger.debug("No players found")
        		  return None

        	  def show_most_important_player(self):
        	      logger.debug("Showing most important player")
        	      # show the currently playing player
        	      # or else show the first paused player
        	      # or else show nothing
        	      current_player = self.get_first_playing_player()
        	      if current_player is not None:
        		  self.on_metadata_changed(current_player, current_player.props.metadata)
        	      else:    
        		  self.clear_output()

        	  def on_metadata_changed(self, player, metadata, _=None):
        	      logger.debug(f"Metadata changed for player {player.props.player_name}")
        	      player_name = player.props.player_name
        	      artist = player.get_artist()
        	      title = player.get_title()

        	      track_info = ""
        	      if player_name == "spotify" and "mpris:trackid" in metadata.keys() and ":ad:" in player.props.metadata["mpris:trackid"]:
        		  track_info = "Advertisement"
        	      elif artist is not None and title is not None:
        		  track_info = f"{artist} - {title}"
        	      else:
        		  track_info = title

        	      if track_info:
        		  if player.props.status == "Playing":
        		      track_info = "  " + track_info
        		  else:
        		      track_info = "  " + track_info
        	      # only print output if no other player is playing
        	      current_playing = self.get_first_playing_player()
        	      if current_playing is None or current_playing.props.player_name == player.props.player_name:
        		  self.write_output(track_info, player)
        	      else:
        		  logger.debug(f"Other player {current_playing.props.player_name} is playing, skipping")

        	  def on_player_appeared(self, _, player):
        	      logger.info(f"Player has appeared: {player.name}")
        	      if player is not None and (self.selected_player is None or player.name == self.selected_player):
        		  self.init_player(player)
        	      else:
        		  logger.debug(
        		      "New player appeared, but it's not the selected player, skipping")

        	  def on_player_vanished(self, _, player):
        	      logger.info(f"Player {player.props.player_name} has vanished")
        	      self.show_most_important_player()

              def parse_arguments():
        	  parser = argparse.ArgumentParser()

        	  # Increase verbosity with every occurrence of -v
        	  parser.add_argument("-v", "--verbose", action="count", default=0)

        	  # Define for which player we"re listening
        	  parser.add_argument("--player")

        	  parser.add_argument("--enable-logging", action="store_true")

        	  return parser.parse_args()


              def main():
        	  arguments = parse_arguments()

        	  # Initialize logging
        	  if arguments.enable_logging:
        	      logfile = os.path.join(os.path.dirname(
        		  os.path.realpath(__file__)), "media-player.log")
        	      logging.basicConfig(filename=logfile, level=logging.DEBUG,
        				  format="%(asctime)s %(name)s %(levelname)s:%(lineno)d %(message)s")

        	  # Logging is set by default to WARN and higher.
        	  # With every occurrence of -v it's lowered by one
        	  logger.setLevel(max((3 - arguments.verbose) * 10, 0))

        	  logger.info("Creating player manager")
        	  if arguments.player:
        	      logger.info(f"Filtering for player: {arguments.player}")
        	  player = PlayerManager(arguments.player)
        	  player.run()


              if __name__ == "__main__":
        	  main()
      '';
    };
  };
}
