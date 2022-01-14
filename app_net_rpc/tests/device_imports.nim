##
##  Copyright (c) 2015 Intel Corporation.
##
##  SPDX-License-Identifier: Apache-2.0
##

## *
##  @brief Device Driver APIs
##  @defgroup io_interfaces Device Driver APIs
##  @{
##  @}
##
## *
##  @brief Miscellaneous Drivers APIs
##  @defgroup misc_interfaces Miscellaneous Drivers APIs
##  @ingroup io_interfaces
##  @{
##  @}
##
## *
##  @brief Device Model APIs
##  @defgroup device_model Device Model APIs
##  @{
##

## * @brief Type used to represent devices and functions.
##
##  The extreme values and zero have special significance.  Negative
##  values identify functionality that does not correspond to a Zephyr
##  device, such as the system clock or a SYS_INIT() function.
##

type
  device_handle_t* = int16

## * @brief Flag value used in lists of device handles to separate
##  distinct groups.
##
##  This is the minimum value for the device_handle_t type.
##

var DEVICE_HANDLE_SEP* {.importc: "DEVICE_HANDLE_SEP", header: "device.h".}: int
## * @brief Flag value used in lists of device handles to indicate the
##  end of the list.
##
##  This is the maximum value for the device_handle_t type.
##

var DEVICE_HANDLE_ENDS* {.importc: "DEVICE_HANDLE_ENDS", header: "device.h".}: int
## * @brief Flag value used to identify an unknown device.

var DEVICE_HANDLE_NULL* {.importc: "DEVICE_HANDLE_NULL", header: "device.h".}: int
## *
##  @def DEVICE_NAME_GET
##
##  @brief Expands to the full name of a global device object
##
##  @details Return the full name of a device object symbol created by
##  DEVICE_DEFINE(), using the dev_name provided to DEVICE_DEFINE().
##
##  It is meant to be used for declaring extern symbols pointing on device
##  objects before using the DEVICE_GET macro to get the device object.
##
##  @param name The same as dev_name provided to DEVICE_DEFINE()
##
##  @return The expanded name of the device object created by DEVICE_DEFINE()
##

proc DEVICE_NAME_GET*(name: untyped) {.importc: "DEVICE_NAME_GET", header: "device.h".}
## *
##  @def SYS_DEVICE_DEFINE
##
##  @brief Run an initialization function at boot at specified priority,
##  and define device PM control function.
##
##  @details Invokes DEVICE_DEFINE() with no power management support
##  (@p pm_control_fn), no API (@p api_ptr), and a device name derived from
##  the @p init_fn name (@p dev_name).
##

proc SYS_DEVICE_DEFINE*(drv_name: untyped; init_fn: untyped; pm_control_fn: untyped;
                       level: untyped; prio: untyped) {.
    importc: "SYS_DEVICE_DEFINE", header: "device.h".}
## *
##  @def DEVICE_INIT
##
##  @brief Invoke DEVICE_DEFINE() with no power management support (@p
##  pm_control_fn) and no API (@p api_ptr).
##

## *
##  @def DEVICE_AND_API_INIT
##
##  @brief Invoke DEVICE_DEFINE() with no power management support (@p
##  pm_control_fn).
##

## *
##  @def DEVICE_DEFINE
##
##  @brief Create device object and set it up for boot time initialization,
##  with the option to pm_control. In case of Device Idle Power
##  Management is enabled, make sure the device is in suspended state after
##  initialization.
##
##  @details This macro defines a device object that is automatically
##  configured by the kernel during system initialization. Note that
##  devices set up with this macro will not be accessible from user mode
##  since the API is not specified;
##
##  @param dev_name Device name. This must be less than Z_DEVICE_MAX_NAME_LEN
##  characters (including terminating NUL) in order to be looked up from user
##  mode with device_get_binding().
##
##  @param drv_name The name this instance of the driver exposes to
##  the system.
##
##  @param init_fn Address to the init function of the driver.
##
##  @param pm_control_fn Pointer to pm_control function.
##  Can be NULL if not implemented.
##
##  @param data_ptr Pointer to the device's private data.
##
##  @param cfg_ptr The address to the structure containing the
##  configuration information for this instance of the driver.
##
##  @param level The initialization level.  See SYS_INIT() for
##  details.
##
##  @param prio Priority within the selected initialization level. See
##  SYS_INIT() for details.
##
##  @param api_ptr Provides an initial pointer to the API function struct
##  used by the driver. Can be NULL.
##

