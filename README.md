# Dotfiles

A comprehensive dotfiles configuration for macOS, Linux, and Windows (via Cygwin/WSL). Includes shell configurations (Bash/Zsh), Vim setup, development environment managers (pyenv, nodenv, rbenv, goenv), and macOS system preferences.

## ⚡ Quick Start

### One-Line Installation

**Copy files to home directory:**
```sh
bash -c "$(curl -fsSL https://raw.github.com/gschaetz/dotfiles/master/bin/bootstrap)" -- copy
```

**Symlink files to home directory (recommended):**
```sh
bash -c "$(curl -fsSL https://raw.github.com/gschaetz/dotfiles/master/bin/bootstrap)" -- link
```

> **Note**: The `link` method is recommended as it allows you to pull updates from the repository without re-running installation.

## 📋 What's Included

### Shell Configuration

- **Bash & Zsh**: Modular shell configuration with shared scripts
- **Git Integration**: Enhanced git prompt with status indicators
- **Custom Aliases**: Intuitive shortcuts for common commands
- **Functions**: Utility functions for productivity
- **Version Managers**: pyenv, nodenv, rbenv, goenv support
- **Third-party Tools**: z (directory jumper), syntax highlighting, auto-suggestions

### Editor Configuration

- **Vim**: Comprehensive Vim configuration with Vundle plugin manager
- **Plugins**: Managed through `vimrc.bundles` with local override support

### Development Tools

- **Git**: Global gitconfig with sensible defaults and aliases
- **Python**: pyenv and pyenv-virtualenv integration
- **Node.js**: nodenv integration
- **Ruby**: rbenv integration  
- **Go**: goenv integration
- **Homebrew**: Brewfile for package management (macOS)

### Window Manager (Linux)

- **i3wm**: Complete i3 configuration with custom status bar and scripts

## 📁 Project Structure

```
dotfiles/
├── bin/                    # Bootstrap and initialization scripts
│   ├── bootstrap           # Main installation script
│   ├── dot-init-macOS      # macOS system preferences setup
│   └── dot-init-vim-plugins # Vim plugin initialization
│
├── link/                   # Files to be linked/copied to ~/.*
│   ├── bashrc              # Bash configuration
│   ├── zshrc               # Zsh configuration
│   ├── vimrc               # Vim configuration
│   ├── gitconfig           # Git global config
│   ├── tmux.conf           # Tmux configuration
│   ├── vim/                # Vim runtime files
│   ├── i3/                 # i3 window manager config
│   └── *env/               # Version manager configurations
│
├── shell/                  # Modular shell scripts
│   ├── *.sh                # Shared scripts (Bash & Zsh)
│   ├── bash/               # Bash-specific scripts
│   └── zsh/                # Zsh-specific scripts
│
├── templates/              # Template files for local customization
│   ├── gitconfig.local     # Local git configuration
│   ├── shell.flags         # Feature flags for shell
│   └── vim/                # Vim local configurations
│
├── thirdparty/             # Git submodules for external tools
│   ├── git-prompt/         # Enhanced git prompt
│   ├── pyenv/              # Python version manager
│   ├── nodenv/             # Node.js version manager
│   ├── rbenv/              # Ruby version manager
│   ├── goenv/              # Go version manager
│   ├── z/                  # Directory jumper
│   └── zsh-*/              # Zsh enhancements
│
└── Brewfile                # Homebrew package definitions (macOS)
```

## 🚀 Installation Methods

### Method 1: Link (Recommended)

Creates symbolic links from `~/.dotfiles/link/*` to `~/.*`

**Advantages:**
- Pull updates with `git pull` in `~/.dotfiles`
- Changes in repository immediately available
- Easy to track and version control customizations

**Installation:**
```sh
bash -c "$(curl -fsSL https://raw.github.com/gschaetz/dotfiles/master/bin/bootstrap)" -- link
```

### Method 2: Copy

Copies files from `~/.dotfiles/link/*` to `~/.*`

