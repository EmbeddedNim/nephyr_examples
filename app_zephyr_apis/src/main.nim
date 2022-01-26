# import os
import std/random
import std/os

import mcu_utils/logging

import nephyr
import nephyr/core/zfifo
import nephyr/times

import version 

import apis/ta_atomics
import apis/ta_channels

const
  SLEEP_TIME_MS* = 100
  MAX_SLEEP_MS* = 1_400

testsZkFifo() # template to setup zk fifo tests 

##  The devicetree node identifier for the "led0" alias.
const EMULATED_BOARDS = [
  "native_posix",
  "native_posix_64",
  "qemu_cortex_m3",
]

when BOARD in ["qemu_cortex_m3"]:
  import nephyr/randoms
  proc z_impl_sys_csrand_get(dst: pointer, outlen: csize_t): cint {.exportc: "$1".}=
    sys_rand_get(dst, outlen)
    return 0

when not (BOARD in EMULATED_BOARDS):
  import apis/ta_gpios

app_main():
  logNotice("Booting main application:", VERSION)
  echo("starting app... " & repr(millis()))
  echo("TS: " & repr(millis()))
  os.sleep(1_000)

  when not (BOARD in EMULATED_BOARDS):
    runTestPins()

  runAtomics()
  echo("TS: " & repr(millis()))
  runTestsChannelThreaded(20, 100)
  echo("TS: " & repr(millis()))
  runTestsZkFifo()

  echo("TS: " & repr(millis()))
  runTestsZkFifoThreaded(20, 100)
  when not BOARD.startsWith("native_posix"):
    echo "[runTestsZkFifoThreaded: out of order tests]"
    runTestsZkFifoThreaded(7, 1200)

  when CONFIG_NET:
    runTestsSocketPairsThreaded(7, 1200)

  echo("TS: " & repr(millis()))
  echo "[[testing done]]"

  sysPanic(K_ERR_KERNEL_OOPS)
