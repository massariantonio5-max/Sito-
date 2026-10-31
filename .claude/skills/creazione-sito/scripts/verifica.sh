#!/usr/bin/env bash
# Verifica visiva di una pagina: screenshot desktop/mobile, scroll orizzontale, detector Impeccable.
# Uso: verifica.sh <url> [cartella-output]
# Esempio: verifica.sh http://localhost:4173/index.html screenshots/home
set -u
URL="${1:?Uso: verifica.sh <url> [cartella-output]}"
OUT="${2:-screenshots}"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
IMPECCABLE="$ROOT/.claude/skills/impeccable/scripts/impeccable"
mkdir -p "$OUT"

command -v playwright-cli >/dev/null || npm install -g @playwright/cli@latest >/dev/null

S="-s=verifica"
playwright-cli $S open "$URL" >/dev/null
status=0
for vp in "desktop 1440 900" "mobile 390 844"; do
  set -- $vp
  playwright-cli $S resize "$2" "$3" >/dev/null
  playwright-cli $S screenshot --filename="$OUT/$1.png" >/dev/null
  playwright-cli $S screenshot --full-page --filename="$OUT/$1-full.png" >/dev/null
  overflow=$(playwright-cli $S eval "() => document.documentElement.scrollWidth - document.documentElement.clientWidth" 2>/dev/null \
    | grep -oE '^-?[0-9]+' | head -1)
  if [ "${overflow:-0}" -gt 0 ]; then
    echo "✗ $1 ($2px): scroll orizzontale di ${overflow}px"; status=1
  else
    echo "✓ $1 ($2px): nessuno scroll orizzontale"
  fi
done
inter=$(playwright-cli $S eval "() => [...document.querySelectorAll('body *')].filter(e => /^\\s*[\"']?inter\\b/i.test(getComputedStyle(e).fontFamily)).length" 2>/dev/null \
  | grep -oE '^[0-9]+' | head -1)
if [ "${inter:-0}" -gt 0 ]; then
  echo "✗ font: $inter elementi usano Inter come primo font"; status=1
else
  echo "✓ font: Inter non usato"
fi
playwright-cli $S close >/dev/null 2>&1

echo "Screenshot in $OUT/: desktop.png, desktop-full.png, mobile.png, mobile-full.png"
echo "--- impeccable detect ---"
if [ -x "$IMPECCABLE" ]; then
  "$IMPECCABLE" detect "$URL"; rc=$?
  [ $rc -eq 0 ] && echo "✓ detector pulito" || status=1
else
  echo "✗ impeccable non trovato in $IMPECCABLE"; status=1
fi
exit $status
