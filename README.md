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
  - [Contributing](#contributing)

## Requirements

A list of CLI needed to be installed:

-   [`ghost`](https://ghost.org/docs/ghost-cli/)
-   [`mysql`](https://www.mysql.com/)
-   [`rclone`](https://rclone.org/install/)
-   `gzip`
-   `tar`

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

1. Your content in JSON format
2. A full member CSV export
3. All themes that have been installed including your current active theme
4. Images, files, and media (video and audio)
5. A copy of `routes.yaml` and `redirects.yaml` or `redirects.json`

And your MySQL database.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

1. Fork this
2. Create your feature branch (`git checkout -b feature/bar`)
3. Commit your changes (`git commit -am 'feat: add some bar'`, make sure that your commits are [semantic](https://www.conventionalcommits.org/en/v1.0.0/#summary))
4. Push to the branch (`git push origin feature/bar`)
5. Create a new Pull Request
