
import os
import mcu_utils/logging

import posix
import nativesockets
import net

import fast_rpc/udpsocket

import json
import msgpack4nim
import msgpack4nim/msgpack2json

# CDeclartionInvoke(K_THREAD_STACK_DEFINE, my_stack_area, 8096)
# var my_stack_area {.importc: "$1", nodecl, noinit.}: ptr k_thread_stack_t 
# var my_thread_data: k_thread 

proc process_client_request_native*(sockFd: SocketHandle): cint =
  var received: int
  var client_addr: SockAddr
  var client_addr_len: SockLen
  var request: array[100, uint8]
  while true:
    logInfo "recvfrom UDP Socket"
    client_addr_len = SockLen sizeof(client_addr)
    received = posix.recvfrom(sockFd,
                              addr request[0], sizeof(request),
                              0,
                              addr(client_addr), addr(client_addr_len))
    if received < 0:
      logError("Connection error ", posix.errno)
      return -errno
    if not true:
      break
    logInfo "received from UDP Socket: ", received
    logInfo "host from UDP Socket: ", $client_addr
    logInfo "data from UDP Socket: ", repr request
  return 0

proc process_client_request*(sock: Socket): cint =
  var client_addr: string
  var client_port: Port
  var request = newString(100)
  while true:
    logInfo "recvfrom UDP Socket"
    var received: int = 0

    try:
      received = recvFrom(sock, request, request.len(), client_addr, client_port)
    except OSError as e:
      logError "socket os error: ", $getCurrentExceptionMsg()
      logError "socket os error code: ", e.errorCode

    if received < 0:
      logError("Connection error ", posix.errno)
      return -errno
    if not true:
      break
    logInfo "received from UDP Socket: ", received
    logInfo "host from UDP Socket: ", $client_addr
    logInfo "data from UDP Socket: ", repr request
  return 0

proc start_udp_server_native*(): SocketHandle =
  var ipaddr: SockAddr_in
  var r: cint
  ipaddr.sin_family = 1.uint16
  ipaddr.sin_port = posix.htons(6310)
  logInfo "Start UDP Socket"
  var sock: SocketHandle = socket(ipaddr.sin_family.cint, 2, 17)

  if sock.int < 0:
    logError("Failed to create UDP socket ", errno)
    raise newException(ValueError, "errno: " & $errno)
  logInfo "Bind UDP Socket"
  r = posix.bindSocket(sock, cast[ptr SockAddr](addr(ipaddr)), sizeof(ipaddr).SockLen)
  if r < 0:
    logError("Failed to bind UDP socket ", errno)
    raise newException(ValueError, "errno: " & $errno)
  
  sock.setBlocking(false)
  return sock

proc start_udp_server*(): Socket =
  var serverIp = "0.0.0.0"
  var port = 6310
  var sock = newSocket(
    Domain.AF_INET,
    nativesockets.SOCK_DGRAM,
    nativesockets.IPPROTO_UDP,
    buffered = false
  )

  logInfo("bind socket:", "host:", serverIp, "port:", port)
  sock.bindAddr(port.Port, serverIp)
  sock.getFd().setBlocking(false)

  return sock

const UdpServer = true

proc testThreadReactor*() =
  const remoteIp {.strdefine.} = "10.0.7.0"
  const port {.intdefine.} = 6310

  let
    server = Address(host: IPv4_Any(), port: Port port)
    remote = Address(host: parseIpAddress remoteIp, port: Port port)

  logInfo "=== RUNTESTSERVER ==="
  try:
    runTestServer(remote, server)
  except Exception as e:
    logError "error running runTestServer: ", e.getStackTrace()


proc testThreadManualPosix*() =
  var sock = start_udp_server()
  discard sock.process_client_request()

proc call_nim_recv_from*(sock: Socket): int =
  for i in 0..10:
    var
      hs: IpAddress
      hp: Port
      data = newString(100)

    try:
      logInfo "sock wait..."
      let byteLen = recvFrom(sock, data, data.len(), hs, hp)
      logInfo "sock got bytelen: ", byteLen
      logInfo "sock got: ", repr data
      result = byteLen

    except OSError as e:
      logError "socket os error: ", $getCurrentExceptionMsg()
      logError "socket os errno: ", $e.errorCode
      logError "socket data: ", repr data
      result = 1
      continue
    except ValueError as e:
      logError "socket unknown family: "

      # raise e
      # os.sleep(1000)

proc testThreadNimRecv*() =
  var serverIp = "0.0.0.0"
  var port = 6310

  var sock = newSocket(
    Domain.AF_INET,
    nativesockets.SOCK_DGRAM,
    nativesockets.IPPROTO_UDP,
    buffered = false
  )

  logInfo("bind socket:", "host:", serverIp, "port:", port)
  sock.bindAddr(port.Port, serverIp)
  sock.getFd().setBlocking(true)

  os.sleep(1000)

  for i in 0..100_000:
    let r = call_nim_recv_from(sock)
    logInfo "r:", r
    # discard process_client_request(sock)
    os.sleep(100)

proc testThread*() =
  # testThreadManualPosix()
  # testThreadNimRecv()
  testThreadReactor()
  # while true:
    # logInfo("sleep..")
    # os.sleep(1_000)



proc test_server*(p1, p2, p3: pointer) {.exportc: "test_server", cdecl.} = 
  # {.emit: """printk("testServer\n");""".}
  while true:
    echo "Test Server!"
    os.sleep(10000)

