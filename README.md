# Wraith

[![shellcheck](https://github.com/ngshiheng/wraith/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/ngshiheng/wraith/actions/workflows/shellcheck.yml)

A simple utility Bash script to backup [Ghost](https://github.com/TryGhost/Ghost) publishing platform.

## Context

Getting started with Ghost is easy. You would pick between:

-   [Managed](https://ghost.org/pricing/) service
-   Self-hosted on a [VPS](https://marketplace.digitalocean.com/apps/ghost) or serverless platform like [Railway](https://blog.railway.app/p/ghost)

Using managed version will most likely save you a bunch of headaches (and time) that come along with self-hosting any other sites:

-   Backups
-   Maintenance
-   Downtime recovery
-   Security, etc.

In short, you’d sleep easy at night while they stay awake.

Having that said, if you want to take on the challenge of self-hosting your own Ghost site, here's a tiny script to help with your backups.

[Read more...](https://jerrynsh.com/backing-up-ghost-blog-in-5-steps/)

## Table of Contents

- [Wraith](#wraith)
  - [Context](#context)
  - [Table of Contents](#table-of-contents)
  - [Flowchart](#flowchart)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Usage](#usage)
  - [FAQ](#faq)
  - [Contributing](#contributing)
  - [Support](#support)

## Flowchart

```mermaid
graph LR
  1(["start"]) --> 2["run checks"] --> 3["run `ghost backup`"] --> 4["run `mysqldump`"] --> 5["`rclone` backups to cloud storage"] --> 6["clean up"] --> 7(["end"])
```

## Requirements

> 💡 Tip: run `make check` to check if all requirements are installed.

A list of CLI required to be installed:

-   [`expect`](https://manpages.ubuntu.com/manpages/impish/man1/expect.1.html)
-   [`ghost`](https://ghost.org/docs/ghost-cli/)
-   [`gzip`](https://www.gnu.org/software/gzip/)
-   [`mysql`](https://www.mysql.com/)
-   [`rclone`](https://rclone.org/install/)

## Setup

> 💡 Tip: run `make help` to display help message.
>
> Check out the [Makefile](./Makefile)

Run `make setup` to set up [`rclone`](docs/FAQ.md#how-to-setup-rclone), `autoexpect`, and [`cron`](docs/FAQ.md#how-to-set-up-a-cron-job).

## Usage

1. Switch to the `ghost-mgr` user to manage Ghost using `sudo -i -u ghost-mgr`
2. SSH into your VPS where you host your Ghost site
3. [Set up Rclone](#set-up-rclone)
4. Clone this repository
5. Run [`./backup.sh`](backup.sh) from the repository directory (or run `make backup`)

## FAQ

See [FAQ.md](docs/FAQ.md).

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md).

## Support

Referrals:

-   [Digital Ocean](https://m.do.co/c/afdb6bd48884)
-   [Ghost](https://ghost.org/?via=jerry99)
