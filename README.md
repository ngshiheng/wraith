# Wraith

[![shellcheck](https://github.com/ngshiheng/wraith/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/ngshiheng/wraith/actions/workflows/shellcheck.yml)

A simple utility Bash script to backup [Ghost](https://github.com/TryGhost/Ghost) publishing platform.

> 💡 Tip: run `make help` to display help message.
>
> Check out the [Makefile](./Makefile)

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
  - [Set up Rclone](#set-up-rclone)
  - [How to use](#how-to-use)
  - [Set up a Cron job](#set-up-a-cron-job)
  - [Testing and restoring backup](#testing-and-restoring-backup)
  - [FAQ](#faq)
  - [Contributing](#contributing)

## Flowchart

```mermaid
graph LR
  1(["start"]) --> 2["run checks"] --> 3["tar content/"] --> 4["run mysqldump"] --> 5["rclone zip files to cloud storage"] --> 6["clean up"] --> 7(["end"])
```

## Requirements

> 💡 Tip: run `make check` to check if all requirements are installed.

A list of CLI needed to be installed:

-   [`ghost`](https://ghost.org/docs/ghost-cli/)
-   [`mysql`](https://www.mysql.com/)
-   [`rclone`](https://rclone.org/install/)
-   [`gzip`](https://www.gnu.org/software/gzip/)
-   [`tar`](https://www.gnu.org/software/tar/)

## Set up Rclone

> 💡 Tip: run `make setup`.

> **Note**
> Install `rclone` using `curl -s https://rclone.org/install.sh | bash`
>
> An example to configure Rclone with Google Drive ([reference](https://rclone.org/drive/)):

1. Run `rclone config`
2. Name your remote `remote`
3. Follow [rlcone.org/drive](https://rclone.org/drive/)
4. If you're working on a remote machine without a browser (e.g. Digital Ocean Droplet via SSH), say `N` for the auto config prompt. Follow through the instructions
5. Run `rclone lsd remote:/` to check your connection

## How to use

> **Note**
> Switch to the `ghost-mgr` user to manage Ghost using `sudo -i -u ghost-mgr`

1. SSH into your VPS where you host your Ghost site
2. [Set up Rclone](#set-up-rclone)
3. Clone this repository
4. Run [`./backup.sh`](backup.sh) from the repository directory

## Set up a Cron job

> Reference: [crontab.guru](https://crontab.guru/every-week)

1. Add a `crontab -e` item
2. For this example, we will back up the data every week: `0 0 * * 0 cd /$HOME/wraith/ && ./backup.sh`

## Testing and restoring backup

> Backups are not backups unless you have tested restoring from them.

Let's test our backup locally using [Docker](https://hub.docker.com/_/ghost).

1. At a new directory, copy your `ghost_content_YYYY_MM_DD_HHMM.tar.gz` backup file there. Decompress the backup files using `tar -xvf`
2. Run Ghost locally using `docker run -d --name some-ghost -e url=http://localhost:3001 -p 3001:2368 -v /path/to/images:/var/lib/ghost/content/images ghost` to restore the blog images
3. Visit [`localhost:3001/ghost`](http://localhost:3001/ghost) to create an admin account
4. From the Ghost Admin interface ([`localhost:3001/ghost/#/settings/labs`](http://localhost:3001/ghost/#/settings/labs)), import your JSON Ghost blog content from decompressed `data/`
5. You can import your members CSV from the Members page too

Tip: run `bash` within your Ghost Docker container using `docker exec -it some-ghost bash`

## FAQ

See [FAQ.md](docs/FAQ.md).

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md).