proc DEVICE_DEFINE*(dev_name: untyped; drv_name: untyped; init_fn: untyped;
                   pm_control_fn: untyped; data_ptr: untyped; cfg_ptr: untyped;
                   level: untyped; prio: untyped; api_ptr: untyped) {.
    importc: "DEVICE_DEFINE", header: "device.h".}
## *
##  @def DEVICE_DT_NAME
##
##  @brief Return a string name for a devicetree node.
##
##  @details This macro returns a string literal usable as a device name
##  from a devicetree node. If the node has a "label" property, its value is
##  returned. Otherwise, the node's full "node-name@@unit-address" name is
##  returned.
##
##  @param node_id The devicetree node identifier.
##

proc DEVICE_DT_NAME*(node_id: untyped) {.importc: "DEVICE_DT_NAME",
                                      header: "device.h".}
## *
##  @def DEVICE_DT_DEFINE
##
##  @brief Like DEVICE_DEFINE but taking metadata from a devicetree node.
##
##  @details This macro defines a device object that is automatically
##  configured by the kernel during system initialization.  The device
##  object name is derived from the node identifier (encoding the
##  devicetree path to the node), and the driver name is from the @p
##  label property of the devicetree node.
##
##  The device is declared with extern visibility, so device objects
##  defined through this API can be obtained directly through
##  DEVICE_DT_GET() using @p node_id.  Before using the pointer the
##  referenced object should be checked using device_is_ready().
##
##  @param node_id The devicetree node identifier.
##
##  @param init_fn Address to the init function of the driver.
##
##  @param pm_control_fn Pointer to pm_control function.
##  Can be NULL if not implemented.
##
##  @param data_ptr Pointer to the device's private data.
##
##  @param cfg_ptr The address to the structure containing the
##  configuration information for this instance of the driver.
##
##  @param level The initialization level.  See SYS_INIT() for
##  details.
##
##  @param prio Priority within the selected initialization level. See
##  SYS_INIT() for details.
##
##  @param api_ptr Provides an initial pointer to the API function struct
##  used by the driver. Can be NULL.
##

proc DEVICE_DT_DEFINE*(node_id: untyped; init_fn: untyped; pm_control_fn: untyped;
                      data_ptr: untyped; cfg_ptr: untyped; level: untyped;
                      prio: untyped; api_ptr: untyped) {.varargs,
    importc: "DEVICE_DT_DEFINE", header: "device.h".}
## *
##  @def DEVICE_DT_INST_DEFINE
##
##  @brief Like DEVICE_DT_DEFINE for an instance of a DT_DRV_COMPAT compatible
##
##  @param inst instance number.  This is replaced by
##  <tt>DT_DRV_COMPAT(inst)</tt> in the call to DEVICE_DT_DEFINE.
##
##  @param ... other parameters as expected by DEVICE_DT_DEFINE.
##

proc DEVICE_DT_INST_DEFINE*(inst: untyped) {.varargs,
    importc: "DEVICE_DT_INST_DEFINE", header: "device.h".}
## *
##  @def DEVICE_DT_NAME_GET
##
##  @brief The name of the struct device object for @p node_id
##
##  @details Return the full name of a device object symbol created by
##  DEVICE_DT_DEFINE(), using the dev_name derived from @p node_id
##
##  It is meant to be used for declaring extern symbols pointing on device
##  objects before using the DEVICE_DT_GET macro to get the device object.
##
##  @param node_id The same as node_id provided to DEVICE_DT_DEFINE()
##
##  @return The expanded name of the device object created by
##  DEVICE_DT_DEFINE()
##

proc DEVICE_DT_NAME_GET*(node_id: untyped) {.importc: "DEVICE_DT_NAME_GET",
    header: "device.h".}
