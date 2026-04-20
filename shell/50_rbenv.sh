if [[ "$DISABLE_RBENV" != "1" ]] && ! is_windows; then
  if [[ -e $DOTFILES/thirdparty/rbenv/bin/rbenv ]]; then
    export PATH=$DOTFILES/thirdparty/rbenv/bin:$PATH
    eval "$(rbenv init -)"
  fi
fi
