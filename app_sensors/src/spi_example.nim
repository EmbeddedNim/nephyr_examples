
import zephyr/wrappers/devicetree
import zephyr/wrappers/drivers/spi
import zephyr/wrappers/dt_bindings/gpio_dt_defines

var dev: ptr device = device_get_binding("SPI_1")

proc setup*() =

  var cs_ctrl: ptr spi_cs_control =
        SPI_CS_CONTROL_PTR_DT(DT_NODELABEL(tok`spidev`), tok`2`)
  # var cs_ctrl = spi_cs_control(
  #   gpio_dev: DEVICE_DT_GET(DT_NODELABEL(gpio0)),
  #   delay: 0,
  #   gpio_pin: 6,
  #   gpio_dt_flags: GPIO_ACTIVE_LOW)

  var spi_cfg = spi_config(
        frequency: 3600000'u32,
        operation: SPI_WORD_SET(8) or SPI_TRANSFER_MSB or SPI_OP_MODE_MASTER,
        cs: cs_ctrl)
  
  echo "cs_ctrl: ", repr(cs_ctrl)
  echo "spi_cfg: ", repr(spi_cfg)


proc dw_transceive*(spi: ptr device; spi_cfg: ptr spi_config; command: uint8;
                   rx_buf: ptr uint8; rx_len: uint8) =
  var
    tx_buf: array[1, uint8] = [command]
    spi_buf_tx = spi_buf(buf: addr tx_buf, len: sizeof(tx_buf).csize_t)
    tx = spi_buf_set(buffers: addr(spi_buf_tx), count: 1)

    spi_buf_rx = [
      spi_buf(buf: nil, len: len(tx_buf).csize_t),
      spi_buf(buf: rx_buf, len: rx_len)
    ]

    rx = spi_buf_set(buffers: addr spi_buf_rx[0], count: 2)

  let ret = spi_transceive(spi, spi_cfg, addr(tx), addr(rx))
  echo "spi tx: ret: ", ret

proc spi_exec*(spi: ptr device, spi_cfg: ptr spi_config) =
  var rx_buf: array[32, uint8]

  dw_transceive(spi, spi_cfg, 0x00, addr rx_buf[0], sizeof(rx_buf).uint8)

  echo("Got DW1000 DEVID: ", repr rx_buf)

  dw_transceive(spi, spi_cfg, 0x01, addr rx_buf[0], rx_buf.sizeof.uint8)
  echo("Got DW1000 EUID: %02llX\n", repr rx_buf)
  dw_transceive(spi, spi_cfg, 0x03, addr rx_buf[0], rx_buf.sizeof.uint8)
  echo("Got DW1000 PANID: %02X\n", repr rx_buf)

  dw_transceive(spi, spi_cfg, 0x04, addr rx_buf[0], rx_buf.sizeof.uint8)
  var sys_cfg: uint32 = cast[ptr uint32](addr rx_buf[0])[]

  echo("sys_cfg: %08X\n", sys_cfg)
  if ((sys_cfg shr 9) and 1) != 0:
    echo("HIRQ_POL enabled\n")
  else:
    echo("HIRQ_POL disabled\n")
  if ((sys_cfg shr 12) and 1) != 0:
    echo("DIS_DRXB enabled\n")
  else:
    echo("DIS_DRXB disabled\n")

  dw_transceive(spi, spi_cfg, 0x06, addr rx_buf[0], rx_buf.sizeof.uint8)

  var sys_time: uint64 = (cast[ptr uint32](addr(rx_buf[1]))[] shl 8) + rx_buf[0]
  var sys_time1 = joinBytes64[uint64](rx_buf, 4, top=false)

  echo("SYS_TIME: ", sys_time, " SYS_TIME1: ", sys_time1)
