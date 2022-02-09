import os

import nephyr
import mcu_utils/logging

import fast_rpc/server/server

import rpc_server
import version

app_main():
  logNotice("Booting main application: " & VERSION)

  try:
    var router = initRpcExampleRouter()

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
