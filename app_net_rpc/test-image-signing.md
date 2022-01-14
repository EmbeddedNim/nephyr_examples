
Directions at: https://www.methodpark.de/blog/a-setup-for-firmware-updates-over-the-air-part-3-wireless-sensor-nodes-mcuboot/

```sh
 $ west sign -t imgtool -p ${MCUBOOT}/scripts/imgtool.py -d build_nrf52/ -- --key ${MCUBOOT}/root-rsa-2048.pem 
```

```sh
=== image configuration:
partition offset: 49152 (0xc000)
partition size: 204800 (0x32000)
rom start offset: 512 (0x200)
=== signing binaries
unsigned bin: /home/elcritch/projects/rtos/dumb_http_server/build_nrf52/zephyr/zephyr.bin
signed bin:   /home/elcritch/projects/rtos/dumb_http_server/build_nrf52/zephyr/zephyr.signed.bin
unsigned hex: /home/elcritch/projects/rtos/dumb_http_server/build_nrf52/zephyr/zephyr.hex
signed hex:   /home/elcritch/projects/rtos/dumb_http_server/build_nrf52/zephyr/zephyr.signed.hex
```

status: nrf52 flashed ok -- booting


 $ west sign -t imgtool -p ${MCUBOOT}/scripts/imgtool.py -d build_nrf52/ -- --key ${MCUBOOT}/root-rsa-2048.pem 

${MCUBOOT}/scripts/imgtool.py sign --key ${MCUBOOT}/root-rsa-2048.pem --header-size 0x200 --align 8 --version 1.3 --slot-size 0x32000 --pad build/zephyr/zephyr.bin build/image-${BOARD}.signed.bin

pyocd flash -a 0x3e000 -t nrf52 build/image-nrf52_adafruit_feather.signed.bin