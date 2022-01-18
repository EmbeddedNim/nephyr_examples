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

app_main():
  logNotice("Booting main application:", VERSION)
  echo("starting app...")

  try:
    runAtomics()
    testsZkFifo()
  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
    echo "unknown error causing reboot"
    sysReboot()

  sysReboot()
