{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.k8s_haproxy;
  backendsCollect = concatStringsSep "\n" (imap0
    (i: v: ''
    server ${toString v} port 6443
    '') (cfg.backends));
in {
  options.services.k8s_haproxy = {
    enable = mkEnableOption (lib.mdDoc "k8s haproxy");
    backends = mkOption {
      type = types.listOf types.str;
    };
  };
  config = mkIf cfg.enable {
    services.haproxy.enable = true;
    services.haproxy.config = ''
global
    daemon
    hard-stop-after             60s
    no strict-limits
    tune.ssl.default-dh-param   2048
    spread-checks               2
    tune.bufsize                16384
    tune.lua.maxmem             0

defaults
    log     global
    timeout client 30s
    timeout connect 30s
    timeout server 30s
    retries 3
    default-server init-addr last,libc

# Frontend: k8s-frontend ()
frontend k8s-frontend
    bind 0.0.0.0:6443
    mode tcp
    default_backend k8s-api

# Backend: k8s-api ()
backend k8s-api
    option log-health-checks
    # health check: k8s-endpoint
    mode tcp
    balance roundrobin
    # stickiness
    stick-table type ip size 50k expire 30m
    stick on src
    # tuning options
    timeout connect 3s
    retries 10
${backendsCollect}
'';

};
}
