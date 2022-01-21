# import os
import std/random
import std/os

import mcu_utils/logging

import nephyr
import nephyr/core/zfifo

import version 

import apis/ta_atomics
import apis/ta_channels

when BOARD != "native_posix":
  import apis/ta_gpios

const
  SLEEP_TIME_MS* = 100
  MAX_SLEEP_MS* = 1_400

testsZkFifo() # template to setup zk fifo tests 

##  The devicetree node identifier for the "led0" alias.
const EMULATED_BOARDS = [
  "native_posix",
  "native_posix_64",
  # "qemu_cortex_m3",
]

when BOARD in ["qemu_cortex_m3"]:
  import nephyr/randoms
  proc z_impl_sys_csrand_get(dst: pointer, outlen: csize_t): cint {.exportc: "$1".}=
    sys_rand_get(dst, outlen)
    return 0

app_main():
  logNotice("Booting main application:", VERSION)
  echo("starting app...")

  when not (BOARD in EMULATED_BOARDS):
    runTestPins()

  runAtomics()
  runTestsChannelThreaded(20, 100)
  runTestsZkFifo()

  # echo "CONFIG BOARD: ", BOARD
  runTestsZkFifoThreaded(20, 100)
  # echo "CONFIG BOARD: ", BOARD
  when not BOARD.startsWith("native_posix"):
    runTestsZkFifoThreaded(7, 1200)

  echo "[[testing done]]"

  sysPanic(K_ERR_KERNEL_OOPS)
