# import os
import std/random
import std/os

import mcu_utils/logging

import nephyr
import nephyr/core/zfifo

import version 

import apis/atomics

const
  SLEEP_TIME_MS* = 100
  MAX_SLEEP_MS* = 1_400

##  The devicetree node identifier for the "led0" alias.
testsZkFifo()

app_main():
  logNotice("Booting main application:", VERSION)
  echo("starting app...")

  runAtomics()
  # runTestsZkFifo()
  runTestsZkFifoThreaded()

  echo "[testing done]"

  # sysReboot()
  sysPanic()
