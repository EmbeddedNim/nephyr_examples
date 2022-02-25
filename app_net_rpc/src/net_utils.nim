import std/os
import std/monotimes

import mcu_utils/logging

import nephyr
import zephyr_c/net/znet_linkaddr
import zephyr_c/net/znet_ip
import zephyr_c/net/znet_if
import zephyr_c/net/znet_config
import zephyr_c/net/zipv6

export znet_linkaddr, znet_ip, znet_if, znet_config, zipv6

import std/posix 
import std/nativesockets 
import std/net 

export posix, nativesockets, net

proc `repr`*(netll: net_linkaddr): string =
  var arr = newString(8)
  let sz = netll.len.int.clamp(0, arr.len())
  copyMem(arr.cstring, netll.caddr, sz)
  arr.setLen(sz)
  result = "NetLL("&arr.toHex()&")"

#  ssize_t hwinfo_get_device_id(uint8_t *buffer, size_t length)¶
proc hwinfo_get_device_id(buffer: cstring, length: csize_t) {.importc: "$1", header: "<drivers/hwinfo.h>".}

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

var mac_addr = "\x00\x01\x02\x03\x04\x05"

proc set_mac_addr*() =
  # struct in6_addr *net_if_ipv6_get_ll(struct net_if *iface, enum net_addr_state addr_state)¶
  let iface: ptr net_if = net_if_get_default()
  if iface.isNil:
    echo "no default if"
    return
  if net_if_down(iface) != 0:
    echo "net_if_down failed"
    return

  let res = net_if_set_link_addr(
        iface, cast[ptr uint8](mac_addr.cstring),
        mac_addr.len().uint8,
        NET_LINK_ETHERNET)

  if net_if_up(iface) != 0:
    echo "net_if_up failed"
    return
  let status = net_if_is_up(iface)
  echo "net_if_is_up: ", status
  # for i in 0..5:
    # echo "iface flags: ", iface.if_dev.flags
  os.sleep(5_000)

  echo "net_if_set_link_addr:result: ", res


proc print_if_info*() =
  #  struct in6_addr *net_if_ipv6_get_ll(struct net_if *iface, enum net_addr_state addr_state)¶
  let iface: ptr net_if = net_if_get_default()
  if iface.isNil:
    echo "no default if"
    return

  echo "iface: ", repr(iface.if_dev.link_addr)

proc find_ll_addr*() =
  let iface: ptr net_if = net_if_get_default()
  if iface.isNil:
    raise newException(Exception, "Could not get the default interface\n")

  echo "iface: ", repr(iface.config)

  #  struct in6_addr *net_if_ipv6_get_ll(struct net_if *iface, enum net_addr_state addr_state)¶
  let lladdr: ptr In6Addr = net_if_ipv6_get_ll(iface, NET_ADDR_ANY_STATE)
  echo ""
  echo "ll_addr: ", $(lladdr[])
  var
    saddr: Sockaddr_in6
    ipaddr: IpAddress
    port: Port
  
  saddr.sin6_family = toInt(Domain.AF_INET6).TSa_Family
  saddr.sin6_addr = lladdr[]
  fromSockAddr(saddr, sizeof(saddr).SockLen, ipaddr, port)
  echo "ll ipAddr: ", $(ipaddr)

  var id = newString(8)
  hwinfo_get_device_id(id.cstring(), id.len().csize_t)
  echo "device id: ", repr(id)

