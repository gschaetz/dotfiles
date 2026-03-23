# =============================================================================
# AI
# =============================================================================

# @category: ai
# @desc: Launch aider via uvx against a local LM Studio model
aider-local() {
  local MODEL="${1:-openai/qwen3.5-35b-a3b}"

  export OPENAI_API_BASE="http://127.0.0.1"
  export OPENAI_API_KEY="lmstudio"

  uvx aider --model "$MODEL" --architect
}

# @category: ai
# @desc: Start an MLX LM server on M5 Pro (default: Qwen3.5-35B-A3B)
mlx-serve() {
  local MODEL_PATH="${1:-$HOME/.lmstudio/models/mlx-community/Qwen3.5-35B-A3B-MLX-4bit}"

  echo "Starting MLX Server on M5 Pro..."
  echo "Model: $MODEL_PATH"

  python -m mlx_lm.server \
    --model "$MODEL_PATH" \
    --chat-template chatml \
    --limit-mm-per-prompt 0 \
    --host 127.0.0.1 \
    --port 8080 &

  MLX_PID=$!
  echo "Server running (PID: $MLX_PID). Use 'mlx-stop' to quit."
}

# @category: ai
# @desc: Stop the running MLX LM server
mlx-stop() {
  echo "Stopping MLX Server..."
  pkill -f "mlx_lm.server"
  echo "Done."
}

# =============================================================================
# AWS
# =============================================================================

