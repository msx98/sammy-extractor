# sammy-extractor

Fetches the latest firmware from Samsung using SamLoader, then extracts proprietary blobs from it.

## Requirements

### LineageOS device tree
### SamLoader by nlscc (https://github.com/nlscc)
Install via pip:
`pip3 install git+https://github.com/nlscc/samloader.git`
### simg2img
Available on default repos in Debian 10


## /config directory

**firmware.txt** - fetched by script, no need to touch this

All of the files mentioned below must be manually adjusted by the user prior to using this script for the first time:

**linux_username.txt** - check this with "whoami" in the terminal as non-root

**region.txt** - your geographical region, e.g. ILO

**model.txt** - your device model, e.g. SM-G970F

**path_repo.txt** - relative path to the rom source tree

**path_extract_script.txt** - path to extract script, relative to repo base

**path_folder_proprietary.txt** - path to proprietary blobs folder, relative to repo base


## Scripts

**download.sh** - simply fetches the latest firmware with your configuration

**unpack.sh** - unpacks system.img, vendor.img and makes them mountable

**blobs.sh** - extracts blobs and moves them to source tree

Must be run as root

**flash.sh** - flashes the latest firmware

First parameter must be firmware name
