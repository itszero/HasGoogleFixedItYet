{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    literalExpression
    optional
    types
    ;

  cfg = config.services.hgfiy;
  systemPackages = self.packages.${pkgs.stdenv.hostPlatform.system};

  # DB env vars assembled from the module options. The environmentFile, if
  # provided, is applied on top by systemd, so secrets like DATABASE_PASS or
  # TRANSLATE_API_KEY belong there — never inline.
  dbEnvironment = lib.filterAttrs (_: v: v != null) {
    DATABASE_URL = cfg.database.url;
    DATABASE_HOST = cfg.database.host;
    DATABASE_NAME = cfg.database.name;
    DATABASE_USER = cfg.database.user;
  };

  hardening = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    NoNewPrivileges = true;
    StateDirectory = "hgfiy";
    WorkingDirectory = "/var/lib/hgfiy";
  };
in
{
  options.services.hgfiy = {
    enable = mkEnableOption "Has Google Fixed It Yet (hgfiy) server";

    package = mkOption {
      type = types.package;
      default = systemPackages.hgfiy;
      defaultText = literalExpression "hgfiy.packages.\${system}.hgfiy";
      description = "The hgfiy server package to run.";
    };

    updatePackage = mkOption {
      type = types.package;
      default = systemPackages.hgify-update;
      defaultText = literalExpression "hgfiy.packages.\${system}.hgify-update";
      description = "The hgify-update package to run on the timer.";
    };

    user = mkOption {
      type = types.str;
      default = "hgfiy";
      description = "User account under which hgfiy runs.";
    };

    group = mkOption {
      type = types.str;
      default = "hgfiy";
      description = "Group under which hgfiy runs.";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Bind address passed to thin.";
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "Port passed to thin.";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/hgfiy.env";
      description = ''
        Path to a file loaded via systemd `EnvironmentFile=`. Use this for
        secrets such as `DATABASE_PASS` or `TRANSLATE_API_KEY`. Variables
        defined here override the options below.
      '';
    };

    database = {
      url = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "postgres://hgfiy@localhost/hgfiy";
        description = ''
          Sets `DATABASE_URL`. Takes precedence over the host/name/user
          options. For credentials, prefer {option}`environmentFile`.
        '';
      };
      host = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "localhost";
        description = "Sets `DATABASE_HOST`.";
      };
      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "hgfiy";
        description = "Sets `DATABASE_NAME`.";
      };
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "hgfiy";
        description = "Sets `DATABASE_USER`.";
      };
    };

    update = {
      enable = mkEnableOption "the hgify-update systemd timer";

      onCalendar = mkOption {
        type = types.str;
        default = "daily";
        example = "*-*-* 03:00:00";
        description = ''
          systemd `OnCalendar=` expression controlling when the update job
          fires. See {manpage}`systemd.time(7)`.
        '';
      };

      persistent = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to run the update job at next boot if its scheduled time was
          missed while the system was off (systemd `Persistent=`).
        '';
      };

      randomizedDelaySec = mkOption {
        type = types.str;
        default = "0";
        example = "15m";
        description = "systemd `RandomizedDelaySec=` for the update timer.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = lib.mkIf (cfg.user == "hgfiy") {
      isSystemUser = true;
      group = cfg.group;
      description = "hgfiy service user";
    };

    users.groups.${cfg.group} = lib.mkIf (cfg.group == "hgfiy") { };

    systemd.services.hgfiy = {
      description = "Has Google Fixed It Yet server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = dbEnvironment;

      serviceConfig = hardening // {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/hgfiy --address ${cfg.address} --port ${toString cfg.port}";
        Restart = "on-failure";
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };

    systemd.services.hgfiy-update = mkIf cfg.update.enable {
      description = "Has Google Fixed It Yet — refresh Google Translate snapshots";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment = dbEnvironment;

      serviceConfig = hardening // {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.updatePackage}/bin/hgify-update";
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };

    systemd.timers.hgfiy-update = mkIf cfg.update.enable {
      description = "Periodic hgify-update";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.update.onCalendar;
        Persistent = cfg.update.persistent;
        RandomizedDelaySec = cfg.update.randomizedDelaySec;
        Unit = "hgfiy-update.service";
      };
    };
  };
}