## *
##  @def DEVICE_DT_GET
##
##  @brief Obtain a pointer to a device object by @p node_id
##
##  @details Return the address of a device object created by
##  DEVICE_DT_INIT(), using the dev_name derived from @p node_id
##
##  @param node_id The same as node_id provided to DEVICE_DT_DEFINE()
##
##  @return A pointer to the device object created by DEVICE_DT_DEFINE()
##

proc DEVICE_DT_GET*(node_id: untyped) {.importc: "DEVICE_DT_GET", header: "device.h".}
## * @def DEVICE_DT_INST_GET
##
##  @brief Obtain a pointer to a device object for an instance of a
##         DT_DRV_COMPAT compatible
##
##  @param inst instance number
##

proc DEVICE_DT_INST_GET*(inst: untyped) {.importc: "DEVICE_DT_INST_GET",
                                       header: "device.h".}
## *
##  @def DEVICE_DT_GET_ANY
##
##  @brief Obtain a pointer to a device object by devicetree compatible
##
##  If any enabled devicetree node has the given compatible and a
##  device object was created from it, this returns that device.
##
##  If there no such devices, this returns NULL.
##
##  If there are multiple, this returns an arbitrary one.
##
##  If this returns non-NULL, the device must be checked for readiness
##  before use, e.g. with device_is_ready().
##
##  @param compat lowercase-and-underscores devicetree compatible
##  @return a pointer to a device, or NULL
##

proc DEVICE_DT_GET_ANY*(compat: untyped) {.importc: "DEVICE_DT_GET_ANY",
                                        header: "device.h".}
## *
##  @def DEVICE_GET
##
##  @brief Obtain a pointer to a device object by name
##
##  @details Return the address of a device object created by
##  DEVICE_DEFINE(), using the dev_name provided to DEVICE_DEFINE().
##
##  @param name The same as dev_name provided to DEVICE_DEFINE()
##
##  @return A pointer to the device object created by DEVICE_DEFINE()
##

proc DEVICE_GET*(name: untyped) {.importc: "DEVICE_GET", header: "device.h".}
## * @def DEVICE_DECLARE
##
##  @brief Declare a static device object
##
##  This macro can be used at the top-level to declare a device, such
##  that DEVICE_GET() may be used before the full declaration in
##  DEVICE_DEFINE().
##
##  This is often useful when configuring interrupts statically in a
##  device's init or per-instance config function, as the init function
##  itself is required by DEVICE_DEFINE() and use of DEVICE_GET()
##  inside it creates a circular dependency.
##
##  @param name Device name
##

proc DEVICE_DECLARE*(name: untyped) {.importc: "DEVICE_DECLARE", header: "device.h".}
## *
##  @brief Runtime device dynamic structure (in RAM) per driver instance
##
##  Fields in this are expected to be default-initialized to zero.  The
##  kernel driver infrastructure and driver access functions are
##  responsible for ensuring that any non-zero initialization is done
##  before they are accessed.
##

type
  device_state* {.importc: "device_state", header: "device.h", bycopy.} = object
    init_res* {.importc: "init_res", bitsize: 8.}: cuint ## * Non-negative result of initializing the device.
                                                   ##
                                                   ##  The absolute value returned when the device initialization
                                                   ##  function was invoked, or `UINT8_MAX` if the value exceeds
                                                   ##  an 8-bit integer.  If initialized is also set, a zero value
                                                   ##  indicates initialization succeeded.
                                                   ##
    ## * Indicates the device initialization function has been
    ##  invoked.
    ##
    initialized* {.importc: "initialized", bitsize: 1.}: bool
      ##  Power management data
      var pm* {.header: "device.h".}: pm_device


## *
##  @brief Runtime device structure (in ROM) per driver instance
##

type
  device* {.importc: "device", header: "device.h", bycopy.} = object
    name* {.importc: "name".}: cstring ## * Name of the device instance
    ## * Address of device instance config information
    config* {.importc: "config".}: pointer ## * Address of the API structure exposed by the device instance
    api* {.importc: "api".}: pointer ## * Address of the common device state
    state* {.importc: "state".}: ptr device_state ## * Address of the device instance private data
    data* {.importc: "data".}: pointer ## * optional pointer to handles associated with the device.
                                   ##
                                   ##  This encodes a sequence of sets of device handles that have
                                   ##  some relationship to this node.  The individual sets are
                                   ##  extracted with dedicated API, such as
                                   ##  device_required_handles_get().
                                   ##
    handles* {.importc: "handles".}: ptr device_handle_t
      ## * Power Management function
      var pm_control*: proc (dev: ptr device; command: uint32; state: ptr uint32;
                          cb: pm_device_cb; arg: pointer): cint
      ## * Pointer to device instance power management data
      var pm* {.header: "device.h".}: ptr pm_device


