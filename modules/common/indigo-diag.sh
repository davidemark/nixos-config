#!/bin/bash
# indigo-diag: diagnostica di sola lettura di un host, per il bot Indigo (/diagnostics).
# Si installa come /usr/local/sbin/indigo-diag (root, 755) e si usa come comando forzato in authorized_keys:
#   from="192.168.1.13",command="/usr/local/sbin/indigo-diag",restrict ssh-ed25519 ... davidemark@indigo-diag
# Non accetta argomenti e ignora SSH_ORIGINAL_COMMAND. Non scrive niente, non riavvia niente. Stampa righe chiave=valore;
# una chiave che non si riesce a leggere si omette (il bot la mostra come n/d). Formato in indigo/diag.go.
export LC_ALL=C PATH=/run/current-system/sw/bin:/usr/sbin:/usr/bin:/sbin:/bin
unset SSH_ORIGINAL_COMMAND

# Tiene solo caratteri sicuri (nomi di unita', container, sessioni) e al massimo 5 nomi, separati da virgole.
names() { tr -c 'A-Za-z0-9_.:,\n-' '_' | head -n 5 | paste -sd, -; }

echo "uptime_s=$(cut -d. -f1 /proc/uptime)"
echo "load1=$(cut -d' ' -f1 /proc/loadavg) cores=$(nproc)"
awk '/^MemTotal/{t=$2} /^MemAvailable/{a=$2} END{if(t>0) printf "mem_used_percent=%.1f\n",(t-a)*100/t}' /proc/meminfo
awk '/^SwapTotal/{t=$2} /^SwapFree/{f=$2} END{printf "swap_used_percent=%.1f\n",(t>0)?(t-f)*100/t:0}' /proc/meminfo
d=$(df --output=pcent / 2>/dev/null | tail -n1 | tr -dc '0-9'); [ -n "$d" ] && echo "disk_root_percent=$d"

if command -v systemctl >/dev/null; then
  failed=$(timeout 10 systemctl --failed --plain --no-legend --no-pager 2>/dev/null | awk '{print $1}')
  echo "failed_units=$(printf '%s' "$failed" | grep -c .)"
  [ -n "$failed" ] && echo "failed_names=$(printf '%s\n' "$failed" | names)"
  s=$(timedatectl show -p NTPSynchronized --value 2>/dev/null)
  [ "$s" = yes ] && echo "time_synced=1"; [ "$s" = no ] && echo "time_synced=0"
fi
[ -e /var/run/reboot-required ] && echo "reboot_required=1" || echo "reboot_required=0"

t=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | sort -n | tail -n1)
[ -n "$t" ] && echo "temp_max_c=$((t / 1000))"

# Proxmox: thin pool, guest e snapshot
if command -v pveversion >/dev/null; then
  lvs --noheadings --units g --nosuffix -o lv_size,data_percent,metadata_percent pve/data 2>/dev/null | awk '{printf "data_percent=%.1f meta_percent=%.1f free_gb=%.1f ",$2,$3,$1*(100-$2)/100}'
  vgs --noheadings --units g --nosuffix -o vg_free pve 2>/dev/null | awk '{printf "vg_free_gb=%.1f\n",$1}'
  # pct list e qm list sono lenti (circa 3 s l'uno): una chiamata sola ciascuno
  cts=$(pct list 2>/dev/null); vms=$(qm list 2>/dev/null)
  stopped=$( { printf '%s\n' "$cts" | awk 'NR>1 && $2!="running"{print "ct"$1}'; printf '%s\n' "$vms" | awk 'NR>1 && $3!="running"{print "vm"$1}'; } )
  running=$( { printf '%s\n' "$cts" | awk 'NR>1 && $2=="running"'; printf '%s\n' "$vms" | awk 'NR>1 && $3=="running"'; } | grep -c .)
  echo "guests_running=$running guests_stopped=$(printf '%s' "$stopped" | grep -c .)"
  [ -n "$stopped" ] && echo "stopped_names=$(printf '%s\n' "$stopped" | names)"
  # snapshot: sono le sezioni [nome] dei file di configurazione dei guest (veloce, sola lettura)
  snaps=$(cat /etc/pve/lxc/*.conf /etc/pve/qemu-server/*.conf 2>/dev/null | grep -c '^\[')
  echo "snapshots=$snaps"
fi

# Docker: container fermi o non sani
if command -v docker >/dev/null && timeout 10 docker info >/dev/null 2>&1; then
  all=$(timeout 10 docker ps -a --format '{{.Names}}|{{.State}}|{{.Status}}' 2>/dev/null)
  bad=$(printf '%s\n' "$all" | awk -F'|' 'NF==3 && ($2!="running" || $3 ~ /unhealthy/){print $1}')
  echo "containers_total=$(printf '%s\n' "$all" | grep -c .) containers_bad=$(printf '%s' "$bad" | grep -c .)"
  [ -n "$bad" ] && echo "bad_names=$(printf '%s\n' "$bad" | names)"
fi

# claude-rc: sessioni tmux standard (lista in /etc/claude-sessions.conf, righe nome|cartella)
if [ -r /etc/claude-sessions.conf ] && command -v tmux >/dev/null; then
  have=$(tmux ls -F '#S' 2>/dev/null)
  missing=$(grep -v '^[[:space:]]*#' /etc/claude-sessions.conf | cut -d'|' -f1 | grep . | while read -r n; do printf '%s\n' "$have" | grep -qx -- "$n" || echo "$n"; done)
  echo "tmux_sessions=$(printf '%s' "$have" | grep -c .)"
  [ -n "$missing" ] && echo "tmux_missing=$(printf '%s\n' "$missing" | names)"
fi
exit 0
