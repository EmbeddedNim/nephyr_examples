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
    logDebug "timePublisher: ", "ts:", ts, "queue:len:", queue.chan.peek()
    var qvals = isolate ts
    discard queue.trySend(qvals)
    os.sleep(delayMs)

app_main():
  logNotice("Booting main application: " & VERSION)

  try:
    ## Setup timer publisher
    var timer1q = InetEventQueue[int64].init(10)
    var timerThr: Thread[(InetEventQueue[int64], int)]
    timerThr.createThread(timePublisher, (timer1q , 1_000))

    var router = newFastRpcRouter()
    router.registerExampleRpcMethods(timer1q)

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
