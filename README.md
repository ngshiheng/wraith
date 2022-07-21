# Wraith

A simple Bash script to backup [Ghost](https://github.com/TryGhost/Ghost).

> **Warning**
> This software comes with no warranties of any kind whatsoever, and may not be useful for anything. Use it at your own risk! I'd highly recommend anyone to use the official [Ghost(Pro)](https://ghost.org/pricing/) managed service instead.

- [Wraith](#wraith)
  - [Requirements](#requirements)
  - [Setup Rclone](#setup-rclone)
  - [How to use](#how-to-use)
  - [FAQ](#faq)
    - [What to backup](#what-to-backup)

## Requirements

A list of CLI needed to be installed:

-   [ ] [`ghost`](https://ghost.org/docs/ghost-cli/)
-   [ ] [`mysql`](https://www.mysql.com/)
-   [ ] [`rclone`](https://rclone.org/install/)
-   [ ] `gzip`
-   [ ] `tar`

## Setup Rclone

> Reference: https://rclone.org/

Install `rclone` using `curl -s https://rclone.org/install.sh | bash`

An example to configure Rclone with Google Drive:

1. Run `rclone config`
2. Follow https://rclone.org/drive/
3. If you're working on a remote machine (e.g. Digital Ocean droplet via SSH), say N for the auto config prompt and follow the instruction
4. Run `rclone lsd remote:/` to check your connection

## How to use

Simply run `./backup.sh`

## FAQ

### What to backup

> Reference: https://ghost.org/docs/ghost-cli/#ghost-backup

-   [ ] Your content in JSON format
-   [ ] A full member CSV export
-   [ ] All themes that have been installed including your current active theme
-   [ ] Images, files, and media (video and audio)
-   [ ] A copy of `routes.yaml` and `redirects.yaml` or `redirects.json`
