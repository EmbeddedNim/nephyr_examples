

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

app_main():
  logNotice("Booting main application: " & VERSION)

  # echo "setting up net config"
  # let res = net_config_init("app", 0, 100)
  # echo "net config result: ", res

  try:
    ## ll addr
    find_ll_addr()
    print_if_info()

    echo "setup timer thread"
    var
      timer1q = TimerDataQ.init(10)
      timerOpt = TimerOptions(delay: 1_000.Millis, count: 10)
      ann1q = InetEventQueue[Millis].init(10)
      annOpt = AnnouncementOptions(delay: 2_000.Millis)

    var tchan: Chan[TimerOptions] = newChan[TimerOptions](1)
    var topt = TaskOption[TimerOptions](data: timerOpt, ch: tchan)
    var arg = ThreadArg[seq[int64],TimerOptions](queue: timer1q, opt: topt)
    var result: RpcStreamThread[seq[int64], TimerOptions]
    createThread[ThreadArg[seq[int64], TimerOptions]](result, streamThread, move arg)

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
    let annPub = router.subscribe("microspub", maddr, 0.Millis)
    logInfo "app_net_rpc:", "ann-publish:", repr annPub 

    startSocketServer(inetAddrs, frpc)

  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  # echo "unknown error causing reboot"
  # sysReboot()