## *
##  @brief Get the handle for a given device
##
##  @param dev the device for which a handle is desired.
##
##  @return the handle for the device, or DEVICE_HANDLE_NULL if the
##  device does not have an associated handle.
##

proc device_handle_get*(dev: ptr device): device_handle_t {.inline,
    importc: "device_handle_get".} =
  var ret: device_handle_t
  let __device_start: UncheckedArray[device]
  ##  TODO: If/when devices can be constructed that are not part of the
  ##  fixed sequence we'll need another solution.
  ##
  if dev != nil:
    ret = 1 + (device_handle_t)(dev - __device_start)
  return ret

## *
##  @brief Get the device corresponding to a handle.
##
##  @param dev_handle the device handle
##
##  @return the device that has that handle, or a null pointer if @p
##  dev_handle does not identify a device.
##

proc device_from_handle*(dev_handle: device_handle_t): ptr device {.inline,
    importc: "device_from_handle".} =
  let __device_start: UncheckedArray[device]
  let __device_end: UncheckedArray[device]
  let dev: ptr device
  var numdev: csize_t
  if (dev_handle > 0) and (cast[csize_t](dev_handle) < numdev):
    dev = addr(__device_start[dev_handle - 1])
  return dev

## *
##  @brief Prototype for functions used when iterating over a set of devices.
##
##  Such a function may be used in API that identifies a set of devices and
##  provides a visitor API supporting caller-specific interaction with each
##  device in the set.
##
##  The visit is said to succeed if the visitor returns a non-negative value.
##
##  @param dev a device in the set being iterated
##
##  @param context state used to support the visitor function
##
##  @return A non-negative number to allow walking to continue, and a negative
##  error code to case the iteration to stop.
##

type
  device_visitor_callback_t* = proc (dev: ptr device; context: pointer): cint

## *
##  @brief Get the set of handles for devicetree dependencies of this device.
##
##  These are the device dependencies inferred from devicetree.
##
##  @param dev the device for which dependencies are desired.
##
##  @param count pointer to a place to store the number of devices provided at
##  the returned pointer.  The value is not set if the call returns a null
##  pointer.  The value may be set to zero.
##
##  @return a pointer to a sequence of @p *count device handles, or a null
##  pointer if @p dh does not provide dependency information.
##

proc device_required_handles_get*(dev: ptr device; count: ptr csize_t): ptr device_handle_t {.
    inline, importc: "device_required_handles_get".} =
  let rv: ptr device_handle_t
  if rv != nil:
    var i: csize_t
    while (rv[i] != DEVICE_HANDLE_ENDS) and (rv[i] != DEVICE_HANDLE_SEP):
      inc(i)
    count[] = i
  return rv

## *
##  @brief Visit every device that @p dev directly requires.
##
##  Zephyr maintains information about which devices are directly required by
##  another device; for example an I2C-based sensor driver will require an I2C
##  controller for communication.  Required devices can derive from
##  statically-defined devicetree relationships or dependencies registered
##  at runtime.
##
##  This API supports operating on the set of required devices.  Example uses
##  include making sure required devices are ready before the requiring device
##  is used, and releasing them when the requiring device is no longer needed.
##
##  There is no guarantee on the order in which required devices are visited.
##
##  If the @p visitor function returns a negative value iteration is halted,
##  and the returned value from the visitor is returned from this function.
##
##  @note This API is not available to unprivileged threads.
##
##  @param dev a device of interest.  The devices that this device depends on
##  will be used as the set of devices to visit.  This parameter must not be
##  null.
##
##  @param visitor_cb the function that should be invoked on each device in the
##  dependency set.  This parameter must not be null.
##
##  @param context state that is passed through to the visitor function.  This
##  parameter may be null if @p visitor tolerates a null @p context.
##
##  @return The number of devices that were visited if all visits succeed, or
##  the negative value returned from the first visit that did not succeed.
##

