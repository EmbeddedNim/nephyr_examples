when not defined(nimscript):
  import system/nimscript

# switch("define","release")
switch("define","debug")
# switch("define","danger")

switch("os","zephyr")
switch("gc","arc")
# switch("define", "nimArcDebug")
# switch("define", "traceArc")

switch("define", "McuUtilsLoggingLevel:lvlInfo")

const memoryConfig = "default"

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


if getEnv("BOARD") in ["native_posix"]:
  switch("cpu","i386")
  switch("define","nimThreadStackSize:17408")
elif getEnv("BOARD") in ["native_posix_64"]:
  switch("cpu","amd64")
  switch("define","nimThreadStackSize:17408")
elif getEnv("BOARD") in ["qemu_cortex_m3"]:
  switch("define","nimThreadStackSize:4096")
  switch("cpu","arm")
else:
  switch("define","nimThreadStackSize:8192")
  switch("cpu","arm")


# Basic settings
switch("overflowChecks","on")
switch("define", "no_signal_handler")
switch("debugger", "native")
switch("threads", "on")
switch("tls_emulation", "off")
