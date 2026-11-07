# vim: ft=bash
# =============================================================================
# Automatically attach to a tmux session or create a new one.
# =============================================================================

if [[ -z $TMUX ]]; then
  tmux -2 attach || tmux -2
fi
