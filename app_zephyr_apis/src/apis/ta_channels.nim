
import std/os
import std/random
import std/options

var myFifo: Channel[int]

proc producerThread(args: (Channel[int], int, int)) =
  var
    # myFifo = args[0]
    count = args[1]
    tsrand = args[2]
  echo "\n===== running producer ===== "
  for i in 0..<count:
    os.sleep(rand(tsrand))
    # /* create data item to send */
    var txData = 1234 + 100 * i

    # /* send data to consumers */
    echo "-> Producer: tx_data: putting: ", i, " -> ", repr(txData)
    myFifo.send(txData)
    echo "-> Producer: tx_data: sent: ", i
  echo "Done Producer: "
  
proc consumerThread(args: (Channel[int], int, int)) =
  var
    # myFifo = args[0]
    count = args[1]
    tsrand = args[2]
  echo "\n===== running consumer ===== "
  for i in 0..<count:
    os.sleep(rand(tsrand))
    echo "<- Consumer: rx_data: wait: ", i
    var rxData = myFifo.recv()
    echo "<- Consumer: rx_data: got: ", i, " <- ", repr(rxData)

  echo "Done Consumer "

proc runTestsChannel*() =
  randomize()
  var myFifo: Channel[int]

  producerThread((myFifo, 10, 100))
  consumerThread((myFifo, 10, 100))

proc runTestsChannelThreaded*(ncnt, tsrand: int) =
  echo "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< "
  echo "[Channel] Begin "
  randomize()
  myFifo.open(ncnt)

  var thrp: Thread[(Channel[int], int, int)]
  var thrc: Thread[(Channel[int], int, int)]

  createThread(thrc, consumerThread, (myFifo, ncnt, tsrand))
  # os.sleep(2000)
  createThread(thrp, producerThread, (myFifo, ncnt, tsrand))
  joinThreads(thrp, thrc)
  echo "[Channel] Done joined "
  echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "

when isMainModule:
  runTestsChannelThreaded(7, 120)