# @category: aws
# @desc: Show or switch the active AWS profile
function awsp() {
  if [ $# -eq 0  ]; then
    cat ~/.aws/credentials | grep '\[';
    aws configure list
  else
    export AWS_PROFILE=$1
    env | grep 'AWS_PROFILE'
  fi;
}

# =============================================================================
# DEV
# =============================================================================

# @category: dev
# @desc: Simple command-line calculator
calc() {
	local result=""
	result="$(printf "scale=10;%s\\n" "$*" | bc --mathlib | tr -d '\\\n')"
	#						└─ default (when `--mathlib` is used) is 20

	if [[ "$result" == *.* ]]; then
		# improve the output for decimal numbers
		# add "0" for cases like ".5"
		# add "0" for cases like "-.5"
		# remove trailing zeros
		printf "%s" "$result" |
			sed -e 's/^\./0./'  \
			-e 's/^-\./-0./' \
			-e 's/0*$//;s/\.$//'
	else
		printf "%s" "$result"
	fi
	printf "\\n"
}

# @category: dev
# @desc: Get the Unicode code point of a character
function codepoint() {
  perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
  # print a newline unless we're piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

# @category: dev
# @desc: Create a data URL from a file
function dataurl() {
  local mimeType=$(file -b --mime-type "$1");
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8";
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# @category: dev
# @desc: UTF-8-encode a string of Unicode symbols
function escape() {
  printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
  # print a newline unless we're piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

# @category: dev
# @desc: Show all CNs and SANs in an SSL certificate for a domain
function getcertnames() {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified.";
    return 1;
  fi;

  local domain="${1}";
  echo "Testing ${domain}…";
  echo ""; # newline

  local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
    | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
      no_serial, no_sigdump, no_signame, no_validity, no_version");
    echo "Common Name:";
    echo ""; # newline
    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
    echo ""; # newline
    echo "Subject Alternative Name(s):";
    echo ""; # newline
    echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
      | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
    return 0;
  else
    echo "ERROR: Certificate not found.";
    return 1;
  fi;
}

# @category: dev
# @desc: Syntax-highlight JSON strings or files via pygmentize
function json() {
  if [ -t 0 ]; then # argument
    if command -v pygmentize >/dev/null 2>&1; then
      echo "$*" | python -mjson.tool | pygmentize -l javascript;
    else
      echo "$*" | python -mjson.tool;
    fi;
  else # pipe
    if command -v pygmentize >/dev/null 2>&1; then
      python -mjson.tool | pygmentize -l javascript;
    else
      python -mjson.tool;
    fi;
  fi;
}

# @category: dev
# @desc: Start a Python HTTP server on a given port (default 8000)
function server() {
  local port="${1:-8000}";
  sleep 1 && open "http://localhost:${port}/" &
  # Use Python 3's http.server module
  python3 -m http.server "$port";
}

# @category: dev
# @desc: Decode \x{ABCD}-style Unicode escape sequences
function unidecode() {
  perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
  # print a newline unless we're piping the output to another program
  if [ -t 1 ]; then
    echo ""; # newline
  fi;
}

# @category: dev
# @desc: Open a file in vim, or the current directory if no arg given
function v() {
  if [ $# -eq 0 ]; then
    vim .;
  else
    vim "$@";
  fi;
}

# =============================================================================
# FILES
# =============================================================================

# @category: files
# @desc: Show size of a file or total size of a directory
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	# shellcheck disable=SC2199
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg -- .[^.]* *
	fi
}

# @category: files
# @desc: Create a new directory and enter it
mkd() {
	mkdir -p "$@"
	cd "$@" || exit
}

# @category: files
# @desc: List files modified in the last N days (default 1)
function modified() {
  find . -mtime -${1:-1}
}

# @category: files
# @desc: Create a .tar.gz archive using zopfli, pigz, or gzip
targz() {
	local tmpFile="${1%/}.tar"
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${1}" || return 1

	size=$(
	stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
	stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	)

	local cmd=""
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli"
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz"
		else
			cmd="gzip"
		fi
	fi

	echo "Compressing .tar using \`${cmd}\`…"
	"${cmd}" -v "${tmpFile}" || return 1
	[ -f "${tmpFile}" ] && rm "${tmpFile}"
	echo "${tmpFile}.gz created successfully."
}

# @category: files
# @desc: Create a temporary directory and enter it
tmpd() {
	local dir
	if [ $# -eq 0 ]; then
		dir=$(mktemp -d)
	else
		dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
	fi
	cd "$dir" || exit
}

# @category: files
# @desc: List directory tree, piped through less
function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less;
}

# =============================================================================
# GIT
# =============================================================================

# @category: git
# @desc: Run a git command across all nested git repos
function gitr() {
  local gitcmd=$1
  if [ -z "$gitcmd" ]; then
    echo "Usage: $0 <command>"
    return 0
  fi
  shift
  find . -name .git |
  while read i; do
    local dir=$(dirname $i)
    echo $dir
    git -C $dir $gitcmd $@
  done
}

# =============================================================================
# MACOS
# =============================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then

  # @category: macos
  # @desc: cd to the top-most Finder window location
  function cdf() { # short for `cdfinder`
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
  }

  # @category: macos
  # @desc: Open a file or directory with macOS open; defaults to current dir
  function o() {
    if [ $# -eq 0 ]; then
      open .;
    else
      open "$@";
    fi;
  }

  # @category: macos
  # @desc: Open an image in feh with auto-zoom and slideshow
  openimage() {
    local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

    cd "$(dirname "$1")" || exit
    local file
    file=$(basename "$1")

    feh -q "$types" --auto-zoom \
      --sort filename --borderless \
      --scale-down --draw-filename \
      --image-bg black \
      --start-at "$file"
  }

fi

# =============================================================================
# PRODUCTIVITY
# =============================================================================

# @category: productivity
# @desc: Log a completed task with a timestamp to ~/Documents/done.md
function did() {
  done_file=~/Documents/done.md
  timestamp="$(date +'%Y-%m-%d %H:%M:%S %A Week %V')"

  if [ -n "$*" ]
  then
    # log the entry from the command line
    message="$*"
    touch $done_file
    echo -e "### $timestamp\n- $message\n\n$(cat $done_file)" >| "$done_file"
  else
    # no entry input, do this in vim
    vim +"normal ggO$timestamp" +'normal o' +'normal ggo- ' +'startinsert!' "$done_file"
  fi

  # then show what I just added to that file - print everything up to the first blank line in the file
  echo ""
  # don't print automatically
  # once it hits a blank line quit (without printing the blank line)
  # otherwise print the non-blank line
  sed -n -e '/^$/ q' -e 'p' "$done_file"
}

# @category: productivity
# @desc: Summarize last week's done.md entries
function lastweek() {
  last_week=$(printf 'Week %02d' "$(( $(date +%V)-1 ))")
  done_file=~/Documents/done.md

  echo "$last_week Summary"

  sed -ne '
  # if empty line, check all held lines
  /^$/ b check_and_print
  # if at EOF, check all held lines
  $ b check_and_print
  # hold the line
  H
  # to the end, skip subroutine
  b
  :check_and_print
  # hold buffer to pattern buffer
  x
  # if pattern buffer has the right week number, print the buffer of all lines
  /'"$last_week"'/ pdif
  ' $done_file
}

# =============================================================================
# HELP
# =============================================================================

# @category: help
# @desc: List function categories (no args), functions for a category, or all functions sorted by category
fn-list() {
  local filter="${1:-}"
  local src="$DOTFILES/shell/50_functions.sh"

  if [[ -z "$filter" ]]; then
    awk '/^[[:space:]]*# @category:/ { print $3 }' "$src" | sort -u
    return
  fi

  if [[ "$filter" == "all" ]]; then
    awk '
      /^[[:space:]]*# @category:/ { cat = $3 }
      /^[[:space:]]*# @desc:/     { desc = substr($0, index($0, $3)) }
      /^[[:space:]]*(function[[:space:]]+)?[a-zA-Z_][a-zA-Z0-9_-]*[[:space:]]*\(\)/ {
        name = $0
        gsub(/^[[:space:]]*(function[[:space:]]+)?/, "", name)
        gsub(/[[:space:]]*\(\).*/, "", name)
        printf "%s\034%-22s %-14s %s\n", cat, name, "[" cat "]", desc
      }
    ' "$src" | sort | awk -F'\034' '
      BEGIN { prev = "" }
      {
        if ($1 != prev) {
          if (prev != "") print ""
          print "[" $1 "]"
          prev = $1
        }
        print "  " $2
      }
    '
    return
  fi

  awk -v filter="$filter" '
    /^[[:space:]]*# @category:/ { cat = $3 }
    /^[[:space:]]*# @desc:/     { desc = substr($0, index($0, $3)) }
    /^[[:space:]]*(function[[:space:]]+)?[a-zA-Z_][a-zA-Z0-9_-]*[[:space:]]*\(\)/ {
      name = $0
      gsub(/^[[:space:]]*(function[[:space:]]+)?/, "", name)
      gsub(/[[:space:]]*\(\).*/, "", name)
      if (cat == filter)
        printf "  %-22s %-14s %s\n", name, "[" cat "]", desc
    }
  ' "$src"
}