proc device_required_foreach*(dev: ptr device;
                             visitor_cb: device_visitor_callback_t;
                             context: pointer): cint {.
    importc: "device_required_foreach", header: "device.h".}
## *
##  @brief Retrieve the device structure for a driver by name
##
##  @details Device objects are created via the DEVICE_DEFINE() macro and
##  placed in memory by the linker. If a driver needs to bind to another driver
##  it can use this function to retrieve the device structure of the lower level
##  driver by the name the driver exposes to the system.
##
##  @param name device name to search for.  A null pointer, or a pointer to an
##  empty string, will cause NULL to be returned.
##
##  @return pointer to device structure; NULL if not found or cannot be used.
##

proc device_get_binding*(name: cstring): ptr device {.syscall,
    importc: "device_get_binding", header: "device.h".}
## * @brief Get access to the static array of static devices.
##
##  @param devices where to store the pointer to the array of
##  statically allocated devices.  The array must not be mutated
##  through this pointer.
##
##  @return the number of statically allocated devices.
##

proc z_device_get_all_static*(devices: ptr ptr device): csize_t {.
    importc: "z_device_get_all_static", header: "device.h".}
## * @brief Determine whether a device has been successfully initialized.
##
##  @param dev pointer to the device in question.
##
##  @return true if and only if the device is available for use.
##

proc z_device_ready*(dev: ptr device): bool {.importc: "z_device_ready",
    header: "device.h".}
## * @brief Determine whether a device is ready for use
##
##  This is the implementation underlying `device_usable_check()`, without the
##  overhead of a syscall wrapper.
##
##  @param dev pointer to the device in question.
##
##  @return a non-positive integer as documented in device_usable_check().
##

proc z_device_usable_check*(dev: ptr device): cint {.inline,
    importc: "z_device_usable_check".} =
  return if z_device_ready(dev): 0 else: -ENODEV

## * @brief Determine whether a device is ready for use.
##
##  This checks whether a device can be used, returning 0 if it can, and
##  distinct error values that identify the reason if it cannot.
##
##  @retval 0 if the device is usable.
##  @retval -ENODEV if the device has not been initialized, the device pointer
##  is NULL or the initialization failed.
##  @retval other negative error codes to indicate additional conditions that
##  make the device unusable.
##

proc device_usable_check*(dev: ptr device): cint {.syscall,
    importc: "device_usable_check", header: "device.h".}
proc z_impl_device_usable_check*(dev: ptr device): cint {.inline,
    importc: "z_impl_device_usable_check".} =
  return z_device_usable_check(dev)

## * @brief Verify that a device is ready for use.
##
##  Indicates whether the provided device pointer is for a device known to be
##  in a state where it can be used with its standard API.
##
##  This can be used with device pointers captured from DEVICE_DT_GET(), which
##  does not include the readiness checks of device_get_binding().  At minimum
##  this means that the device has been successfully initialized, but it may
##  take on further conditions (e.g. is not powered down).
##
##  @param dev pointer to the device in question.
##
##  @retval true if the device is ready for use.
##  @retval false if the device is not ready for use or if a NULL device pointer
##  is passed as argument.
##

proc device_is_ready*(dev: ptr device): bool {.inline, importc: "device_is_ready".} =
  return device_usable_check(dev) == 0

## *
##  @brief Indicate that the device is in the middle of a transaction
##
##  Called by a device driver to indicate that it is in the middle of a
##  transaction.
##
##  @param dev Pointer to device structure of the driver instance.
##

proc device_busy_set*(dev: ptr device) {.importc: "device_busy_set",
                                     header: "device.h".}
## *
##  @brief Indicate that the device has completed its transaction
##
##  Called by a device driver to indicate the end of a transaction.
##
##  @param dev Pointer to device structure of the driver instance.
##

proc device_busy_clear*(dev: ptr device) {.importc: "device_busy_clear",
                                       header: "device.h".}
## *
##  @brief Check if any device is in the middle of a transaction
##
##  Called by an application to see if any device is in the middle
##  of a critical transaction that cannot be interrupted.
##
##  @retval 0 if no device is busy
##  @retval -EBUSY if any device is busy
##

