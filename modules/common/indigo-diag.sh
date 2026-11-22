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

# Salute della batteria (energia a pieno carico rispetto a quella di progetto) e cicli, se il firmware li espone.
for b in /sys/class/power_supply/BAT*; do
  [ -d "$b" ] || continue
  awk -v d="$b" 'function rd(f,  v){ if ((getline v < (d "/" f)) > 0) return v+0; return 0 }
    BEGIN{ f=rd("energy_full"); g=rd("energy_full_design"); if (g<=0) { f=rd("charge_full"); g=rd("charge_full_design") }
      if (g>0 && f>0) printf "battery_health_percent=%.0f\n", f*100/g
      c=rd("cycle_count"); if (c>0) printf "battery_cycles=%d\n", c }'
  break
done

# Memoria ECC (se il kernel la espone): errori corretti e non correggibili dall'avvio.
ce=0; ue=0; ecc=0
for m in /sys/devices/system/edac/mc/mc[0-9]*; do
  [ -r "$m/ce_count" ] || continue
  ecc=1; ce=$((ce + $(cat "$m/ce_count" 2>/dev/null || echo 0))); ue=$((ue + $(cat "$m/ue_count" 2>/dev/null || echo 0)))
done
[ "$ecc" = 1 ] && echo "ecc_corrected=$ce ecc_uncorrected=$ue"

