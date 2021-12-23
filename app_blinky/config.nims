
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

const memoryConfig = "default"
# const memory = "malloc"

when memoryConfig == "default":
  # Use Nim allocator with memory pages from c malloc
  --define:nimAllocPagesViaMalloc
  --define:nimThreadStackSize:16384
  --define:nimPage512
  --define:nimMemAlignTiny

elif memoryConfig == "malloc":
  # Use Nim allocator with memory pages from c malloc
  -d:use_malloc
elif memoryConfig == "standalone":
  -d:StandaloneHeapSize=24576
  --define:nimPage512
  --define:nimMemAlignTiny


# for these boards use the C lib malloc, not the kernel k_malloc
if getEnv("BOARD") in ["teensy40", "teensy41"]:
  --d:zephyrUseLibcMalloc


# -d:nimArcDebug
# -d:traceArc

--define:no_signal_handler
--debugger:native
# --debugger:off
--threads:on
--tls_emulation:off
# --hint:conf:on
# --hint:SuccessX:off
