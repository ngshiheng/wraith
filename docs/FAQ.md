## FAQ

### What to backup

> Reference: [ghost.org/docs/ghost-cli/#ghost-backup](https://ghost.org/docs/ghost-cli/#ghost-backup)

1. Your content in JSON format
2. A full member CSV export
3. All themes that have been installed including your current active theme
4. Images, files, and media (video and audio)
5. A copy of `routes.yaml` and `redirects.yaml` or `redirects.json`
6. MySQL database

### What is the difference between Wraith and `ghost backup` command

Starting Ghost-CLI version: 1.21.0 they started supporting `ghost backup` command. However, the current `ghost backup` command does not support MySQL dump.
