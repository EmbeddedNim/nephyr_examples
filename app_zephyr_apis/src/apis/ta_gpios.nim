import os
import system

import nephyr
import nephyr/drivers/gpio
import nephyr/drivers/device

proc runTestPins*() =
  echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< "
  echo "[GPIO] Begin "

  let pin10 = initPin(alias"led0", Pins.OUT)
  echo "pin10: ", repr pin10
  pin10.level(1)
  echo "pin10: ", $pin10.level()

  # for dev in listAllStaticDevices():
  #   echo "device: ", repr(dev)


  # let pin20 = initPinLbl("GPIOE", Pins.OUT)
  # echo "pin20: ", repr pin20
  # pin20.level(0)
  # echo "pin20: ", $pin20.level()

  echo "[GPIO] Done "
  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "
