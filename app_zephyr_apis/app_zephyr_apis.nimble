# Package

version       = "0.1.0"
author        = "Embedded Nim"
description   = "Nim wrapper for Zephyr RTOS"
license       = "Apache-2.0"
srcDir        = "src"

# Dependencies

requires "nim >= 1.4.8"
requires "msgpack4nim >= 0.3.1"

requires "https://github.com/EmbeddedNim/nephyr#main"

# includes nimble tasks for building Zephyr/west projects
include nephyr/build_utils/tasks

