import strutils

# patchFile("stdlib", "net", "src/net_fix")

--os:zephyr
--gc:arc
--overflowChecks:on
--cpu:arm
# --define:danger
# --define:release
--define:debug

# -d:McuUtilsLoggingLevel="lvlWarn"
# switch("define", "McuUtilsLoggingLevel:lvlWarn")
switch("define", "McuUtilsLoggingLevel:lvlDebug")

## [took: 16.099 millis]
# -d:use_malloc

## [took: 16.526 millis]
switch("define", "nimAllocPagesViaMalloc")
switch("define", "nimThreadStackSize=16384")
switch("define", "nimPage512")
switch("define", "nimMemAlignTiny")

switch("define", "strictFuncs")

if getEnv("BOARD") in ["teensy40", "teensy41"]:
  switch("define", "zephyrUseLibcMalloc")

# -d:StandaloneHeapSize=24576
# -d:StandaloneHeapSize=65792
# -d:cpu16
if getEnv("BOARD").startsWith("nucleo_h7"):
  switch("define", "zephyrUseLibcMalloc")

# -d:nimArcDebug
# -d:traceArc

--define:no_signal_handler
--debugger:native
# --debugger:off
--threads:on
--tls_emulation:off
# --hint:conf:on
# --hint:SuccessX:off
