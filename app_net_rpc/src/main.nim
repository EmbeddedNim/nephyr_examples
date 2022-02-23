import std/os
import std/monotimes

import nephyr
import mcu_utils/logging

import fastrpc/server/fastrpcserver
import fastrpc/server/rpcmethods

import rpc_server
import version


proc timePublisher*(params: (InetEventQueue[int64], int)) {.thread.} =
  let 
    queue = params[0]
    delayMs = params[1]
    n = 10

  while true:
    var ts = int64(getMonoTime().ticks() div 1000)
    # logDebug "timePublisher: ", "ts:", ts, "queue:len:", queue.chan.peek()
    var qvals = isolate ts
    discard queue.trySend(qvals)
    os.sleep(delayMs)

app_main():
  logNotice("Booting main application: " & VERSION)

  try:
    echo "setup timer thread"
    var
      timer1q = TimerDataQ.init(10)
      timerOpt = TimerOptions(delay: 100.Millis, count: 10)

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
      serializer=timeSerializer,
      reducer=timeSampler, 
      queue = timer1q,
      option = timerOpt,
      optionRpcs = timerOptionsRpcs,
    )

    # print out all our new rpc's!
    for rpc in router.procs.keys():
      echo "  rpc: ", rpc

    let inetAddrs = [
      newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_UDP),
      newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_TCP),
    ]
    var frpc = newFastRpcServer(router, prefixMsgSize=true, threaded=false)
    startSocketServer(inetAddrs, frpc)

  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  # echo "unknown error causing reboot"
  # sysReboot()
