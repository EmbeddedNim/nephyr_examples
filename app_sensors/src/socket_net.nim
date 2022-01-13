##
##  Copyright (c) 2017 Linaro Limited
##
##  SPDX-License-Identifier: Apache-2.0
##

# import posix
import os
import nativesockets
import net
import strutils, strformat

import nephyr
import rpc_server

initLogs("socket_net")

var CONFIG_HEAP_MEM_POOL_SIZE* {.importc: "$1", header: "<kernel.h>".}: cint

const
  BIND_PORT* = Port(8181)

# Read in static content at compile time from the .bin files 
when defined(small_bin):
  const CONTENT: string = readFile("response_small.html.bin")
else:
  const CONTENT: string = readFile("response_big.html.bin")

proc handleClient(client: var Socket) =
  echo "wait client request..."
  for i in 0..10:
    var rmsg = client.recvLine()
    echo("got: ", repr rmsg)
    if rmsg == "\r\n":
      break
    if i == 10:
      raise newException(ValueError, "didn't get proper http client request")

  var data = $CONTENT
  echo(fmt"sending client data: {data.len()} bytes")
  send(client, data)
  client.close()

proc startHttpServer*() =
  var socket = newSocket()
  socket.bindAddr(BIND_PORT)
  socket.listen()
  
  echo(fmt"Single-threaded dumb HTTP server waits for a connection on port {BIND_PORT}...")

  var counter = 0

  while true:
    var
      client: Socket
      address = ""

    socket.acceptAddr(client, address)
    echo fmt"Client connected from: {address}"

    inc(counter)
    echo fmt"Connection #{counter} from {address}"

    ##  Discard HTTP request (or otherwise client will get
    ##  connection reset error).
    try:
      echo("Processing...\n")
      client.handleClient()
    except:
      close(client, {SafeDisconn})
      echo(fmt"Connection from {address} closed")

app_main():
  echo("... starting from Nim! " & VERSION)
  logi("max heap: %d", CONFIG_HEAP_MEM_POOL_SIZE)

  try:
    run_server()
  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  echo "unknown error causing reboot"
  sysReboot()
  # startHttpServer()