
import std/monotimes, std/os, std/json, std/tables
import std/random, std/json

import mcu_utils/logging
import mcu_utils/allocstats
import nephyr/times
import nephyr/../zephyr_c/zconfs

import fastrpc/server/fastrpcserver
import fastrpc/server/rpcmethods

import net_utils
import version

# * Sensor identity (name, location, etc)
# * Firmware version
# * FastRPC server port
# * MAC address
# * Link Local address

type
  AnnouncementData* = object
    uptime*: int64
    identifier*: string
    fwversion*: array[3, int]
    fastRpcPort*: int
    macAddress*: array[6, uint8]
    linkLocal*: array[16, uint8]

  AnnouncementOptions* {.rpcOption.} = object
    delay*: Millis

var announcement: AnnouncementData

DefineRpcTaskOptions[AnnouncementOptions](name=annOptionsRpcs):
  proc setDelay(opt: var AnnouncementOptions, delayMs: int): bool {.rpcSetter.} =
    ## called by the socket server every time there's data
    ## on the queue argument given the `rpcEventSubscriber`.
    ## 
    if delayMs < 10_000:
      opt.delay = Millis(delayMs)
      return true
    else:
      return false

proc announcementSerializer*(queue: InetEventQueue[Millis]): FastRpcParamsBuffer {.rpcSerializer.} =
  ## called by the socket server every time there's data
  ## on the queue argument given the `rpcEventSubscriber`.
  ## 
  # var tvals: seq[int64]
  var ts: Millis

  var resp = %* { "type": "announce" }
  for field, val in fieldPairs(announcement):
    when field != "delay":
      resp[field] = % val

  if queue.tryRecv(ts):
    # echo "tsf done"
    resp["uptime"] = %(ts.int64.toBiggestFloat() / 1.0e3)
    # var data = AnnouncementData( uptime: ts.int64)
    # echo "announcementSerializer: data: ", $(result)
    var jpack = resp.fromJsonNode()
    var ss = MsgBuffer.init(jpack)
    ss.setPosition(jpack.len())
    result = FastRpcParamsBuffer(buf: ss)


proc announcementStreamer*(queue: InetEventQueue[Millis],
                           opts: TaskOption[AnnouncementOptions]) {.rpcThread.} =
  ## Thread example that runs the as a time publisher. This is a reducer
  ## that gathers time samples and outputs arrays of timestamp samples.
  var data = opts.data

  {.cast(gcsafe).}:
    let ll = find_ll_addr()
    announcement = AnnouncementData(
      identifier: "",
      fwversion: [1, 0, 0],
      fastRpcPort: 5555,
      macAddress: find_mac_addr(),
      linkLocal: ll.address_v6
    )
  # address_v6

  while true:
    os.sleep(data.delay.int)
    var ms = millis()
    var qvals = isolate ms
    discard queue.trySend(qvals)

proc annStreamThread*(arg: ThreadArg[Millis, AnnouncementOptions]) {.thread, nimcall.} = 
  os.sleep(1_000)
  echo "STREAMTHREAD: annthread", repr(arg.opt.data)
  announcementStreamer(arg.queue, arg.opt)

