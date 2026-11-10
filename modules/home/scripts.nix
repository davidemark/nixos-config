{ config, pkgs, ... }:
{
  home.file.".local/bin/cycle-wallpaper.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      WALLPAPER_DIR="$1"
      CURRENT_FILE="$HOME/.cache/current-wallpaper-$(basename $WALLPAPER_DIR)"

      mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) | sort)

      if [ ''${#WALLPAPERS[@]} -eq 0 ]; then
        exit 1
      fi

      if [ -f "$CURRENT_FILE" ]; then
        CURRENT=$(cat "$CURRENT_FILE")
      else
        CURRENT=0
      fi

      NEXT=$(( (CURRENT + 1) % ''${#WALLPAPERS[@]} ))

      pkill swaybg
      sleep 0.1
      swaybg -i "''${WALLPAPERS[$NEXT]}" -m fill &

      echo "$NEXT" > "$CURRENT_FILE"
    '';
  };

  # Opens the Claude sessions running on claude-rc. Naming convention for every Claude session:
  # <host>-<session-name>, so on claude-rc: claude-rc-misc, claude-rc-indigo, claude-rc-maintenance.
  home.file.".local/bin/crc" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # crc            menu with the Claude sessions on claude-rc, then attach
      # crc <name>     attach to a session (crc misc = claude-rc-misc)
      # crc -l         list the sessions
      # crc --start    recreate the missing sessions (systemctl restart claude-sessions)
      # Detach with Ctrl+b d. Needs the ssh alias claude-rc-ts (modules/home/ssh.nix) and a key
      # authorized on claude-rc. Another host: CLAUDE_RC_HOST=<ssh alias> crc
      set -u
      host="''${CLAUDE_RC_HOST:-claude-rc-ts}"
      prefix="claude-rc-"

      list_sessions() {
        ssh "$host" "tmux list-sessions -F '#S' 2>/dev/null" | grep "^$prefix"
      }

      attach() {
        exec ssh -t "$host" "tmux attach -t '=$1'"
      }

      case "''${1:-}" in
        -l|--list)
          list_sessions
          ;;
        --start)
          ssh "$host" "systemctl restart claude-sessions" && list_sessions
          ;;
        "")
          mapfile -t sessions < <(list_sessions)
          if [ "''${#sessions[@]}" -eq 0 ]; then
            echo "No Claude sessions found on $host (try: crc --start)" >&2
            exit 1
          fi
          select name in "''${sessions[@]}"; do
            [ -n "$name" ] && attach "$name"
          done
          ;;
        *)
          name="$1"
          case "$name" in "$prefix"*) ;; *) name="$prefix$name" ;; esac
          if ! list_sessions | grep -qx "$name"; then
            echo "Session $name not found. Available:" >&2
            list_sessions >&2
            exit 1
          fi
          attach "$name"
          ;;
      esac
    '';
  };

  # Sends a PDF or an image (PNG, JPEG) to DavideMark through the Indigo Telegram bot. Copy of indigo/client/indigo-send
  # (private repo): keep the two in sync. See the second-brain note 08-Homelab/01-Indigo.
  home.file.".local/bin/indigo-send" = {
    executable = true;
    text = ''
      #!/bin/bash
      # Invia un PDF o un'immagine (PNG, JPEG) a DavideMark tramite il bot Indigo.
      #
      # Uso: indigo-send [-s sessione] file.pdf|file.png|file.jpg
      #
      # Il file non parte subito: il bot scrive a DavideMark che c'e' una richiesta e lui deve scrivere nel bot la FRASE
      # stampata da questo comando. La frase va comunicata a DavideMark nella risposta della sessione Claude: e' questo che
      # dimostra che la richiesta viene dalla sessione con cui sta parlando. La richiesta scade dopo 10 minuti.
      #
      # Il tipo si riconosce dal contenuto, non dall'estensione. Arriva come documento, senza compressione di Telegram.
      # Il file viaggia in SSH verso l'utente "indigo-send" di indigo, la cui chiave puo' eseguire solo "indigo receive".
      # Destinazioni provate in ordine (alias SSH): indigo-send (LAN), indigo-send-ts (da fuori casa, passa da homelab).
      # Si possono cambiare con INDIGO_SEND_TARGETS="alias1 alias2".
      set -euo pipefail

      words=(tigre lago nove luna sole mare ponte fiume monte prato stella vento nuvola pietra bosco campo
             carta penna libro tavolo sedia porta finestra strada piazza torre nave treno ruota chiave
             campana farfalla gatto cane cavallo volpe lupo aquila delfino pesce rosa quercia pino
             mela pera limone arancia pane latte miele sale fuoco neve pioggia alba tramonto ombra
             specchio lampada orologio violino tamburo fiore seme radice isola)

      usage() {
          echo "Uso: indigo-send [-s sessione] file.pdf|file.png|file.jpg" >&2
          exit 2
      }

      session=""
      while getopts "s:h" opt; do
          case $opt in
              s) session=$OPTARG ;;
              *) usage ;;
          esac
      done
      shift $((OPTIND - 1))
      [ $# -eq 1 ] || usage
      file=$1

      [ -f "$file" ] || { echo "errore: $file non esiste" >&2; exit 1; }
      magic=$(head -c8 "$file" | od -An -tx1 | tr -d ' \n')
      case $magic in
          255044462d*|89504e470d0a1a0a|ffd8ff*) ;;
          *) echo "errore: $file non e' un PDF, PNG o JPEG" >&2; exit 1 ;;
      esac

      if [ -z "$session" ]; then
          if [ -n "''${TMUX:-}" ]; then
              session=$(tmux display-message -p '#S')
          else
              session=$(hostname)
          fi
      fi

      # Caratteri sicuri per il JSON: il server li ripulisce comunque.
      clean() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '_'; }

      phrase=""
      for _ in 1 2 3; do
          i=$(( $(od -An -N2 -tu2 /dev/urandom) % ''${#words[@]} ))
          phrase+="''${phrase:+-}''${words[$i]}"
      done

      header=$(printf '{"session":"%s","filename":"%s","phrase":"%s"}' \
          "$(clean "$session")" "$(clean "$(basename "$file")")" "$phrase")

      rc=255
      out=""
      for target in ''${INDIGO_SEND_TARGETS:-indigo-send indigo-send-ts}; do
          set +e
          out=$({ printf '%s\n' "$header"; cat "$file"; } | ssh -T -o BatchMode=yes -o ConnectTimeout=5 "$target" 2>&1)
          rc=$?
          set -e
          # 255 = connessione fallita: si prova la destinazione successiva; ogni altro esito e' una risposta di indigo.
          [ "$rc" -ne 255 ] && break
      done

      if [ "$rc" -ne 0 ]; then
          echo "errore: invio non riuscito: $out" >&2
          exit 1
      fi

      cat <<EOF
      Richiesta inviata (sessione: $session, file: $(basename "$file")).
      FRASE: $phrase
      DavideMark deve scrivere questa frase nel bot Telegram entro 10 minuti per ricevere il PDF.
      Scrivila ora nella tua risposta a DavideMark: il bot non la mostra.
      EOF
    '';
  };
}
