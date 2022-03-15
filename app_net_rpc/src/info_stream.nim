
import std/monotimes, std/os, std/json, std/tables
import std/random, std/json

import mcu_utils/logging
import mcu_utils/allocstats
import nephyr/times
import nephyr/../zephyr_c/zconfs

import fastrpc/server/fastrpcserver
import fastrpc/server/rpcmethods

import version

# * Sensor identity (name, location, etc)
# * Firmware version
# * FastRPC server port
# * MAC address
# * Link Local address

type
  AnnouncementData* = object
    uptime*: float64
    identifier*: string
    fwversion*: array[3, int]
    fastrRpcPort*: int
    macAddress*: array[6, byte]
    linkLocal*: array[16, byte]

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

proc announcementSerializer*(queue: InetEventQueue[Millis]): TableRef[string, JsonNode] {.rpcSerializer.} =
  ## called by the socket server every time there's data
  ## on the queue argument given the `rpcEventSubscriber`.
  ## 
  # var tvals: seq[int64]
  var ts: Millis

  new(result)
  for field, val in fieldPairs(announcement):
    when field != "delay":
      result[field] = % val

  if queue.tryRecv(ts):
    result["uptime"] = %( ts.int64.toBiggestFloat() / 1.0e3)

proc announcementStreamer*(queue: InetEventQueue[Millis],
                           opts: TaskOption[AnnouncementOptions]) {.rpcThread.} =
  ## Thread example that runs the as a time publisher. This is a reducer
  ## that gathers time samples and outputs arrays of timestamp samples.
  var data = opts.data

  while true:
    os.sleep(data.delay.int)
    var qvals = isolate millis()
    discard queue.trySend(qvals)

proc annStreamThread*(arg: ThreadArg[Millis, AnnouncementOptions]) {.thread, nimcall.} = 
  os.sleep(1_000)
  echo "streamThread: ", repr(arg.opt.data)
  announcementStreamer(arg.queue, arg.opt)

