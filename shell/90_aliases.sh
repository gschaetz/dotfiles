# define shared aliases for
# both bash and zsh
#

has_command ip && default_iface=$(ip -o -4 route show to default | awk '{print $5}')
has_command route && route get default >/dev/null 2>&1 && default_iface=$(route get default | grep interface: | awk '{print $2}')

# =============================================================================
# FILES
# =============================================================================

if has_command gls; then
  # @category: files
  # @desc: List files with colors and groups (GNU ls via gls)
  alias ls='command gls --color=auto -h -Fb --group-directories-first'
elif ls --color=auto -d . >/dev/null 2>&1; then
  # @category: files
  # @desc: List files with colors and groups (GNU ls)
  alias ls='command ls --color=auto -h -Fb --group-directories-first'
else
  # @category: files
  # @desc: List files (BSD ls fallback)
  alias ls='command ls -h -Fb'
fi

# @category: files
# @desc: Disk usage with human-readable sizes
alias du='du -hx'
# @category: files
# @desc: Disk free space with human-readable sizes
alias df='df -h'
# @category: files
# @desc: List all files including hidden
alias la='ls -A'
# @category: files
# @desc: Long format listing
alias ll='ls -l'
# @category: files
# @desc: Long format listing including hidden files
alias lla='ll -A'
# @category: files
# @desc: Alias for ll (long listing)
alias dir='ll'
# @category: files
# @desc: Tree view with sizes, filetypes, and dirs first
alias tree='tree -h -Fx --dirsfirst'

# =============================================================================
# SYSTEM
# =============================================================================

# @category: system
# @desc: Allow sudo to work with aliases
alias sudo='sudo '
# @category: system
# @desc: Show the current ISO week number
alias week='date +%V'
# @category: system
# @desc: Clear the terminal screen
alias cls="clear"
# @category: system
# @desc: Go to the home directory
alias home='cd $HOME'
# @category: system
# @desc: Go to the Downloads directory
alias dls='cd $HOME/Downloads'
# @category: system
# @desc: Go to the Documents directory
alias doc='cd $HOME/Documents'
# @category: system
# @desc: Print each PATH entry on its own line
alias path='echo $PATH | tr ":" "\n"'
# @category: system
# @desc: Ring the terminal bell
alias bell="tput bel"

# =============================================================================
# TEXT / TOOLS
# =============================================================================

if has_command egrep; then
  # @category: text
  # @desc: grep with color (egrep)
  alias grep='egrep --color=auto'
else
  # @category: text
  # @desc: grep with color
  alias grep='grep --color=auto'
fi

if has_command less; then
  # @category: text
  # @desc: Use less as the default pager
  alias more='less'
fi

if has_command vim; then
  # @category: text
  # @desc: Use vim as the default vi
  alias vi='vim'
fi

if ! has_command hd; then
  # @category: text
  # @desc: Canonical hex dump
  alias hd="hexdump -C"
fi

# @category: text
# @desc: URL-encode a string
alias urlencode='python3 -c "import sys; import urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]));"'
# @category: text
# @desc: Apply a command to each line (like xargs -n1)
alias map="xargs -n1"
# @category: text
# @desc: Interactive Ruby shell with completion
alias irb='irb --readline -r irb/completion --prompt simple'

# =============================================================================
# NETWORK
# =============================================================================

# @category: network
# @desc: FTP with auto-login disabled
alias ftp='ftp -i'
# @category: network
# @desc: Get your public IP address via OpenDNS
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
# @category: network
# @desc: Sniff HTTP traffic and open in Wireshark
alias sniff="sudo tcpdump -n -c 9999 -w - | wireshark -k -i -"

# HTTP method aliases (GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS) via lwp-request
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

# =============================================================================
# APT
# =============================================================================

# @category: apt
# @desc: apt-cache shorthand
alias aptc='apt-cache'
# @category: apt
# @desc: apt-get shorthand
alias aptg='apt-get'
# @category: apt
# @desc: dpkg-query shorthand
alias dpkgq='dpkg-query'

# =============================================================================
# DOCKER
# =============================================================================

# @category: docker
# @desc: docker shorthand
alias d='docker'
# @category: docker
# @desc: Build a Docker image from the current directory
alias db='docker build .'
# @category: docker
# @desc: docker-compose shorthand
alias dcomp='docker-compose'
# @category: docker
# @desc: Load docker-machine environment variables
alias denv='eval $(docker-machine env)'
# @category: docker
# @desc: Run an interactive auto-removing Docker container
alias drun='docker run -i -t --rm'
# @category: docker
# @desc: Remove dangling (untagged) Docker images
alias drmut='docker rmi $(docker images -q -f dangling=true)'
# @category: docker
# @desc: docker-machine shorthand
alias dm='docker-machine'
# @category: docker
# @desc: docker stack shorthand
alias ds='docker stack'
# @category: docker
# @desc: docker exec shorthand
alias dexec='docker exec'
# @category: docker
# @desc: docker ps shorthand
alias dps='docker ps'

# =============================================================================
# SHELL
# =============================================================================

# @category: shell
# @desc: Show command history
alias h='history'

# =============================================================================
# AWS
# =============================================================================