proc device_any_busy_check*(): cint {.importc: "device_any_busy_check",
                                   header: "device.h".}
## *
##  @brief Check if a specific device is in the middle of a transaction
##
##  Called by an application to see if a particular device is in the
##  middle of a critical transaction that cannot be interrupted.
##
##  @param chk_dev Pointer to device structure of the specific device driver
##  the caller is interested in.
##  @retval 0 if the device is not busy
##  @retval -EBUSY if the device is busy
##

proc device_busy_check*(chk_dev: ptr device): cint {.importc: "device_busy_check",
    header: "device.h".}
## *
##  @}
##
##  Node paths can exceed the maximum size supported by device_get_binding() in user mode,
##  so synthesize a unique dev_name from the devicetree node.
##
##  The ordinal used in this name can be mapped to the path by
##  examining zephyr/include/generated/device_extern.h header.  If the
##  format of this conversion changes, gen_defines should be updated to
##  match it.
##

proc Z_DEVICE_DT_DEV_NAME*(node_id: untyped) {.importc: "Z_DEVICE_DT_DEV_NAME",
    header: "device.h".}
##  Synthesize a unique name for the device state associated with
##  dev_name.
##

proc Z_DEVICE_STATE_NAME*(dev_name: untyped) {.importc: "Z_DEVICE_STATE_NAME",
    header: "device.h".}
## * Synthesize the name of the object that holds device ordinal and
##  dependency data.  If the object doesn't come from a devicetree
##  node, use dev_name.
##

proc Z_DEVICE_HANDLE_NAME*(node_id: untyped; dev_name: untyped) {.
    importc: "Z_DEVICE_HANDLE_NAME", header: "device.h".}
proc Z_DEVICE_EXTRA_HANDLES*() {.varargs, importc: "Z_DEVICE_EXTRA_HANDLES",
                               header: "device.h".}
##  If device power management is enabled, this macro defines a pointer to a
##  device in the z_pm_device_slots region. When invoked for each device, this
##  will effectively result in a device pointer array with the same size of the
##  actual devices list. This is used internally by the device PM subsystem to
##  keep track of suspended devices during system power transitions.
##

when CONFIG_PM_DEVICE:
  proc Z_DEVICE_DEFINE_PM_SLOT*(dev_name: untyped) {.
      importc: "Z_DEVICE_DEFINE_PM_SLOT", header: "device.h".}
else:
  discard
##  Construct objects that are referenced from struct device.  These
##  include power management and dependency handles.
##

proc Z_DEVICE_DEFINE_PRE*(node_id: untyped; dev_name: untyped) {.varargs,
    importc: "Z_DEVICE_DEFINE_PRE", header: "device.h".}
##  Initial build provides a record that associates the device object
##  with its devicetree ordinal, and provides the dependency ordinals.
##  These are provided as weak definitions (to prevent the reference
##  from being captured when the original object file is compiled), and
##  in a distinct pass1 section (which will be replaced by
##  postprocessing).
##
##  It is also (experimentally) necessary to provide explicit alignment
##  on each object.  Otherwise x86-64 builds will introduce padding
##  between objects in the same input section in individual object
##  files, which will be retained in subsequent links both wasting
##  space and resulting in aggregate size changes relative to pass2
##  when all objects will be in the same input section.
##
##  The build assert will fail if device_handle_t changes size, which
##  means the alignment directives in the linker scripts and in
##  `gen_handles.py` must be updated.
##

BUILD_ASSERT(sizeof((device_handle_t)) == 2, "fix the linker scripts")
##  Like DEVICE_DEFINE but takes a node_id AND a dev_name, and trailing
##  dependency handles that come from outside devicetree.
##

proc Z_DEVICE_DEFINE*(node_id: untyped; dev_name: untyped; drv_name: untyped;
                     init_fn: untyped; pm_control_fn: untyped; data_ptr: untyped;
                     cfg_ptr: untyped; level: untyped; prio: untyped; api_ptr: untyped) {.
    varargs, importc: "Z_DEVICE_DEFINE", header: "device.h".}
##  device_extern is generated based on devicetree nodes
