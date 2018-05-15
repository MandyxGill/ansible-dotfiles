#!/bin/bash

# Set binary paths
$brew_path="/usr/local/bin/brew"

# Set up proxies
if [ "$1" == "intel" ]; then
	export https_proxy="http://proxy-chain.intel.com:912"
	export http_proxy=$https_proxy
fi

# Install Homebrew
/usr/bin/ruby -e "$(
	curl -fsSL \
	https://raw.githubusercontent.com/Homebrew/install/master/install
)"

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# Install GNU utilities
"$brew_path" install gmp
"$brew_path" install coreutils --with-gmp
"$brew_path" install gnupg --with-gpg-zip --with-readline
"$brew_path" install --with-default-names \
  findutils \
  grep \
  gnu-sed \
  gnu-tar \

# Install shell utilities
"$brew_path" install \
  zsh \
  zsh-completions \
  zsh-syntax-highlighting \
  source-highlight \
  tree \
  tmux \

# Add Homebrew zsh path to /etc/shells
/usr/local/bin/grep -E '^/usr/local/bin/zsh$' /etc/shells &> /dev/null
rc="$?"
if [ "$rc" -ne 0 ]; then
    echo "/usr/local/bin/zsh" \
      | sudo /usr/local/opt/coreutils/libexec/gnubin/tee -a /etc/shells
fi

# Change user default shell to Homebrew zsh
/usr/bin/chsh -s /usr/local/bin/zsh

# Install CLI applications that don't have dependencies
"$brew_path" install \
  ansible \
  aria2 \
  cask \
  htop \
  neovim \
  pandoc \
  picocom \
  sipcalc \
  wget \

# Install rmtree
"$brew_path" tap beeftornado/rmtree

# Install Homebrew-Cask
"$brew_path" tap caskroom/cask

# Install Source Code Pro
"$brew_path" tap caskroom/fonts && "$brew_path" cask install font-source-code-pro

# Install GUI applications
"$brew_path" cask install \
  displaycal \
  firefox \
  flash-npapi \
  gotomeeting \
  insomniaX \
  mpv \
  slack \
  switchresx \

# Install kitty
# ImageMagick required for viewing images using 'kitty icat'
"$brew_path" install imagemagick \
  && "$brew_path" cask install kitty

# Install virt-manager and virt-viewer
# xquartz is a dependency for both
# Potential issues:
# https://github.com/jeffreywildman/homebrew-virt-manager/issues/76
# https://github.com/jeffreywildman/homebrew-virt-manager/issues/81
"$brew_path" cask install xquartz \
  && "$brew_path" tap jeffreywildman/homebrew-virt-manager \
  && "$brew_path" install virt-manager virt-viewer

# Install sshfs
# osxfuse is a dependency
"$brew_path" cask install osxfuse && "$brew_path" install sshfs

# Disable DS_Store file creation on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Disable DS_Store file creation on USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores true