# @category: aws
# @desc: List available AWS regions matching *us*
alias aws-regions='aws ec2 describe-regions --filters "Name=endpoint,Values=*us*" --output text'
# @category: aws
# @desc: List AWS credential profiles
alias aws-profiles='cat ~/.aws/credentials | grep "^\["'

# =============================================================================
# GIT
# =============================================================================

# @category: git
# @desc: Pull latest changes across all nested git repos in parallel
alias git-update="find . -maxdepth 8 -name '.git' -prune -type d -printf '%h\n' | parallel 'echo {} && git -C {} pull'"

# =============================================================================
# KUBECTL
# =============================================================================

# @category: kubectl
# @desc: kubectl shorthand
alias kc="kubectl"
# @category: kubectl
# @desc: kubectl apply
alias kca="kubectl apply"
# @category: kubectl
# @desc: kubectl apply -f
alias kcaf="kubectl apply -f"
# @category: kubectl
# @desc: kubectl delete
alias kcd="kubectl delete"
# @category: kubectl
# @desc: kubectl delete -f
alias kcdf="kubectl delete -f"
# @category: kubectl
# @desc: kubectl get
alias kcg="kubectl get"
# @category: kubectl
# @desc: kubectl get pods
alias kcgp="kubectl get pods"
# @category: kubectl
# @desc: kubectl get pods in all namespaces
alias kcgpa="kubectl get pods -A"
# @category: kubectl
# @desc: kubectl get services
alias kcgs="kubectl get services"
# @category: kubectl
# @desc: kubectl get deployments
alias kcgd="kubectl get deployments"
# @category: kubectl
# @desc: kubectl get pods and services
alias kcgps="kubectl get pods,services"
# @category: kubectl
# @desc: kubectl port-forward
alias kcpf="kubectl proxy-foward"
# @category: kubectl
# @desc: istioctl shorthand
alias ic="istioctl"
# @category: kubectl
# @desc: istioctl dashboard
alias icd="istioctl dashboard"

# =============================================================================
# DOTFILES
# =============================================================================

# @category: dotfiles
# @desc: Reload the shell configuration
alias dotfiles-reload='source ~/.zshrc'
# @category: dotfiles
# @desc: Pull latest dotfiles (with stash), update submodules, and reload shell
alias dotfiles-update='git -C $DOTFILES stash && git -C $DOTFILES pull && git -C $DOTFILES submodule update --init --recursive --remote && git -C $DOTFILES stash pop && source ~/.zshrc'

# =============================================================================
# AI
# =============================================================================

# @category: ai
# @desc: Switch to a local LM Studio model (default port 1234)
alias claude-local='export ANTHROPIC_BASE_URL="http://localhost:1234" && export ANTHROPIC_AUTH_TOKEN="lmstudio" && echo "Switched to Local Model"'
# @category: ai
# @desc: Switch back to the official Claude API
alias claude-pro='unset ANTHROPIC_BASE_URL && unset ANTHROPIC_AUTH_TOKEN && echo "Switched to Claude Pro"'

# =============================================================================
# MACOS
# =============================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then

  if [[ -x /Applications/MacVim.app/Contents/MacOS/Vim ]]; then
    # @category: macos
    # @desc: Use MacVim's Vim binary
    alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
    # @category: macos
    # @desc: Open a file read-only in MacVim
    alias view='/Applications/MacVim.app/Contents/MacOS/Vim -R'
    # @category: macos
    # @desc: Open a vimdiff session in MacVim
    alias vimdiff='/Applications/MacVim.app/Contents/MacOS/Vim -d'
    # @category: macos
    # @desc: Open MacVim GUI
    alias gvim=mvim
  fi

  if ! has_command md5sum; then
    # @category: macos
    # @desc: md5sum fallback using md5
    alias md5sum="md5"
  fi

  if ! has_command sha1sum; then
    # @category: macos
    # @desc: sha1sum fallback using shasum
    alias sha1sum="shasum"
  fi

  # @category: macos
  # @desc: Merge PDF files via Automator action
  alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'
  # @category: macos
  # @desc: Lock the screen (AFK)
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
  # @category: macos
  # @desc: Update macOS, Homebrew, gems, and npm packages
  alias macupdate='sudo softwareupdate -i -r -R; brew update && brew upgrade && brew cask upgrade'

fi

# =============================================================================
# HELP
# =============================================================================

_alias_source="$DOTFILES/shell/90_aliases.sh"

# @category: help
# @desc: List all alias categories defined in 90_aliases.sh
alias-categories() {
  awk '/^# @category:/ { print $3 }' "$_alias_source" | sort -u
}

# @category: help
# @desc: List aliases with descriptions, optionally filtered by category
alias-list() {
  local filter="${1:-}"
  awk -v filter="$filter" '
    /^# @category:/ { cat = $3 }
    /^# @desc:/     { desc = substr($0, index($0, $3)) }
    /^[[:space:]]*alias [a-zA-Z_]/ {
      name = $2; gsub(/=.*/, "", name)
      if (filter == "" || cat == filter)
        printf "  %-22s %-14s %s\n", name, "[" cat "]", desc
    }
  ' "$_alias_source"
}
