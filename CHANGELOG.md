# Change Log

## Purpose of this file

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog][web_changelog], and this project adheres to [Semantic Versioning][web_semver].

### Guiding principles

- ChangeLogs are _for humans_, not machines.
- There should be an entry for every single version with it's release date.
- The same types of changes should be grouped.
- The latest version comes first.
- Versions should be linkable.

### Types of Changes

- ![img_add] for new features
- ![img_mod] for changes in existing functionality
- ![img_upd] for updates in existing features
- ![img_dep] for soon-to-be-removed features
- ![img_del] for now removed features
- ![img_fix] for any bug fixes
- ![img_sec] in case of vulnerabilities

## Unreleased

> Please list here the soon-to-be-released features

## 0.2.5 - 2025-09-09

![img_upd]

- minor logging improvements

## 0.2.4 - 2025-09-05

![img_add]

- minor optimizations on logging
- folder permission evaluation

## 0.2.3 - 2025-08-30

![img_add]

- sample `env-vars.conf` & `docker-compose.yaml` files

![img_upd]

- tool-run script optimization (and renamed)
- entrypoint script optimization
- rename unpriviledged user and prepare to receive UID & GID
- move logging functions to separate file
- docker image & manifest build script to use `buildx`

## 0.2.2 - 2025-05-08

![img_fix]

- on cron schedule setup, crontab pid file could not be removed due to permissions

## 0.2.1 - 2025-05-08

![img_add]

- poppler onto the image

## 0.2.0 - 2024-09-23

![img_add]

- log_function on tool-run script to log start and end times of individual runs
- log_function on entry point script to log times of individual steps

![img_fix]

- on cron schedule setup, crontab schedule was not properly removed

## 0.1.1 - 2024-09-19

![img_fix]

- export config location to environment for scheduled runs

## 0.1.0 - 2024-09-18

![img_add]

- Fork Repo
- pre-commit-config.yaml
- ReadMe
- ChangeLog
- sample `config.yaml`
- docker image & manifest build script

![img_mod]

- bump Python version
- encapsulate tool into unpriviledged user
- prepare log folder
- allow sim command and crontab schedule via env vars
- encapsulate tool run in single script to be used by crontab and single runs consistently

<!-- change type images & links -->
[img_add]: https://img.shields.io/badge/-added-green.svg "Added"
[img_mod]: https://img.shields.io/badge/-changed-blue.svg "Changed"
[img_upd]: https://img.shields.io/badge/-updated-orange.svg "Updated"
[img_dep]: https://img.shields.io/badge/-deprecated-yellow.svg "Deprecated"
[img_del]: https://img.shields.io/badge/-removed-lightgrey.svg "Removed"
[img_fix]: https://img.shields.io/badge/-fixed-red.svg "Fixed"
[img_sec]: https://img.shields.io/badge/-security-red.svg "Security"
[web_changelog]: https://keepachangelog.com "Keep a Changelog"
[web_semver]: https://semver.org "Semantic Versioning"
