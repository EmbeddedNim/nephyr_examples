import std/monotimes, std/os, std/json, std/tables
import std/random

import mcu_utils/logging
import mcu_utils/allocstats
import nephyr/times
import nephyr/../zephyr_c/zconfs

import fastrpc/server/fastrpcserver
import fastrpc/server/rpcmethods

import version

when not CONFIG_EVENTFD:
  static: 
    raise newException(Exception, "must define eventfd")


# Define RPC Server #
DefineRpcs(name=exampleRpcs):

  proc add(a: int, b: int): int {.rpc.} =
    result = a + b

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

  proc simulatelongcall(cntMillis: int): Millis {.rpc.} =

    let t0 = getMonoTime().ticks div 1_000_000
    echo("simulatelongcall: ", )
    os.sleep(cntMillis)
    let t1 = getMonoTime().ticks div 1_000_000

    return Millis(t1-t0)


  proc testerror(msg: string): string {.rpc.} =
    echo("test error: ", "what is your favorite color?")
    if msg != "Blue":
      raise newException(ValueError, "wrong answer!")
    result = "correct: " & msg

type
  TimerDataQ* = InetEventQueue[seq[int64]]

  TimerOptions* {.rpcOption.} = object
    delay*: Millis
    count*: int

DefineRpcTaskOptions[TimerOptions](name=timerOptionsRpcs):
  proc setDelay(opt: var TimerOptions, delayMs: int): bool {.rpcSetter.} =
    ## called by the socket server every time there's data
    ## on the queue argument given the `rpcEventSubscriber`.
    ## 
    if delayMs < 10_000:
      opt.delay = Millis(delayMs)
      return true
    else:
      return false
  
  proc getDelay(option: var TimerOptions): int {.rpcGetter.} =
    ## called by the socket server every time there's data
    ## on the queue argument given the `rpcEventSubscriber`.
    ## 
    result = option.delay.int
  

proc timeSerializer*(queue: TimerDataQ): seq[int64] {.rpcSerializer.} =
  ## called by the socket server every time there's data
  ## on the queue argument given the `rpcEventSubscriber`.
  ## 
  # var tvals: seq[int64]
  if queue.tryRecv(result):
    let rs = rand(200)
    os.sleep(rs)
    # echo "ts: ", result.len()

proc timeSampler*(queue: TimerDataQ, opts: TaskOption[TimerOptions]) {.rpcThread.} =
  ## Thread example that runs the as a time publisher. This is a reducer
  ## that gathers time samples and outputs arrays of timestamp samples.
  var data = opts.data

  while true:
    logAllocStats(lvlDebug):
      var tvals = newSeqOfCap[int64](data.count)
      for i in 0..<data.count:
        var ts = int64(getMonoTime().ticks() div 1000)
        tvals.add ts
        #os.sleep(data.delay.int div (2*data.count))

      # logInfo "timePublisher:", "ts:", tvals[0], "len:", tvals.len.repr
      # logInfo "queue:len:", queue.chan.peek()

      # let newOpts = opts.getUpdatedOption()
      # if newOpts.isSome:
        # echo "setting new parameters: ", repr(newOpts)
        # data = newOpts.get()

      os.sleep(data.delay.int)
      var qvals = isolate tvals
      discard queue.trySend(qvals)

proc streamThread*(arg: ThreadArg[seq[int64], TimerOptions]) {.thread, nimcall.} = 
  os.sleep(1_000)
  echo "STREAMTHREAD: timersampler ", repr(arg.opt.data)
  timeSampler(arg.queue, arg.opt)

