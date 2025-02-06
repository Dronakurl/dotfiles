# dotfiles

Run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

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
