# import os
import nativesockets
import net
import strutils, strformat
import os

import nephyr
import mcu_utils/logging

import taskServer
import rpc_server
import rpc_udp_server

import version 
import nephyr/drivers/gpio

const
  SLEEP_TIME_MS* = 100

##  The devicetree node identifier for the "led0" alias.
var
  LED0* = DT_GPIO_LABEL(tok"DT_ALIAS(led0)", tok"gpios")
  PIN* = DT_GPIO_PIN(tok"DT_ALIAS(led0)", tok"gpios")
  FLAGS* = DT_GPIO_FLAGS(tok"DT_ALIAS(led0)", tok"gpios")

proc blinky*() =
  var dev: ptr device
  var led_is_on: bool = true
  var ret: cint
  dev = device_get_binding(LED0)
  if dev == nil:
    return
  ret = gpio_pin_configure(dev, PIN, gpio_flags_t(GPIO_OUTPUT_ACTIVE or FLAGS))
  if ret < 0:
    return
  while true:
    discard gpio_pin_set(dev, PIN, led_is_on.cint)
    led_is_on = not led_is_on
    os.sleep(SLEEP_TIME_MS)
    printk("test!\n")


app_main():
  echo("Booting main application: " & VERSION)
  echo("starting app...")
  echo("threads app...")

  try:
    blinky()
  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  echo "unknown error causing reboot"
  sysReboot()
