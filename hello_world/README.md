# Nephyr Example App

Basic sample application for running Nim on Zephyr with networking. Includes the CMakeFiles settings to make everything work. 

Supports Mikroe Click feather wing's using various ethernet boards. 

See `Makefile` for build rules. This will be simplified in the future. 

## Shortcuts

First time setup:
```sh
nimble install
```

Run and flash board:
```sh
# source env variables, e.g. $BOARD
source envs/default-feather-nrf52840.env

# lists available build tasks
nimble tasks 

# compile Nim to C code
nimble zephyr_compile

# compile Zephyr project based on env file variables
# will also rebuild Nim if needed
nimble zephyr_build

# flash to board 
nimble zephyr_flash

```

Nim requires the `devel` branch:

```sh
asdf install nim 'ref:devel'
```
