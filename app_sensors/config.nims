
import os, streams, parsecfg, tables

exec "echo 'HELLO WORLD!!!!'"
exec "echo '" & $commandLineParams() & "'"

# CONFIG_NET_IPV6=y

proc parseCmakeConfig(buildDir: string,
                      zephyrDir="zephyr",
                      configName=".config"): TableRef[string, string] =
  var 
    fpath = buildDir / zephyrDir / configName
    f = readFile(fpath)
    fs = newStringStream(f)
    opts = newTable[string, string]()

  if fs != nil:
    var p: CfgParser
    open(p, fs, "zephyr.config")
    while true:
      var e = next(p)
      case e.kind
      of cfgEof: break
      of cfgSectionStart:   ## a ``[section]`` has been parsed
        echo("warning ignoring new config section: " & e.section)
      of cfgKeyValuePair:
        # echo("key-value-pair: " & e.key & ": " & e.value)
        if e.value != "n":
          opts[e.key] = e.value
      of cfgOption:
        echo("warning ignoring config option: " & e.key & ": " & e.value)
      of cfgError:
        echo(e.msg)
    close(p)
  
  result = opts

when defined(zephyr):
  let board = getEnv("BOARD") 
  echo "NIM BOARD: ", board

  let zconf = parseCmakeConfig(buildDir=".." / "build_" & board)
  echo "ZCONF: net_ipv6? ", zconf.hasKey("CONFIG_NET_IPV6")
  echo "ZCONF: net_ipv6_router? ", zconf.hasKey("CONFIG_NET_CONFIG_NEED_IPV6_ROUTER")
  echo "ZCONF: count: ", zconf.len()

  if zconf.hasKey("CONFIG_NET_IPV6"):
    switch("define", "net_ipv6")