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

##  The devicetree node identifier for the "led0" alias.
testsZkFifo()

app_main():
  logNotice("Booting main application:", VERSION)
  echo("starting app...")

  when not BOARD.startsWith("native_posix"):
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

  # sysReboot()
  sysPanic(K_ERR_KERNEL_OOPS)
