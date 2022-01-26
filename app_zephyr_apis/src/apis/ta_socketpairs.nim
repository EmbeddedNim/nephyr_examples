import os, random
import nativesockets, net

import sugar

import fast_rpc/socketserver/sockethelpers

proc producerThread(args: (Socket, int, int)) =
  var
    sock = args[0]
    count = args[1]
    tsrand = args[2]
  echo "\n===== running producer ===== "
  for i in 0..<count:
    os.sleep(rand(tsrand))
    # /* create data item to send */
    var txData = 1234 + 100000 * i

    # /* send data to consumers */
    echo "-> Producer: tx_data: putting: ", i, " -> ", repr(txData)
    sock.send("some data: " & $txData&"\n")
    echo "-> Producer: tx_data: sent: ", i
  echo "Done Producer: "
  
proc consumerThread(args: (Socket, int, int)) =
  var
    sock = args[0]
    count = args[1]
    tsrand = args[2]
  echo "\n===== running consumer ===== "
  for i in 0..<count:
    os.sleep(rand(tsrand))
    echo "<- Consumer: rx_data: wait: ", i
    var rxData = sock.recvLine()

    echo "<- Consumer: rx_data: got: ", i, " <- ", repr(rxData)

  echo "Done Consumer "

proc runTestsSocketPairsThreaded*(ncnt, tsrand: int) =
  echo "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< "
  echo "[SocketPair] Begin "
  randomize()
  let sockets = newSocketPair()
  # let sockets = newSocketPair(sockType = SockType.SOCK_STREAM, protocol = Protocol.IPPROTO_IP)

  var thrp: Thread[(Socket, int, int)]
  var thrc: Thread[(Socket, int, int)]

  createThread(thrc, consumerThread, (sockets[0], ncnt, tsrand))
  # os.sleep(2000)
  createThread(thrp, producerThread, (sockets[1], ncnt, tsrand))
  joinThreads(thrp, thrc)
  echo "[SocketPair] Done joined "
  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "

when isMainModule:
  runTestsSocketPairsThreaded(7, 0)