**Advantages:**
- Files are independent of the repository
- Can modify without affecting repository
- No symlink dependencies

**Installation:**
```sh
bash -c "$(curl -fsSL https://raw.github.com/gschaetz/dotfiles/master/bin/bootstrap)" -- copy
```

### What the Bootstrap Script Does

1. **Clones** the repository to `~/.dotfiles` (or updates if exists)
2. **Initializes** git submodules recursively
3. **Backs up** existing dotfiles to `~/.dotfiles/backups/YYYY_MM_DD-HH_MM_SS/`
4. **Links or copies** files from `link/` directory to your home directory
5. **Reports** backed up files and completion status

## ⚙️ Configuration

### Local Customization

Create local configuration files that won't be tracked in git:

#### Shell Customization

**Disable specific features:**
```sh
# ~/.shell.flags
export DISABLE_GIT_PROMPT=1
export DISABLE_PYENV=1
export DISABLE_NODENV=1
export DISABLE_RBENV=1
export DISABLE_GOENV=1
```

**Bash-specific:**
```sh
# ~/.bashrc.local
export MY_CUSTOM_VAR="value"
alias myalias="command"
```

**Zsh-specific:**
```sh
# ~/.zshrc.local
export MY_CUSTOM_VAR="value"
alias myalias="command"
```

#### Git Customization

```sh
# ~/.gitconfig.local
[user]
  name = Your Name
  email = your.email@example.com

[credential]
  helper = osxkeychain  # macOS
  # helper = cache --timeout=3600  # Linux
  # helper = wincred  # Windows

[http]
  proxy = http://proxy.example.com:8080
```

#### Vim Customization

```sh
# ~/.vim/vimrc.bundles.local
Plugin 'your/favorite-plugin'

# ~/.vim/vimrc.local
set number
colorscheme desert
```

### macOS System Setup

Configure macOS system preferences automatically:

```sh
~/.dotfiles/bin/dot-init-macOS
```

This script configures:
- System preferences (scrollbars, smart quotes, etc.)
- Keyboard settings (repeat rate, delay)
- Trackpad settings (tap to click, tracking speed)
- Finder preferences (show extensions, default views)
- Dock settings (autohide, position)
- Safari, Terminal, and other app settings
- Power management settings

**Review the script before running** to ensure settings match your preferences.

### Homebrew Package Management

Install all packages defined in Brewfile:

```sh
cd ~/.dotfiles
brew bundle
```

Clean up packages not in Brewfile:

```sh
brew bundle cleanup --force
```

## 🔧 Key Features

### Shell Scripts

The `shell/` directory contains modular scripts loaded by both Bash and Zsh:

| Script | Purpose |
|--------|---------|
| `10_support.sh` | Helper functions (`has_command`, etc.) |
| `20_brewpath.sh` | Homebrew PATH configuration |
| `50_functions.sh` | Utility functions (tre, calc, mkd, targz, etc.) |
| `50_git_prompt.sh` | Git prompt integration |
| `50_*env.sh` | Version manager initialization |
| `50_visual.sh` | VISUAL and EDITOR configuration |
| `50_z.sh` | z directory jumper |
| `90_aliases.sh` | Common aliases |

### Custom Functions

Available in your shell after installation:

- `tre` - Tree with colors, hidden files, and directories first
- `calc` - Simple calculator (e.g., `calc 2+2`)
- `mkd` - Make directory and cd into it
- `tmpd` - Create and cd into a temporary directory
- `targz` - Create compressed tar.gz archives
- Many more in `shell/50_functions.sh`

### Git Prompt

Shows repository status in your prompt:
- Current branch name
- Dirty state indicator
- Untracked files indicator
- Stash indicator
- Upstream status (ahead/behind)

Disable with: `export DISABLE_GIT_PROMPT=1` in `~/.shell.flags`

### Version Managers

Automatically initialized if thirdparty submodules exist:

