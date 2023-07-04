## FAQ

- [FAQ](#faq)
  - [What to backup?](#what-to-backup)
  - [What is the difference between `wraith` and `ghost backup` command?](#what-is-the-difference-between-wraith-and-ghost-backup-command)
  - [Does `wraith` work on Ghost version x.yy.zz?](#does-wraith-work-on-ghost-version-xyyzz)
  - [How to set up Rclone?](#how-to-set-up-rclone)
  - [How to set up a Cron job?](#how-to-set-up-a-cron-job)
  - [What is the `expect` script for?](#what-is-the-expect-script-for)
  - [How to test and restore backup?](#how-to-test-and-restore-backup)

### What to backup?

> Reference: [ghost.org/docs/ghost-cli/#ghost-backup](https://ghost.org/docs/ghost-cli/#ghost-backup)

1. Your content in JSON format
2. A full member CSV export
3. All themes that have been installed including your current active theme
4. Images, files, and media (video and audio)
5. A copy of `routes.yaml` and `redirects.yaml` or `redirects.json`
6. MySQL database

### What is the difference between `wraith` and `ghost backup` command?

Starting Ghost-CLI version: 1.21.0 they started supporting `ghost backup` command. However, the current `ghost backup` command does not include a backup of MySQL by default.

`wraith` now invokes `ghost backup` under the hood.

### Does `wraith` work on Ghost version x.yy.zz?

`wraith` was last developed & tested on:

```sh
# ghost version
Ghost-CLI version: 1.24.1
Ghost version: 5.52.1 (at /var/www/ghost)

# mysql --version
mysql  Ver 8.0.33-0ubuntu0.20.04.2 for Linux on x86_64 ((Ubuntu))

# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.5 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.5 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```

### How to set up Rclone?

1. Install `rclone` using `curl -s https://rclone.org/install.sh | bash`
2. Run `rclone config`
3. Name your remote `remote`
4. Check https://rclone.org//#providers and use the cloud provider of your choice
5. If you're working on a remote machine without a browser (e.g. Digital Ocean Droplet via SSH), say `N` for the auto config prompt. Follow through the instructions
6. Run `rclone lsd remote:/` to check your connection

An example to configure Rclone with Google Drive ([reference](https://rclone.org/drive/)).

_NOTE: If you're getting `Error 403:rate_limit_exceeded` error, [read this](https://forum.rclone.org/t/google-drive-error-403-rate-limit-exceeded-when-authorizing-rclone/34565/2)._

### How to set up a Cron job?

> Reference: [crontab.guru](https://crontab.guru/every-week)

1. Add a `crontab -e` item
2. For this example, we will back up the data every week: `0 0 * * 0 cd /$HOME/wraith/ && ./backup.sh`

### What is the `expect` script for?

In the [`expect` script](../wraith.example.exp), we set the email and password variables to your email address and password, respectively. Then we spawn the `ghost backup` command.

The script uses expect to wait for specific patterns in the output. When it sees the pattern "Ghost administrator email address", it sends the email using send. Similarly, when it sees the pattern "Ghost administrator password", it sends the password. The \r is used to simulate pressing the Enter key.

_NOTE: Make sure you have the expect package installed on your system before running the script._

### How to test and restore backup?

> "Backups are not backups unless you have tested restoring from them."

Let's test our backup locally using [Docker](https://hub.docker.com/_/ghost).

1. At a new directory, copy your `backup-from-vA.BB.Z-on-YYYY-MM-DD-HH-MM-SS` backup file there. Decompress the backup files using `unzip`
2. Run Ghost locally using `docker run -d --name some-ghost -e url=http://localhost:3001 -p 3001:2368 -v /path/to/images:/var/lib/ghost/content/images ghost` to restore the blog images
3. Visit [`localhost:3001/ghost`](http://localhost:3001/ghost) to create an admin account
4. From the Ghost Admin interface ([`localhost:3001/ghost/#/settings/labs`](http://localhost:3001/ghost/#/settings/labs)), import your JSON Ghost blog content from decompressed `data/`
5. You can import your members CSV from the Members page too

Tip: run `bash` within your Ghost Docker container using `docker exec -it some-ghost bash`
