{ boot, virtualisation, ... }:

{
  imports = [ ];

  virtualisation.lxd.enable = true;
  virtualisation.lxc.lxcfs.enable = true;

  # Kernel modules needed to run k8s on LXD
                        
  boot.kernelModules = [ "ip_tables" "ip6_tables" "nf_nat" "overlay" "br_netfilter" "netlink_diag" "ip_vs" "ip_vs_rr" "ip_vs_wrr" "ip_vs_sh" ];

  # Taken from the lxd.recommendedSysctlSettings
  boot.kernel.sysctl = {
    "fs.inotify.max_queued_events" = 1048576;
    "fs.inotify.max_user_instances" = 1048576;
    "fs.inotify.max_user_watches" = 1048576;
    "vm.max_map_count" = 262144;
    "kernel.dmesg_restrict" = 1;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv6.neigh.default.gc_thresh3" = 8192;
    "kernel.keys.maxkeys" = 2000;
  };
}
