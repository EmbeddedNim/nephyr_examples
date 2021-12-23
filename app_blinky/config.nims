
patchFile("stdlib", "net", "src/net_fix")

--os:zephyr
--gc:arc
--overflowChecks:on
--cpu:arm
# -d:danger
--define:release
# -d:debug

# -d:McuUtilsLoggingLevel="lvlWarn"
--define:McuUtilsLoggingLevel:"lvlWarn"

## [took: 16.099 millis]
# -d:use_malloc

## [took: 16.526 millis]
--define:nimAllocPagesViaMalloc
--define:nimThreadStackSize:16384
--define:nimPage513
--define:nimMemAlignTiny

if getEnv("BOARD") in ["teensy40", "teensy41"]:
  --d:zephyrUseLibcMalloc

# -d:StandaloneHeapSize=24576
# -d:StandaloneHeapSize=65792
# -d:cpu16

# -d:nimArcDebug
# -d:traceArc

--define:no_signal_handler
--debugger:native
# --debugger:off
--threads:on
--tls_emulation:off
# --hint:conf:on
# --hint:SuccessX:off
