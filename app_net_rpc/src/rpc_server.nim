import std/monotimes, std/os, std/json, std/tables

import mcu_utils/logging
import nephyr/times
import nephyr/../zephyr_c/zconfs

import fast_rpc/server/server
import fast_rpc/server/rpcmethods

import version

when not CONFIG_EVENTFD:
  static: 
    raise newException(Exception, "must define eventfd")

# Define RPC Server #
rpcRegisterMethodsProc(name=initRpcExampleRouter):

  proc add(a: int, b: int): int {.rpc.} =
    result = 1 + a + b

  proc addAll(vals: seq[int]): int {.rpc.} =
    for val in vals:
      result = result + val

  proc multAll(x: int, vals: seq[int]): seq[int] {.rpc.} =
    result = newSeqOfCap[int](vals.len())
    for val in vals:
      result.add val * x

  proc echos(msg: string): string {.rpc.} =
    echo("echos: ", "hello ", msg)
    result = "hello: " & msg

  proc echorepeat(msg: string, count: int): string {.rpc.} =
    let rmsg = "hello " & msg
    for i in 0..count:
      echo("echos: ", rmsg)
      # discard context.sender(rmsg)
      discard rpcReply(rmsg)
      os.sleep(400)
    result = "k bye"

  proc rpcdelay(cntMillis: int): Millis {.rpc.} =

    let t0 = getMonoTime().ticks div 1_000_000
    os.sleep(cntMillis)
    let t1 = getMonoTime().ticks div 1_000_000

    return Millis(t1-t0)

  proc microspub(count: int, wait: int): int {.rpcPublisherThread().} =
    # var subid = subs.subscribeWithThread(context, run_micros, % delay)
    while true:
      var times = newSeqOfCap[int64](30)
      for i in 0..<count:
        var ts = int64(getMonoTime().ticks() div 1000)
        times.add(ts)
      discard rpcPublish(times)
      discard delay(wait.Micros)

  proc testerror(msg: string): string {.rpc.} =
    echo("test error: ", "what is your favorite color?")
    if msg != "Blue":
      raise newException(ValueError, "wrong answer!")
    result = "correct: " & msg
