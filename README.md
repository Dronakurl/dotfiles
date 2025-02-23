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
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Dronakurl
```

