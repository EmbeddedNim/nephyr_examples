# import os
import std/random
import std/os

import mcu_utils/logging

import nephyr
import nephyr/drivers/gpio

import version 

const
  SLEEP_TIME_MS* = 100

##  The devicetree node identifier for the "led0" alias.

proc blinky*() =
  var led0 = initPin(alias"led0", Pins.OUT)
  echo "led0: ", repr led0
  var led_state = 0
  while true:
    led0.level(led_state)
    led_state = (led_state + 1) mod 2
    let dts = rand(10*SLEEP_TIME_MS)
    os.sleep(dts)
    printk("blink!\n")

app_main():
  logNotice("Booting main application:", VERSION)
  echo("starting app...")

  randomize()
  try:
    blinky()
  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  echo "unknown error causing reboot"
  sysReboot()