```sh
# Install Python version
pyenv install 3.11.0
pyenv global 3.11.0

# Install Node.js version
nodenv install 18.0.0
nodenv global 18.0.0

# Install Ruby version
rbenv install 3.2.0
rbenv global 3.2.0

# Install Go version
goenv install 1.20.0
goenv global 1.20.0
```

## 📦 Included Packages (Brewfile)

Core utilities and tools installed via Homebrew:

- **Search & Text**: ack, ripgrep, the_silver_searcher, fzf
- **Development**: go, node, maven, rust, lua
- **Version Control**: git (configured separately)
- **Monitoring**: htop, ngrep, nmap
- **Build Tools**: cmake, coreutils, dos2unix
- **Container Tools**: kubernetes-cli, kubernetes-helm
- **Utilities**: jq, wget, tree, tmux, trash
- And more...

## 🎨 Vim Configuration

### Plugin Management

Plugins managed via [Vundle](https://github.com/VundleVim/Vundle.vim):

```sh
# Install/update plugins
~/.dotfiles/bin/dot-init-vim-plugins

# Or manually in Vim
:PluginInstall
```

Add custom plugins in `~/.vim/vimrc.bundles.local`

### Features

- Syntax highlighting and completion
- File explorer and fuzzy finder
- Git integration
- Whitespace management
- And more (see `link/vim/vimrc.bundles`)

## 🐧 Linux Support

### i3 Window Manager

Complete i3wm configuration included:
- Custom status bar with system info
- Keybindings and workspace management
- Compton compositor configuration
- Fuzzy lock screen script

Configuration location: `link/i3/`

### Font Support

Custom fonts included in `link/fonts/`

## 🪟 Windows Support

Works on Windows through:
- **Cygwin**: Full support
- **WSL**: Full support (Windows Subsystem for Linux)
- **Git Bash**: Partial support

Windows-specific scripts:
- `bin/bootstrap.cmd` - Windows batch file for installation
- `bin/bootstrap-windows-extra.cmd` - Additional Windows setup

## 🔄 Updating

If you used the **link** method:

```sh
cd ~/.dotfiles
git pull
git submodule update --init --recursive --remote
```

If you used the **copy** method:

```sh
# Re-run bootstrap to copy updated files
bash -c "$(curl -fsSL https://raw.github.com/gschaetz/dotfiles/master/bin/bootstrap)" -- copy
```

## 🛠️ Maintenance

### Updating Submodules

```sh
cd ~/.dotfiles
git submodule update --init --recursive --remote
```

### Backing Up Before Changes

The bootstrap script automatically creates backups, but you can manually backup:

```sh
cp -r ~/.dotfiles ~/.dotfiles.backup.$(date +%Y%m%d)
```

### Cleaning Up

Remove dotfiles (backup first!):

```sh
# Remove symlinks
find ~ -maxdepth 1 -type l -ls | grep .dotfiles

# Or remove copied files
# (Be careful - this will remove ALL dotfiles!)
```

## 🤝 Contributing

Feel free to fork this repository and customize it for your own use. If you have improvements or fixes, pull requests are welcome!

## 📄 License

This dotfiles configuration is available for personal use. Modify as needed for your environment.

## 🙏 Acknowledgments

Based on and inspired by many excellent dotfiles repositories:
- [square/maximum-awesome](https://github.com/square/maximum-awesome)
- [tpope/vim-sensible](https://github.com/tpope/vim-sensible)
- [spf13/spf13-vim](https://github.com/spf13/spf13-vim)
- Original inspiration from [guckes.net](http://www.guckes.net/vim/)

## 💡 Tips

1. **Start Fresh**: Try in a VM or fresh user account first
2. **Review Scripts**: Read `bin/dot-init-macOS` before running on macOS
3. **Customize Gradually**: Start with defaults, then add local customizations
4. **Keep Submodules Updated**: Regular `git submodule update` for latest versions
5. **Use Local Files**: Always use `*.local` files for personal customizations
6. **Check Shell Flags**: Use `~/.shell.flags` to disable unwanted features


