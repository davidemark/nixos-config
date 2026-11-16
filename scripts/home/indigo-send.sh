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
    if [ -n "${TMUX:-}" ]; then
        session=$(tmux display-message -p '#S')
    else
        session=$(hostname)
    fi
fi

# Caratteri sicuri per il JSON: il server li ripulisce comunque.
clean() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '_'; }

phrase=""
for _ in 1 2 3; do
    i=$(( $(od -An -N2 -tu2 /dev/urandom) % ${#words[@]} ))
    phrase+="${phrase:+-}${words[$i]}"
done

header=$(printf '{"session":"%s","filename":"%s","phrase":"%s"}' \
    "$(clean "$session")" "$(clean "$(basename "$file")")" "$phrase")

rc=255
out=""
for target in ${INDIGO_SEND_TARGETS:-indigo-send indigo-send-ts}; do
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
