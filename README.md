# dotfiles

Create the chezmoi config for your machine:

```toml
# .config/chezmoi/chezmoi.toml
encryption = "gpg"
[gpg]
recipient = "dronakurl@mail.com"

[git]
autoCommit = false
autoPush = false

[data]
email = ""
smtpserver = ""
```

Run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply Dronakurl
```

Or in one go:

```bash
sh -c '
mkdir -p ~/.config/chezmoi
cat <<EOF > ~/.config/chezmoi/chezmoi.toml
encryption = "gpg"
[gpg]
recipient = "dronakurl@mail.com"

[git]
autoCommit = false
autoPush = false

[data]
email = ""
smtpserver = ""
EOF

sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply Dronakurl
'
```
