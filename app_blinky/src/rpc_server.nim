
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

import fast_rpc/routers/router_json

import version

when defined(NephyrFlashUtils):
  import nephyr/net/json_rpc/imgutils

const TAG = "server"
const MaxRpcReceiveBuffer {.intdefine.}: int = 1400

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

initLogs("server")

static:
  echo "RPC_SERVER: HAS_IPV6: ", $defined(net_ipv6)

# Setup RPC Server #
proc run_rpc_server*() =

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

  when defined(Sensor420ma) or defined(SensorAll):
    rpc(rt, "spi-read") do() -> int:
      let res = spi_read()
      result = res

    rpc(rt, "mcp-read") do() -> (float, int):
      result = mcp_read_cal()

    rpc(rt, "mcp-read-avg") do(count: int) -> float:
      result = 0.0
      for i in 0..<count:
        result += mcp_read_cal()[0] / count.toFloat()

    rpc(rt, "mcp-set-cal") do(c0, c1: float) -> seq[float]:
      result = mcp_set_cal(c0=c0, c1=c1)

    rpc(rt, "mcp-get-cal") do() -> seq[float]:
      result = mcp_get_cal()

    rpc(rt, "spi-dbg") do() -> int:
      spi_debug()
      result = 0

  when defined(SensorFlowMeter) or defined(SensorAll):
    rpc(rt, "sfm-dbg") do() -> JsonNode:
      result = %* sf05_dbg()

    rpc(rt, "sfm-read-raw") do() -> int:
      result = sf05_read_raw()

    rpc(rt, "sfm-read") do() -> float:
      result = sf05_read()

    rpc(rt, "sfm-read-port") do(port: int) -> float:
      return multi_sf05_read_port(port)

    rpc(rt, "sfm-available") do() -> JsonNode:
      let
        res = multi_sf05_available()
      result = %* res

    rpc(rt, "sfm-read-all") do() -> JsonNode:
      let
        res = multi_sf05_read_all()
      return %* res
  # echo "starting rpc server on port 5555"
  # logi("starting rpc server buffer size: %d", rt.buffer)

  when defined(NephyrFlashUtils):
    rt.addImageUtilMethods()
  when defined(SensorFlowMeter) or defined(SensorAll):
    rt.addMultiSf05Methods()

  startRpcSocketServer(Port(5555), router=rt)



