
import json
import strutils
import sequtils
import os

import std/monotimes
import std/times
import std/sysrand
import std/random

import nephyr/general
import nephyr/times as ntimes
import nephyr/logs

import fast_rpc/rpc_udp_mpack

when defined(NephyrFlashUtils):
  import nephyr/net/json_rpc/imgutils

import version

const TAG = "server"
const MaxRpcReceiveBuffer {.intdefine.}: int = 1400

{.emit: """/*INCLUDESECTION*/
#include <pthread.h>
""".}

## Note:
## Nim uses `when` compile time constructs
## these are like ifdef's in C and don't really have an equivalent in Python
## setting the flags can be done in the Makefile `simplewifi-rpc  Makefile
## for example, to compile the example to use JSON, pass `-d:TcpJsonRpcServer` to Nim
## the makefile has several example already defined for convenience
## 
# import rpc/rpcsocket_json
include fast_rpc/rpcsocket_mpack

when defined(Sensor420ma) or defined(SensorFlowMeter) or defined(SensorAll):
  import hal/hal_buses

when defined(Sensor420ma) or defined(SensorAll):
  import hal/hal_mcp3201
when defined(SensorFlowMeter) or defined(SensorAll):
  import hal/hal_sf05
  import hal/hal_multi_sf05


# Setup RPC Server #
proc run_rpc_udp_server*() =

  randomize()

  ## Initial Setup
  when defined(Sensor420ma) or defined(SensorAll):
    try:
      mcpSetup()
    except:
      echo "error setting up mcp"

  when defined(SensorFlowMeter) or defined(SensorAll):
    try:
      sf05Setup()
      multi_sf05_setup()
    except:
      echo "error setting up sf05"

  # Setup an RPC router
  var rt = createRpcRouter(MaxRpcReceiveBuffer)

  rpc(rt, "version") do() -> string:
    result = VERSION

  rpc(rt, "micros") do() -> int64:
    result = micros().int64

  rpc(rt, "urandom") do(val: int) -> seq[int]:
    let res = urandom(val)
    result = res.mapIt(it.int)

  rpc(rt, "random") do(val: int) -> int:
    result = rand(val)

  rpc(rt, "monotime") do() -> string:
    result = repr getMonoTime()

  rpc(rt, "monotime-plus-ms") do(ms: int) -> string:
    let fs = getMonoTime() + initDuration(milliseconds = ms)
    os.sleep(100)
    result = repr(fs - getMonoTime())

  rpc(rt, "now") do() -> string:
    result = $now()

  rpc(rt, "uptime") do() -> int64:
    result = k_uptime_get().int64

  rpc(rt, "hello") do(input: string) -> string:
    # example: ./rpc_cli --ip:$$IP -c:1 '{"method": "hello", "params": ["world"]}'
    result = "Hello " & input

  rpc(rt, "addInt") do(a: int, b: int) -> int:
    # example: ./rpc_cli --ip:$$IP -c:1 '{"method": "add", "params": [1, 2]}'
    result = a + b

  rpc(rt, "addFloat") do(a: float, b: float) -> float:
    # example: ./rpc_cli --ip:$$IP -c:1 '{"method": "add", "params": [1, 2]}'
    result = a + b

  rpc(rt, "test-oom") do() -> int:
    # example: ./rpc_cli --ip:$$IP -c:1 '{"method": "add", "params": [1, 2]}'
    var cnt = 0
    try:
      var arr = newSeq[string](128)
      for i in 1..10_000_000:
        var istr = i.toHex()
        printk("idx1: %d\n", i)
        echo "idx: ", istr
        printk("idx2: %d\n", i)
        cnt.inc()
        arr.add istr
    except OutOfMemDefect:
      printk("OOM caught")
      echo "OutOfMemDefect! "
    result = cnt

  rpc(rt, "delay") do(ms: int) -> float:
    # example: ./rpc_cli --ip:$$IP -c:1 '{"method": "add", "params": [1, 2]}'
    let ts0 = micros()
    os.sleep(ms)
    let ts1 = micros()
    result = toFloat(int(ts1 - ts0))/1.0e6

  rpc(rt, "addAll") do(vals: seq[int]) -> int:
    # example: ./rpc_cli --ip:$$IP -c:1 '{"method": "add", "params": [1, 2, 3, 4, 5]}'
    echo("run_rpc_server: done: " & repr(addr(vals)))
    result = 0
    for x in vals:
      result += x

  startRpcUdpServer(Address(host: IPv4_any(), port: Port 6310), rt, delay=Millis 1)



