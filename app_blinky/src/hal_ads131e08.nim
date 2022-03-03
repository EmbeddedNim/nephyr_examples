
import nephyr/utils
import zephyr_c/zdevicetree
import zephyr_c/drivers/zspi
import sequtils
import nephyr/drivers/gpio


var
  cs_ctrl: spi_cs_control
  spi_cfg: spi_config
  spi_dev: ptr device
  ndrdy:   Pin
  tx_buf: array[100,uint8]
  rx_buf: array[100,uint8]

type
  CMD* {.pure.} = enum
    WAKEUP    =0x02,
    STANDBY   =0x04,
    RESET     =0x06,
    START     =0x08,
    STOP      =0x0A,
    RDACTAC   =0x10,
    SDATAC    =0x11,
    RDATA     =0x12,
    OFFSETCAL =0x1A,
    RREG      =0x20,
    WREG      =0x40

type
  REG* {.pure.} = enum
    ID          =0x00,
    CONFIG1     =0x01,
    CONFIG2     =0x02,
    CONFIG3     =0x03,
    FAULT       =0x04,
    CH1SET      =0x05,
    CH2SET      =0x06,
    CH3SET      =0x07,
    CH4SET      =0x08,
    CH5SET      =0x09,
    CH6SET      =0x0A,
    CH7SET      =0x0B,
    CH8SET      =0x0C,
    FAULT_STATP =0x12,
    FAULT_STATN =0x13,
    GPIO        =0x14

proc spi_debug() =
  echo "======="
  echo "\ncs_ctrl: ", repr(cs_ctrl)
  echo "\nspi_cfg: ", repr(spi_cfg)
  echo "\nspi_device: ", repr(spi_dev)
  echo "======="

proc adsSpiSetup*() =

  spi_dev = DEVICE_DT_GET(DT_NODELABEL(tok"mikrobus_spi"))
  cs_ctrl = SPI_CS_CONTROL_PTR_DT(DT_NODELABEL(tok"ads131e08"), tok`2`)[]

  spi_cfg = spi_config(
        frequency: 4_000_000'u32, #Fail on this spin of NRF52840, upclock to 20MHz for other MCU's
        operation: SPI_WORD_SET(8) or SPI_TRANSFER_MSB or SPI_OP_MODE_MASTER or SPI_MODE_CPHA,
        cs: addr cs_ctrl)
  
  ndrdy = initPin(alias"ndrdy",Pins.IN) #GPIO_DT_SPEC_GET(DT_NODELABEL(tok"ads131e08"), tok"int-gpios")
  spi_debug()
  
#Operates on global transmission buffers, returns ptr with offset from transmission length
proc spiTransaction(tx_data_len, rx_data_len:int): seq[uint8]= 
  var
    rx_bufs = @[spi_buf(buf: addr rx_buf[0], len: csize_t(sizeof(uint8) * (tx_data_len+rx_data_len))) ]
    rx_bset = spi_buf_set(buffers: addr(rx_bufs[0]), count: rx_bufs.len().csize_t)

  var
    tx_bufs = @[spi_buf(buf: addr tx_buf[0], len: csize_t(sizeof(uint8) * (tx_data_len+rx_data_len))) ]
    tx_bset = spi_buf_set(buffers: addr(tx_bufs[0]), count: tx_bufs.len().csize_t)
  check: spi_transceive(spi_dev, addr spi_cfg, addr tx_bset, addr rx_bset)
  result = rx_buf[tx_data_len..(tx_data_len+rx_data_len)].toSeq()

proc adsReadReg*(reg:REG): uint8 =
  rx_buf[2] = 0x00
  tx_buf[0] = cast[uint8](RREG) or cast[uint8](reg)
  tx_buf[1] = 0x00
  tx_buf[2] = 0x00

  var spi_ret = spiTransaction(2, 1)
  result = spi_ret[0]

proc adsWriteReg*(reg:REG, value:uint8) = 
  tx_buf[0] = cast[uint8](WREG) or cast[uint8](reg)
  tx_buf[1] = 0x00
  tx_buf[2] = value
  discard spiTransaction(3,0)

proc adsSendCMD*(cmd:CMD) =
  tx_buf[0] = cast[uint8](cmd)
  discard spiTransaction(1, 0)

proc adsReset*() = 
  adsSendCMD(RESET)

proc setupADS*() =
  adsReset()
  adsSendCMD(SDATAC)
  adsSendCMD(STOP)
  adsWriteReg(CONFIG1,0x96) #1kHz
  #adsWriteReg(CH1SET,0x60) #Gain 12 on CH1
  adsSendCMD(START)
  adsSendCMD(OFFSETCAL)
  
  

proc adsReadChannels*(): seq[int32] {.raises: [OSError].} = 
  while ndrdy.level() == 1: #Spin until you can read, active low
    discard
  tx_buf[0] = cast[uint8](RDATA)
  var spi_ret = spiTransaction(1,27)
  result = newSeq[int32](6)
  for i,val in result:
    var reading: int32
    reading = joinBytes32[int32](spi_ret[(i+1)*3..(i+1)*3+2],count=3)
    reading = (reading shl 8) shr 8 #Sign extension
    result[i] = reading
  #[
  for i,val in result:
    var prepend:uint8 = 0x00 #Sign extension
    if cast[bool](spi_ret[(i+1)*3] and 0x80):
      prepend = 0xff
    let sb = (prepend).int32()      #Sign
    let hb = (spi_ret[(i+1)*3+0]).int32()
    let mb = (spi_ret[(i+1)*3+1]).int32()
    let lb = (spi_ret[(i+1)*3+2]).int32()
    
    result[i] = (sb shl 24)+(hb shl 16) + (mb shl 8) + (lb)
  ]#  
  
#[STATUS,CH0,...,CH7]#
