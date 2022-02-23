import std/os
import std/monotimes

import mcu_utils/logging

import nephyr
import zephyr_c/net/znet_ip
import zephyr_c/net/znet_if
import zephyr_c/net/zipv6

import fastrpc/server/fastrpcserver
import fastrpc/server/rpcmethods

import rpc_server
import version


proc join_coap_multicast_group*(): bool =
  var mcast_addr: Sockaddr_in6
  var ifaddr: ptr net_if_addr

  var iface: ptr net_if = net_if_get_default()
  if iface.isNil:
    raise newException(Exception, "Could not get the default interface\n")

  var my_addr: In6Addr
  ifaddr = net_if_ipv6_addr_add(iface, addr(my_addr), NET_ADDR_MANUAL, 0)
  if ifaddr.isNil:
    logError("Could not add unicast address to interface")
    return false
  ifaddr.addr_state = NET_ADDR_PREFERRED
  let ret = net_ipv6_mld_join(iface, addr(mcast_addr.sin6_addr))
  if ret < 0:
    logError("Cannot join IPv6 multicast group: ",
            repr(mcast_addr.sin6_addr), " code: ", ret)
    return false
  return true

proc find_ll_addr*() =
  var mcast_addr: Sockaddr_in6
  let iface: ptr net_if = net_if_get_default()
  if iface.isNil:
    raise newException(Exception, "Could not get the default interface\n")

  echo "iface: ", repr(iface)

  #  struct in6_addr *net_if_ipv6_get_ll(struct net_if *iface, enum net_addr_state addr_state)¶
  let lladdr: ptr In6Addr = net_if_ipv6_get_ll(iface, NET_ADDR_ANY_STATE)
  echo "ll addr: ", repr(lladdr)



app_main():
  logNotice("Booting main application: " & VERSION)

  try:
    ## ll addr
    find_ll_addr()

    echo "setup timer thread"
    var
      timer1q = TimerDataQ.init(10)
      timerOpt = TimerOptions(delay: 100.Millis, count: 10)

    var tchan: Chan[TimerOptions] = newChan[TimerOptions](1)
    var topt = TaskOption[TimerOptions](data: timerOpt, ch: tchan)
    var arg = ThreadArg[seq[int64],TimerOptions](queue: timer1q, opt: topt)
    var result: RpcStreamThread[seq[int64], TimerOptions]
    createThread[ThreadArg[seq[int64], TimerOptions]](result, streamThread, move arg)

    var router = newFastRpcRouter()
    router.registerRpcs(exampleRpcs)

    # register a `datastream` with our RPC router
    echo "register datastream"
    router.registerDataStream(
      "microspub",
      serializer=timeSerializer,
      reducer=timeSampler, 
      queue = timer1q,
      option = timerOpt,
      optionRpcs = timerOptionsRpcs,
    )

    # print out all our new rpc's!
    for rpc in router.procs.keys():
      echo "  rpc: ", rpc

    let inetAddrs = [
      newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_UDP),
      newInetAddr("0.0.0.0", 5555, Protocol.IPPROTO_TCP),
    ]
    var frpc = newFastRpcServer(router, prefixMsgSize=true, threaded=false)
    startSocketServer(inetAddrs, frpc)

  except Exception as e:
    echo "[main]: exception: ", getCurrentExceptionMsg()
    let stes = getStackTraceEntries(e)
    for ste in stes:
      echo "[main]: ", $ste
    
  # echo "unknown error causing reboot"
  # sysReboot()
