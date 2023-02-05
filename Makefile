NAME := wraith
SHELL=/bin/bash

# Requirements
CURL = $(shell command -v curl 2> /dev/null)
EXPECT = $(shell command -v expect 2> /dev/null)
GHOST = $(shell command -v ghost 2> /dev/null)
GZIP = $(shell command -v gzip 2> /dev/null)
MYSQL = $(shell command -v mysql 2> /dev/null)
RCLONE = $(shell command -v rclone 2> /dev/null)
TAR = $(shell command -v tar 2> /dev/null)

.DEFAULT_GOAL := help

##@ Helper
.PHONY: help
help:	## display this help message.
	@echo "Welcome to $(NAME)"
	@awk 'BEGIN {FS = ":.*##"; printf "Use make \033[36m<target>\033[0m where \033[36m<target>\033[0m is one of:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: check
check: ## check if all requirements are installed.
	@if [ -z $(CURL) ]; then echo "`curl` could not be found. See https://curl.se/download.html"; exit 2; fi
	@if [ -z $(EXPECT) ]; then echo "`expect` could not be found. See https://howtoinstall.co/en/expect"; exit 2; fi
	@if [ -z $(GHOST) ]; then echo "`ghost` could not be found. See https://ghost.org/docs/ghost-cli/"; exit 2; fi
	@if [ -z $(GZIP) ]; then echo "`gzip` could not be found. See https://www.gnu.org/software/gzip/"; exit 2; fi
	@if [ -z $(MYSQL) ]; then echo "`mysql` could not be found. See https://dev.mysql.com/doc/"; exit 2; fi
	@if [ -z $(RCLONE) ]; then curl -s https://rclone.org/install.sh | bash; fi
	@if [ -z $(TAR) ]; then echo "`tar` could not be found. See https://www.gnu.org/software/tar/"; exit 2; fi
	@echo "Passed requirements checks"

##@ Usage
.PHONY: setup
setup: check	## setup rclone, autoexpect, and cron.
	@echo "Configuring rlcone..."
	rclone config
	@echo "Setting up ghost backup with autoexpect..."
	cd /var/www/ghost && autoexpect -f ghostbackup.exp ghost backup && cd ~
	@echo "Set up a cron job..."
	(crontab -l 2>/dev/null; echo "0 4 * * 1 cd ~/wraith/ && ./backup.sh") | crontab -

.PHONY: backup
backup:	## run backup script.
	@./backup.sh
