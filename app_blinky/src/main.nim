# import os
import std/random
import std/os
import std/strformat

import mcu_utils/logging

import nephyr
import nephyr/drivers/gpio

import hal_ads131e08

import version 

const
  SLEEP_TIME_MS* = 100
  MAX_SLEEP_MS* = 1_400

##  The devicetree node identifier for the "led0" alias.
proc blinky*() =
  var led0 = initPin(alias"led0", Pins.OUT)
  echo "led0: ", repr led0

  adsSpiSetup()
  # setupADS()

  adsReset()
  adsSendCMD(CMD.SDATAC)
  adsSendCMD(CMD.STOP)
  adsSendCMD(CMD.RDATA)

  var res = adsReadReg(REG.ID)
  loginfo("ads reg:id: ", res.toHex())

  adsWriteReg(CONFIG1,0x96) #1kHz

  res = adsReadReg(REG.CONFIG1)
  loginfo("ads reg:config1: ", res.toHex())

  res = adsReadReg(REG.CONFIG1)
  loginfo("ads reg:config1: ", res.toHex())

  var led_state = 0
  var delay = 0'u
  while true:
    led0.level(led_state)
    led_state = (led_state + 1) mod 2
    delay = (delay + SLEEP_TIME_MS) mod MAX_SLEEP_MS
    os.sleep(delay.int)
    logInfo("blink!", "delay:", delay)

    # let res = adsReadChannels()
    # loginfo("ads reg:config1: ", repr res)
    res = adsReadReg(REG.CONFIG1)
    loginfo("ads reg:config1: ", res.toHex())

app_main():
  logNotice("Booting main application:", VERSION)
  echo("starting app...")

  try:
    blinky()
  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  echo "unknown error causing reboot"
  sysReboot()
