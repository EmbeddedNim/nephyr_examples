when not defined(nimscript):
  import system/nimscript

switch("define","release")
# switch("define","debug")
# switch("define","danger")

switch("os","zephyr")
switch("gc","arc")
# switch("define", "nimArcDebug")
# switch("define", "traceArc")

switch("define", "McuUtilsLoggingLevel:lvlInfo")

const memoryConfig = "default"
# const memory = "malloc"

when memoryConfig == "default":
  # Use Nim allocator with memory pages from c malloc
  switch("define", "nimAllocPagesViaMalloc")
  switch("define","nimThreadStackSize:16384")
  switch("define","nimPage512")
  switch("define","nimMemAlignTiny")

elif memoryConfig == "malloc":
  # Use Nim allocator with memory pages from c malloc
  switch("define","use_malloc")
elif memoryConfig == "standalone":
  switch("define","StandaloneHeapSize=24576")
  switch("define","nimPage512")
  switch("define","nimMemAlignTiny")

# for these boards use the C lib malloc, not the kernel k_malloc
if getEnv("BOARD") in ["teensy40", "teensy41"]:
  switch("define", "zephyrUseLibcMalloc")


# Basic settings
switch("overflowChecks","on")
switch("cpu","arm")
switch("define", "no_signal_handler")
switch("debugger", "native")
switch("threads", "on")
switch("tls_emulation", "off")
