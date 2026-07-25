#!/usr/bin/env bash
# deploy.sh — install the updaters on the gateway host and the timer on this box.
#
#   ./deploy.sh <ssh-host-alias> [--no-timer]
#
# The ssh host alias is an ARGUMENT, never committed — this repo is public.
# Renders the systemd unit locally into ~/.config/systemd/user/ (also not
# committed) with the host substituted in.
set -euo pipefail

GATEWAY_HOST="${1:?usage: ./deploy.sh <ssh-host-alias> [--no-timer]}"
INSTALL_TIMER=1
[ "${2:-}" = "--no-timer" ] && INSTALL_TIMER=0

HERE="$(cd "$(dirname "$0")" && pwd)"
REMOTE_DIR='$HOME/.local/libexec/host-update'

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
section() { printf "\n${GREEN}==> %s${NC}\n" "$1"; }
warn()    { printf "${YELLOW}  ! %s${NC}\n" "$1"; }

section "Checking connectivity to ${GATEWAY_HOST}"
ssh -o ConnectTimeout=15 -o BatchMode=yes "$GATEWAY_HOST" true
echo "  ok"

section "Installing updaters on ${GATEWAY_HOST}:${REMOTE_DIR}"
# shellcheck disable=SC2029
ssh "$GATEWAY_HOST" "mkdir -p ${REMOTE_DIR}"
for f in agentgateway-upgrade ollama-upgrade; do
  scp -q "$HERE/$f" "$GATEWAY_HOST:.local/libexec/host-update/$f"
  # shellcheck disable=SC2029
  ssh "$GATEWAY_HOST" "chmod +x ${REMOTE_DIR}/$f"
  echo "  installed $f"
done

section "Smoke-testing both updaters (read-only)"
for f in agentgateway-upgrade ollama-upgrade; do
  printf '  %s: ' "$f"
  # check exits 10/11 when an upgrade/prerelease is available — both are fine here.
  # shellcheck disable=SC2029
  if ssh "$GATEWAY_HOST" "${REMOTE_DIR}/$f check --json" 2>&1 | head -1; then :; fi
done

section "Verifying both services are healthy right now"
for f in agentgateway-upgrade ollama-upgrade; do
  printf '  %s: ' "$f"
  # shellcheck disable=SC2029
  ssh "$GATEWAY_HOST" "${REMOTE_DIR}/$f verify" 2>&1 | head -1 || warn "verify reported a problem"
done

if [ "$INSTALL_TIMER" -eq 0 ]; then
  section "Skipping timer install (--no-timer)"
  exit 0
fi

section "Installing the systemd user timer on $(hostname)"
UNIT_DIR="$HOME/.config/systemd/user"
mkdir -p "$UNIT_DIR"

sed "s|@GATEWAY_HOST@|${GATEWAY_HOST}|g; s|@SCRIPT@|${HERE}/host-update|g" \
  "$HERE/systemd/gateway-host-update.service.in" > "$UNIT_DIR/gateway-host-update.service"
cp "$HERE/systemd/gateway-host-update.timer" "$UNIT_DIR/gateway-host-update.timer"
echo "  rendered $UNIT_DIR/gateway-host-update.service"

systemctl --user daemon-reload
systemctl --user enable --now gateway-host-update.timer
echo "  timer enabled"
systemctl --user list-timers gateway-host-update.timer --no-pager || true

cat <<EOF

$(printf "${GREEN}Done.${NC}")

  Run now (read-only)   : ${HERE}/host-update --check
  Run now (apply)       : GATEWAY_HOST=${GATEWAY_HOST} ${HERE}/host-update
  Watch the timer       : systemctl --user list-timers gateway-host-update.timer
  Last run log          : ~/.local/state/host-update/last-run.log
  Ledger                : ~/.local/state/host-update/ledger.jsonl
  Disable              : systemctl --user disable --now gateway-host-update.timer
EOF
