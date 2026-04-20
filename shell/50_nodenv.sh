if [[ "$DISABLE_NODENV" != "1" ]] && ! is_windows; then
  if [[ -e $DOTFILES/thirdparty/nodenv/bin/nodenv ]]; then
    export PATH=$DOTFILES/thirdparty/nodenv/bin:$PATH
    eval "$(nodenv init -)"
  fi
fi
