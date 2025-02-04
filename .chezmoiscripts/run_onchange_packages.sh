#!/bin/bash

echo "Installing packages"
echo "Do you want to start the packages installation script (requires sudo)? (yes/no)"
read -r answer

if [ "$answer" != "yes" ]; then
  echo "Exiting without running the script."
  exit 0
fi

sudo apt-get install 7z jq poppler zsh ripgrep openssl tmux git curl build-essential
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

curl https://sh.rustup.rs -sSf | sh
rustup component add rust-analyzer
cargo install bob-nvim
cargo install --locked yazi-fm yazi-cli
cargo install fd-find

bob use nightly
sudo apt-get install nodejs xclip

sudo apt-get install bear llvm libclang-dev
curl -sS https://starship.rs/install.sh | sh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install zk
brew install fzf
# brew install ripgrep

# Install github command line tool
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
  sudo mkdir -p -m 755 /etc/apt/keyrings &&
  out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
  cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt update &&
  sudo apt install gh -y
