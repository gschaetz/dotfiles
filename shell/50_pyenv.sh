if [[ "$DISABLE_PYENV" != "1" ]] && ! is_windows; then
  if [[ -e $DOTFILES/thirdparty/pyenv/bin/pyenv ]]; then
    export PATH=$DOTFILES/thirdparty/pyenv/bin:$PATH
    # https://github.com/yyuu/pyenv/wiki#how-to-build-cpython-with-framework-support-on-os-x
    # this is need by some tools (like YouCompleteMe plugin)
    # commenting this out for now since I'm not using YouCompleteMe anymore
    # export PYTHON_CONFIGURE_OPTS="--enable-framework"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    # pyenv-virtualenv sets _PYENV_VH_PWD=$PWD in its precmd hook as a caching
    # optimization, but zsh's cdable_vars treats variables holding absolute paths
    # as named directories, causing %~ in PS1 to show ~_PYENV_VH_PWD instead of
    # the actual path. This hook clears it after pyenv's hook runs.
    if [[ -n "${ZSH_VERSION-}" ]]; then
      _pyenv_vhpwd_prompt_fix() { unset _PYENV_VH_PWD; }
      precmd_functions+=(_pyenv_vhpwd_prompt_fix)
    fi
  fi
fi
