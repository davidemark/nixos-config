#!/usr/bin/env bash
# Block secrets and private data in a public repo.
#   check-secrets.sh          scan the lines added in the staged diff (used by the pre-commit hook)
#   check-secrets.sh --all    scan every tracked file (audit)
# A line can be accepted on purpose by adding the marker "secrets-ok" in a comment on it.
set -u

patterns=(
  '-----BEGIN [A-Z ]*PRIVATE KEY-----|private key'
  '(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{20,}|GitHub token'
  'github_pat_[A-Za-z0-9_]{20,}|GitHub token'
  'tskey-[A-Za-z0-9-]{10,}|Tailscale key'
  'sk-ant-[A-Za-z0-9_-]{10,}|Anthropic key'
  'xox[abprs]-[A-Za-z0-9-]{10,}|Slack token'
  'AKIA[0-9A-Z]{16}|AWS key'
  '(^|[^A-Za-z])(initialPassword|password|passwd)[[:space:]]*=[[:space:]]*"[^"]+"|password in clear text'
  '(api_?key|secret|token)[[:space:]]*=[[:space:]]*"[A-Za-z0-9_./+-]{12,}"|secret value'
  '(^|[^0-9.])100\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\.[0-9]{1,3}\.[0-9]{1,3}([^0-9]|$)|Tailscale 100.x address'
  '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}|MAC address'
  '(^|[^A-Za-z])(ssid|psk)[[:space:]]*=|Wi-Fi name or password'
  '[A-Za-z0-9._-]+@(gmail|outlook|hotmail|icloud|yahoo)\.[a-z]+|personal email address'
)

if [ "${1:-}" = "--all" ]; then
  mode=all
  source_cmd() { git ls-files -z | xargs -0 grep -nI '' 2>/dev/null; }
else
  mode=staged
  source_cmd() {
    git diff --cached --no-color -U0 --diff-filter=ACMR \
      | awk '/^\+\+\+ b\//{f=substr($0,7);next} /^\+\+\+/{next} /^\+/{print f":"substr($0,2)}'
  }
fi

fail=0

# Files that should never be committed.
if [ "$mode" = staged ]; then
  files=$(git diff --cached --name-only --diff-filter=ACMR)
else
  files=$(git ls-files)
fi
while IFS= read -r f; do
  case "$(basename "$f")" in
    .env|.env.*|id_rsa|id_ed25519|id_ecdsa|*.pem|*.key|*.p12|*.pfx|*.kdbx)
      case "$f" in *.env.example) ;; *) echo "BLOCKED file: $f (secret file name)"; fail=1 ;; esac ;;
  esac
done <<< "$files"

lines=$(source_cmd)
for entry in "${patterns[@]}"; do
  re=${entry%|*}
  label=${entry##*|}
  hits=$(printf '%s\n' "$lines" | grep -E -- "$re" | grep -v 'secrets-ok' || true)
  if [ -n "$hits" ]; then
    echo "BLOCKED ($label):"
    printf '%s\n' "$hits" | cut -c1-160 | sed 's/^/  /'
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  echo
  echo "nixos-config is public. Remove the line(s) above, or add 'secrets-ok' in a comment on a line that is safe on purpose."
  exit 1
fi
[ "$mode" = all ] && echo "check-secrets: no matches in tracked files"
exit 0
