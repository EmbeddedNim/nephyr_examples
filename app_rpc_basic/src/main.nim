import nephyr
import mcu_utils/logging

import rpc_server

import version 

{.emit: """/*INCLUDESECTION*/
#include <pthread.h>
""".}


app_main():
  logNotice("Booting main application: " & VERSION)

  try:
    let router = rpc_server()
    let inetAddrs = [
      newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_UDP),
      newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_TCP),
    ]

    startSocketServer(inetAddrs, newMpackJRpcServer(router, prefixMsgSize=true))

  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  # echo "unknown error causing reboot"
  # sysReboot()
