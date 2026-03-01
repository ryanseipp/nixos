{ ... }:
{
  flake.homeModules.starship =
    { lib, config, ... }:
    {
      options = {
        starship.enable = lib.mkEnableOption "enables starship prompt";
      };

      config = lib.mkIf config.starship.enable {
        programs.starship = {
          enable = true;
          enableBashIntegration = false;
          enableZshIntegration = true;
          enableFishIntegration = false;
          enableIonIntegration = false;
          enableNushellIntegration = false;
          settings = {
            add_newline = false;
            format = lib.concatStrings [
              "$username"
              "$hostname"
              "$localip"
              "$shlvl"
              "$singularity"
              "$kubernetes"
              "$directory"
              "$vcsh"
              "$git_branch"
              "$git_commit"
              "$git_state"
              "$git_metrics"
              "$git_status"
              "$hg_branch"
              "$fill"
              "$docker_context"
              "$package"
              "$c"
              "$cmake"
              "$cobol"
              "$daml"
              "$dart"
              "$deno"
              "$dotnet"
              "$elixir"
              "$elm"
              "$erlang"
              "$golang"
              "$haskell"
              "$helm"
              "$java"
              "$julia"
              "$kotlin"
              "$lua"
              "$nim"
              "$nodejs"
              "$ocaml"
              "$perl"
              "$php"
              "$pulumi"
              "$purescript"
              "$python"
              "$raku"
              "$rlang"
              "$red"
              "$ruby"
              "$rust"
              "$scala"
              "$swift"
              "$terraform"
              "$vlang"
              "$vagrant"
              "$zig"
              "$buf"
              "$nix_shell"
              "$conda"
              "$spack"
              "$memory_usage"
              "$aws"
              "$gcloud"
              "$openstack"
              "$azure"
              "$env_var"
              "$crystal"
              "$custom"
              "$sudo"
              "$cmd_duration"
              "$time"
              "$line_break"
              "$jobs"
              "$battery"
              "$status"
              "$container"
              "$shell"
              "$character"
            ];

            cmd_duration = {
              disabled = false;
            };

            directory = {
              read_only = " ";
              truncate_to_repo = true;
              fish_style_pwd_dir_length = 1;
            };

            git_metrics = {
              disabled = false;
            };

            git_status = {
              conflicted = "=\${count}";
              ahead = "⇡\${count}";
              behind = "⇣\${count}";
              diverged = "⇕\${count}";
              untracked = "?\${count}";
              stashed = "*\${count}";
              modified = "!\${count}";
              staged = "[+\${count}](green)";
              renamed = "»\${count}";
              deleted = "✘\${count}";
            };

            time = {
              disabled = false;
              use_12hr = true;
            };

            aws = {
              symbol = "  ";
            };
            buf = {
              symbol = " ";
            };
            c = {
              symbol = " ";
            };
            conda = {
              symbol = " ";
            };
            dart = {
              symbol = " ";
            };
            docker_context = {
              symbol = " ";
            };
            dotnet = {
              symbol = "󰪮 ";
            };
            elixir = {
              symbol = " ";
            };
            elm = {
              symbol = " ";
            };
            git_branch = {
              symbol = " ";
            };
            golang = {
              symbol = " ";
            };
            haskell = {
              symbol = " ";
            };
            hg_branch = {
              symbol = " ";
            };
            java = {
              symbol = " ";
            };
            julia = {
              symbol = " ";
            };
            memory_usage = {
              symbol = "󰍛 ";
            };
            nim = {
              symbol = " ";
            };
            nix_shell = {
              symbol = " ";
            };
            nodejs = {
              symbol = " ";
            };
            package = {
              symbol = " ";
            };
            python = {
              symbol = " ";
            };
            spack = {
              symbol = "🅢 ";
            };
            rust = {
              symbol = " ";
            };
          };
        };
      };
    };
}