# Errori di rete sulle schede fisiche (contatori dall'avvio): errori e pacchetti, il bot ne fa il rapporto.
ne=0; np=0; nn=0
for i in /sys/class/net/*; do
  case "$(readlink -f "$i")" in */virtual/*) continue ;; esac
  [ -r "$i/statistics/rx_errors" ] || continue
  nn=1
  ne=$((ne + $(cat "$i/statistics/rx_errors") + $(cat "$i/statistics/tx_errors")))
  np=$((np + $(cat "$i/statistics/rx_packets") + $(cat "$i/statistics/tx_packets")))
done
[ "$nn" = 1 ] && echo "net_errors=$ne net_packets=$np"

# Batteria dei portatili: potenza di scarica in watt, solo mentre scarica e solo se si legge davvero (power_now in
# microwatt, oppure corrente x tensione). Senza batteria, in carica o a spina: nessuna riga.
for b in /sys/class/power_supply/BAT*; do
  [ "$(cat "$b/status" 2>/dev/null)" = "Discharging" ] || continue
  w=$(awk -v d="$b" 'function rd(f,  v){ if ((getline v < (d "/" f)) > 0) return v+0; return 0 }
    BEGIN{p=rd("power_now"); if (p<=0) p=rd("current_now")*rd("voltage_now")/1000000; if (p>0) printf "%.1f", p/1000000}')
  [ -n "$w" ] && { echo "battery_power_w=$w"; break; }
done

# Disco (SSD o HDD): stato SMART, usura, ore, temperatura, scritti e errori di media del primo disco fisico NVMe o SATA (non USB). Solo su una
# macchina vera (non VM o container, dove i dischi sono virtuali) e solo se smartctl si puo' eseguire (serve root):
# altrimenti "disk_readable=0" e il bot scrive n/d. Nessuna stima: una chiave che non si legge si omette.
is_root() { [ "$(id -u)" = 0 ]; }
is_physical() { command -v systemd-detect-virt >/dev/null && ! systemd-detect-virt -q 2>/dev/null; }
disk=""
if is_physical; then
  for b in /sys/block/nvme*n1 /sys/block/sd*; do
    [ -e "$b" ] || continue
    case "$(readlink -f "$b")" in *usb*) continue ;; esac
    disk=$(basename "$b"); break
  done
fi
if [ -n "$disk" ]; then
  smart=""
  if is_root && command -v smartctl >/dev/null; then
    smart=$(timeout 15 smartctl -H -A "/dev/$disk" 2>/dev/null | awk '
      function n(x) { gsub(/,/, "", x); return x + 0 }
      /overall-health self-assessment test result:/ { h = ($NF == "PASSED") ? 1 : 0; hh = 1 }
      /^SMART Health Status:/ { h = ($NF == "OK") ? 1 : 0; hh = 1 }
      /^Percentage Used:/ { w = n($3); hw = 1 }
      /^Available Spare:/ { sp = n($3); hsp = 1 }
      /^Available Spare Threshold:/ { st = n($4); hst = 1 }
      /^Data Units Written:/ { wr = n($4) * 512000 / 1e9; hwr = 1 }
      /^Power On Hours:/ { ph = n($4); hph = 1 }
      /^Media and Data Integrity Errors:/ { me = n($6); hme = 1 }
      /^Temperature:/ { tc = n($2); htc = 1 }
      /^Critical Warning:/ { cw = ($3 ~ /^0x0*$/) ? 0 : 1; hcw = 1 }
      $1 ~ /^[0-9]+$/ && NF >= 10 {
        v = $4 + 0; r = n($10)
        if ($2 ~ /^(Wear_Leveling_Count|Media_Wearout_Indicator|SSD_Life_Left|Percent_Lifetime_Remain|Remaining_Lifetime_Perc)$/) { w = 100 - v; hw = 1 }
        if ($2 == "Temperature_Celsius" || $2 == "Airflow_Temperature_Cel") { tc = r % 256; htc = 1 }
        if ($2 == "Power_On_Hours") { ph = r; hph = 1 }
        if ($2 == "Reallocated_Sector_Ct" || $2 == "Current_Pending_Sector" || $2 == "Offline_Uncorrectable") { me += r; hme = 1 }
      }
      END {
        if (hh) printf "disk_health_ok=%d\n", h
        if (hw) printf "disk_wear_percent=%.0f\n", w
        if (hsp && hst) printf "disk_spare_percent=%.0f disk_spare_threshold=%.0f\n", sp, st
        if (hcw) printf "disk_critical_warning=%d\n", cw
        if (hme) printf "disk_media_errors=%d\n", me
        if (htc) printf "disk_temp_c=%d\n", tc
        if (hph) printf "disk_power_hours=%d\n", ph
        if (hwr) printf "disk_written_gb=%.1f\n", wr
      }')
  fi
  [ "$(cat "/sys/block/$disk/queue/rotational" 2>/dev/null)" = 1 ] && echo "disk_hdd=1"
  if [ -n "$smart" ]; then printf '%s\n' "$smart"; else echo "disk_readable=0"; fi
  # errori di I/O contati dal kernel (dischi SCSI/SATA; valore esadecimale): solo un contatore, senza privilegi
  io=$(cat "/sys/block/$disk/device/ioerr_cnt" 2>/dev/null)
  [ -n "$io" ] && echo "disk_io_errors=$((io))" 2>/dev/null
fi

# Proxmox: potenza del pacchetto CPU (RAPL, due letture a 1 s: e' la CPU, non il consumo totale), thin pool, guest e snapshot
if command -v pveversion >/dev/null; then
  r=/sys/class/powercap/intel-rapl:0
  if [ -r "$r/energy_uj" ] && [ -r "$r/max_energy_range_uj" ]; then
    e1=$(cat "$r/energy_uj" 2>/dev/null); t1=$(date +%s%N); sleep 1
    e2=$(cat "$r/energy_uj" 2>/dev/null); t2=$(date +%s%N); mx=$(cat "$r/max_energy_range_uj" 2>/dev/null)
    awk -v e1="$e1" -v e2="$e2" -v t1="$t1" -v t2="$t2" -v mx="$mx" 'BEGIN{
      d=e2-e1; if (d<0) d+=mx; dt=(t2-t1)/1e9
      if (e1!="" && e2!="" && dt>0.5 && d>=0) printf "cpu_power_w=%.1f\n", d/1e6/dt}'
  fi
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
