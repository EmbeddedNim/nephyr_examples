

import std/os
import std/monotimes

import mcu_utils/logging

import nephyr

import fastrpc/server/fastrpcserver
import fastrpc/server/rpcmethods

import rpc_server
import info_stream
import version
import net_utils

# var PRE_KERNEL_1* {.importc: "_SYS_INIT_LEVEL_PRE_KERNEL_1", header: "<init.h>".}: cint
type SystemLevel = enum
  INIT_PRE_KERNEL_1 = 0,
  INIT_PRE_KERNEL_2 = 1,
  INIT_POST_KERNEL = 2,
  INIT_APPLICATION = 3,
  INIT_SMP = 4

var KERNEL_INIT_PRIORITY_DEFAULT* {.importc: "KERNEL_INIT_PRIORITY_DEFAULT", header: "<init.h>".}: cint
proc SYS_INIT*(fn: proc {.cdecl.}, level: cint, priority: cint) {.importc: "SYS_INIT", header: "<init.h>".}

template SystemInit*(fn: proc {.cdecl.}, level: SystemLevel, priority: int) =
  ## Template to setup a zephyr initialization callback for a given level and priority. 
  {.emit: ["/*VARSECTION*/\nSYS_INIT(", fn, ", ", level.ord(), ", ", priority, ");"].}

when BOARD in ["teensy40", "teensy41"]:
  ## Change Teensy PinMux to use CS GPIO Pin
  type MuxCfg* = distinct int
  var IOMUXC_GPIO_AD_B0_03_GPIO1_IO03* {.importc: "$1", header: "<fsl_iomuxc.h>".}: MuxCfg
  proc IOMUXC_SetPinMux*(muxCfg: MuxCfg, val: cint) {.importc: "IOMUXC_SetPinMux", header: "<fsl_iomuxc.h>".}

  proc board_configuration() {.exportc.} =
    IOMUXC_SetPinMux(IOMUXC_GPIO_AD_B0_03_GPIO1_IO03, 0)

  SystemInit(board_configuration, INIT_PRE_KERNEL_1, 40)


app_main():
  logNotice("Booting main application: " & VERSION)

  logNotice "setting up net config"
  let res = net_config_init("app", 0, 100)
  echo "net config result: ", res

  try:
    ## ll addr
    echo "link local addr: ", find_ll_addr()
    print_if_info()

    echo "setup timer thread"
    var
      timer1q = TimerDataQ.init(2)
      timerOpt = TimerOptions(delay: 1_000.Millis, count: 10)
      ann1q = InetEventQueue[Millis].init(2)
      annOpt = AnnouncementOptions(delay: 2_000.Millis)

    var tchan1: Chan[TimerOptions] = newChan[TimerOptions](1)
    var topt1 = TaskOption[TimerOptions](data: timerOpt, ch: tchan1)
    var arg1 = ThreadArg[seq[int64],TimerOptions](queue: timer1q, opt: topt1)
    var thr1: RpcStreamThread[seq[int64], TimerOptions]
    # createThread[ThreadArg[seq[int64], TimerOptions]](thr1, streamThread, move arg1)

    var tchan2: Chan[AnnouncementOptions] = newChan[AnnouncementOptions](2)
    var topt2 = TaskOption[AnnouncementOptions](data: annOpt, ch: tchan2)
    var arg2 = ThreadArg[Millis,AnnouncementOptions](queue: ann1q, opt: topt2)
    var thr2: RpcStreamThread[Millis, AnnouncementOptions]
    createThread[ThreadArg[Millis, AnnouncementOptions]](thr2, annStreamThread, move arg2)

    var router = newFastRpcRouter()
    router.registerRpcs(exampleRpcs)

    # register a `datastream` with our RPC router
    echo "register datastream"
    router.registerDataStream(
      "microspub",
      serializer = timeSerializer,
      reducer = timeSampler, 
      queue = timer1q,
      option = timerOpt,
      optionRpcs = timerOptionsRpcs,
    )

    router.registerDataStream(
      "announcement",
      serializer = announcementSerializer,
      reducer = announcementStreamer,
      queue = ann1q,
      option = annOpt,
      optionRpcs = annOptionsRpcs,
    )

    # print out all our new rpc's!
    for rpc in router.procs.keys():
      echo "  rpc: ", rpc

    let inetAddrs = [
      # newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_UDP),
      # newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_TCP),
      newInetAddr("::", 5555, Protocol.IPPROTO_UDP),
      newInetAddr("::", 5555, Protocol.IPPROTO_TCP),
    ]

    var frpc = newFastRpcServer(router, prefixMsgSize=true, threaded=false)

    let maddr = newClientHandle("ff12::1", 2048, -1.SocketHandle, net.IPPROTO_UDP)
    logInfo "app_net_rpc:", "multicast-addr:", repr maddr
    let microsPub = router.subscribe("microspub", maddr, 0.Millis)
    logInfo "app_net_rpc:", "multicast-publish:", repr microsPub 
    let annPub = router.subscribe("announcement", maddr, 0.Millis)
    logInfo "app_net_rpc:", "ann-publish:", repr annPub 

    startSocketServer(inetAddrs, frpc)

  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  # echo "unknown error causing reboot"
  # sysReboot()
