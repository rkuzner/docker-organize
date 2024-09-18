# About

A Dockerized version of the file management utility [Organize](https://github.com/tfeldmann/organize)

## Usage

Image can be used for single runs or for recurring scheduled runs with crontab.

### Paths

The image works (and uses) the following paths actively:

- config: directory where yaml rule file is stored
- logs: directory where running logs will be stored
- data: directory with files that you want to process
- source: (base) directory with files that you want to process
- target: (base) directory for move and copy operations
`data`, `source` & `target` volumes may be used at your discretion, they are *optional* mappings, keep in mind carefuly referencing them on the organize-tool config files.

## Single Run Example

``` bash
docker run -it --name docker-organize
 -v "/path/to/config/":/config
 -v "/path/to/logs/":/logs
 -v "/data-folder/":/data
 -v "/source-folder/":/source
 -v "/target-folder/":/target
 docker-organize
```

### Single Run Simulation Example

``` bash
docker run -it --name docker-organize
 -v "/path/to/config/":/config
 -v "/path/to/logs/":/logs
 -v "/data-folder/":/data
 -v "/source-folder/":/source
 -v "/target-folder/":/target
 -e ORGANIZE_COMMAND=sim
 docker-organize
```

## Recurring Scheduled Run Example (using crontab within the image)

``` bash
docker run -dit --rm --name docker-organize
 -v "/path/to/config/":/config
 -v "/path/to/logs/":/logs
 -v "/data-folder/":/data
 -v "/source-folder/":/source
 -v "/target-folder/":/target
 -e ORGANIZE_SCHEDULE="0 3 * * *"
 docker-organize
```

Other sample crontab schedules:

- `0 0,6,12,18 * * *` - Every 6 hours on the hour starting at midnight
- `0 12 * * 1,3,5` - At noon every Monday, Wednesday and Friday

More configurations can be generated at [Crontab Guru](https://crontab.guru/#0_3_*_*_*)
