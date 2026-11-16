#!/usr/bin/env bash
read -r _ u1 n1 s1 i1 w1 q1 sq1 _ < /proc/stat
sleep 0.5
read -r _ u2 n2 s2 i2 w2 q2 sq2 _ < /proc/stat
t1=$((u1 + n1 + s1 + i1 + w1 + q1 + sq1)); t2=$((u2 + n2 + s2 + i2 + w2 + q2 + sq2))
cpu=$(( 100 * ((t2 - t1) - (i2 + w2 - i1 - w1)) / (t2 - t1) ))

mem=$(free -h | awk '/^Mem:/ {print $3 " / " $2}')
swap=$(free -h | awk '/^Swap:/ {print $3 " / " $2}')
disk=$(df -h --output=used,size,pcent / | awk 'NR==2 {print $1 " / " $2 " (" $3 ")"}')

body="󰻠 CPU  $cpu%\n󰍛 RAM  $mem\n󰍛 swap  $swap\n󰋊 disk  $disk"

for b in /sys/class/power_supply/BAT*; do
  [ -r "$b/capacity" ] || continue
  body="$body\n󰁹 battery  $(cat "$b/capacity")% ($(cat "$b/status"))"
  break
done
# CPU package sensor by driver name (thermal_zone numbers change; zone0 can be virtual)
for h in /sys/class/hwmon/hwmon*; do
  case "$(cat "$h/name" 2>/dev/null)" in
    coretemp|k10temp|zenpower)
      body="$body\n󰔏 temp  $(( $(cat "$h/temp1_input") / 1000 ))°C"
      break ;;
  esac
done

exec @notify_send@ -a sysinfo -t 8000 \
  -h string:x-canonical-private-synchronous:sysinfo "System" "$(printf '%b' "$body")"
