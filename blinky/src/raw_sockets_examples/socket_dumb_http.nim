##
##  Copyright (c) 2017 Linaro Limited
##
##  SPDX-License-Identifier: Apache-2.0
##

import posix

proc NimMain() {.importc.}

template app_main*(blk: untyped): untyped =

  proc main*() {.exportc.} =
    NimMain() # initialize garbage collector memory, types and stack
    blk

proc printf*(formatstr: cstring) {.importc: "printf", varargs, header: "stdio.h".}

proc check*(ret: int) =
  if ret == -1:
    raise newException(OSError, "error: " & $strerror(ret.cint))

const
  BIND_PORT* = 8181'u16

# const CONTENT: cstring = "<html>exampple html</html>"
const CONTENT: string = readFile("response_big.html.bin")

## !!!Ignored construct:  static const char content [ ] = { # USE_BIG_PAYLOAD [NewLine] # response_big.html.bin.inc [NewLine] # [NewLine] # response_small.html.bin.inc [NewLine] # [NewLine] } ;
## Error: did not expect #!!!

proc handleClient(client: var SocketHandle) =
  var
    req_state: cint = 0

  while true:
    var
      c: char
      r = recv(client, addr(c), 1, 0)

    if r == 0:
      raise newException(ValueError, "client recv error: " & $r)

    if r < 0:
      if errno == EAGAIN or errno == EINTR:
        continue

      raise newException(ValueError, "Got error %d when receiving from socket: " & $errno)

    if req_state == 0 and c == '\c':
      inc(req_state)
    elif req_state == 1 and c == '\n':
      inc(req_state)
    elif req_state == 2 and c == '\c':
      inc(req_state)
    elif req_state == 3 and c == '\n':
      break
    else:
      req_state = 0

  var
    data = $CONTENT

  while data.len() > 0:
    var sent_len = send(client, data.cstring, data.len(), 0)
    if sent_len == -1:
      raise newException(ValueError, "Error sending data to peer, errno: " & $errno)
    data = data[sent_len .. ^1] 

app_main():

  printf("starting from nim!...\n")

  var
    serv: SocketHandle
    baddr: Sockaddr_in
    counter: cint

  serv = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
  check: serv.cint

  baddr.sin_family = AF_INET.uint16
  baddr.sin_addr.s_addr = htonl(INADDR_ANY)
  baddr.sin_port = htons(BIND_PORT)

  check: bindSocket(serv, cast[ptr Sockaddr](baddr.addr), baddr.sizeof.SockLen)

  check: listen(serv, 5)

  printf("Single-threaded dumb HTTP server waits for a connection on port %d...\n",
         BIND_PORT)

  while true:
    var
      clientAddr: SockAddr_in
      clientAddrLen: Socklen = clientAddr.sizeof.SockLen

    printf("listening for client: clientAddr: %x size: %d\n", addr clientAddr, clientAddrLen)

    var
      addr_str = newString(32)
    
    var
      client = accept(serv, cast[ptr Sockaddr](clientAddr.addr), clientAddrLen.addr)

    if client.cint < 0:
      printf("Error in accept: %d - continuing\n", errno)
      continue

    discard inet_ntop(clientAddr.sin_family.cint,
              client_addr.sin_addr.addr,
              addr_str.cstring,
              addr_str.len.cint)

    inc(counter)
    printf("Connection #%d from %s\n", counter, addr_str.cstring)

    ##  Discard HTTP request (or otherwise client will get
    ##  connection reset error).
    ##
    try:
      client.handleClient()
    finally:
      var ret = close(client)
      if ret == 0:
        printf("Connection from %s closed\n", addr_str.cstring)
      else:
        printf("Got error %d while closing the socket\n", errno)

# when isMainModule:
  # main()
