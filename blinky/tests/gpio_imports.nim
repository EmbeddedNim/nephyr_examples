##
##  Copyright (c) 2019-2020 Nordic Semiconductor ASA
##  Copyright (c) 2019 Piotr Mienkowski
##  Copyright (c) 2017 ARM Ltd
##  Copyright (c) 2015-2016 Intel Corporation.
##
##  SPDX-License-Identifier: Apache-2.0
##
## *
##  @file
##  @brief Public APIs for GPIO drivers
##

## *
##  @brief GPIO Driver APIs
##  @defgroup gpio_interface GPIO Driver APIs
##  @ingroup io_interfaces
##  @{
##
## *
##  @name GPIO input/output configuration flags
##  @{
##
## * Enables pin as input.

var GPIO_INPUT* {.importc: "GPIO_INPUT", header: "gpio.h".}: int
## * Enables pin as output, no change to the output state.

var GPIO_OUTPUT* {.importc: "GPIO_OUTPUT", header: "gpio.h".}: int
## * Disables pin for both input and output.

var GPIO_DISCONNECTED* {.importc: "GPIO_DISCONNECTED", header: "gpio.h".}: int
## * @cond INTERNAL_HIDDEN
##  Initializes output to a low state.

var GPIO_OUTPUT_INIT_LOW* {.importc: "GPIO_OUTPUT_INIT_LOW", header: "gpio.h".}: int
##  Initializes output to a high state.

var GPIO_OUTPUT_INIT_HIGH* {.importc: "GPIO_OUTPUT_INIT_HIGH", header: "gpio.h".}: int
##  Initializes output based on logic level

var GPIO_OUTPUT_INIT_LOGICAL* {.importc: "GPIO_OUTPUT_INIT_LOGICAL",
                              header: "gpio.h".}: int
## * @endcond
## * Configures GPIO pin as output and initializes it to a low state.

var GPIO_OUTPUT_LOW* {.importc: "GPIO_OUTPUT_LOW", header: "gpio.h".}: int
## * Configures GPIO pin as output and initializes it to a high state.

var GPIO_OUTPUT_HIGH* {.importc: "GPIO_OUTPUT_HIGH", header: "gpio.h".}: int
## * Configures GPIO pin as output and initializes it to a logic 0.

var GPIO_OUTPUT_INACTIVE* {.importc: "GPIO_OUTPUT_INACTIVE", header: "gpio.h".}: int
## * Configures GPIO pin as output and initializes it to a logic 1.

var GPIO_OUTPUT_ACTIVE* {.importc: "GPIO_OUTPUT_ACTIVE", header: "gpio.h".}: int
## * @}
## *
##  @name GPIO interrupt configuration flags
##  The `GPIO_INT_*` flags are used to specify how input GPIO pins will trigger
##  interrupts. The interrupts can be sensitive to pin physical or logical level.
##  Interrupts sensitive to pin logical level take into account GPIO_ACTIVE_LOW
##  flag. If a pin was configured as Active Low, physical level low will be
##  considered as logical level 1 (an active state), physical level high will
##  be considered as logical level 0 (an inactive state).
##  @{
##
## * Disables GPIO pin interrupt.

var GPIO_INT_DISABLE* {.importc: "GPIO_INT_DISABLE", header: "gpio.h".}: int
## * @cond INTERNAL_HIDDEN
##  Enables GPIO pin interrupt.

var GPIO_INT_ENABLE* {.importc: "GPIO_INT_ENABLE", header: "gpio.h".}: int
##  GPIO interrupt is sensitive to logical levels.
##
##  This is a component flag that should be combined with other
##  `GPIO_INT_*` flags to produce a meaningful configuration.
##

var GPIO_INT_LEVELS_LOGICAL* {.importc: "GPIO_INT_LEVELS_LOGICAL", header: "gpio.h".}: int
##  GPIO interrupt is edge sensitive.
##
##  Note: by default interrupts are level sensitive.
##
##  This is a component flag that should be combined with other
##  `GPIO_INT_*` flags to produce a meaningful configuration.
##

var GPIO_INT_EDGE* {.importc: "GPIO_INT_EDGE", header: "gpio.h".}: int
##  Trigger detection when input state is (or transitions to) physical low or
##  logical 0 level.
##
##  This is a component flag that should be combined with other
##  `GPIO_INT_*` flags to produce a meaningful configuration.
##

var GPIO_INT_LOW_0* {.importc: "GPIO_INT_LOW_0", header: "gpio.h".}: int
##  Trigger detection on input state is (or transitions to) physical high or
##  logical 1 level.
##
##  This is a component flag that should be combined with other
##  `GPIO_INT_*` flags to produce a meaningful configuration.
##

var GPIO_INT_HIGH_1* {.importc: "GPIO_INT_HIGH_1", header: "gpio.h".}: int
## * @endcond
## * Configures GPIO interrupt to be triggered on pin rising edge and enables it.
##

var GPIO_INT_EDGE_RISING* {.importc: "GPIO_INT_EDGE_RISING", header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin falling edge and enables
##  it.
##

var GPIO_INT_EDGE_FALLING* {.importc: "GPIO_INT_EDGE_FALLING", header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin rising or falling edge and
##  enables it.
##

var GPIO_INT_EDGE_BOTH* {.importc: "GPIO_INT_EDGE_BOTH", header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin physical level low and
##  enables it.
##

var GPIO_INT_LEVEL_LOW* {.importc: "GPIO_INT_LEVEL_LOW", header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin physical level high and
##  enables it.
##

var GPIO_INT_LEVEL_HIGH* {.importc: "GPIO_INT_LEVEL_HIGH", header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin state change to logical
##  level 0 and enables it.
##

var GPIO_INT_EDGE_TO_INACTIVE* {.importc: "GPIO_INT_EDGE_TO_INACTIVE",
                               header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin state change to logical
##  level 1 and enables it.
##

var GPIO_INT_EDGE_TO_ACTIVE* {.importc: "GPIO_INT_EDGE_TO_ACTIVE", header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin logical level 0 and enables
##  it.
##

var GPIO_INT_LEVEL_INACTIVE* {.importc: "GPIO_INT_LEVEL_INACTIVE", header: "gpio.h".}: int
## * Configures GPIO interrupt to be triggered on pin logical level 1 and enables
##  it.
##

var GPIO_INT_LEVEL_ACTIVE* {.importc: "GPIO_INT_LEVEL_ACTIVE", header: "gpio.h".}: int
## * @}
## * Enable GPIO pin debounce.
##
##  @note Drivers that do not support a debounce feature should ignore
##  this flag rather than rejecting the configuration with -ENOTSUP.
##

var GPIO_INT_DEBOUNCE* {.importc: "GPIO_INT_DEBOUNCE", header: "gpio.h".}: int
## *
##  @name GPIO drive strength flags
##  The `GPIO_DS_*` flags are used with `gpio_pin_configure` to specify the drive
##  strength configuration of a GPIO pin.
##
##  The drive strength of individual pins can be configured
##  independently for when the pin output is low and high.
##
##  The `GPIO_DS_*_LOW` enumerations define the drive strength of a pin
##  when output is low.
##
##  The `GPIO_DS_*_HIGH` enumerations define the drive strength of a pin
##  when output is high.
##
##  The interface supports two different drive strengths:
##  `DFLT` - The lowest drive strength supported by the HW
##  `ALT` - The highest drive strength supported by the HW
##
##  On hardware that supports only one standard drive strength, both
##  `DFLT` and `ALT` have the same behavior.
##  @{
##
## * @cond INTERNAL_HIDDEN

var GPIO_DS_LOW_POS* {.importc: "GPIO_DS_LOW_POS", header: "gpio.h".}: int
## * @endcond
## * Default drive strength standard when GPIO pin output is low.
##

var GPIO_DS_DFLT_LOW* {.importc: "GPIO_DS_DFLT_LOW", header: "gpio.h".}: int
## * Alternative drive strength when GPIO pin output is low.
##  For hardware that does not support configurable drive strength
##  use the default drive strength.
##

var GPIO_DS_ALT_LOW* {.importc: "GPIO_DS_ALT_LOW", header: "gpio.h".}: int
## * @cond INTERNAL_HIDDEN

var GPIO_DS_HIGH_POS* {.importc: "GPIO_DS_HIGH_POS", header: "gpio.h".}: int
## * @endcond
## * Default drive strength when GPIO pin output is high.
##

var GPIO_DS_DFLT_HIGH* {.importc: "GPIO_DS_DFLT_HIGH", header: "gpio.h".}: int
## * Alternative drive strength when GPIO pin output is high.
##  For hardware that does not support configurable drive strengths
##  use the default drive strength.
##

var GPIO_DS_ALT_HIGH* {.importc: "GPIO_DS_ALT_HIGH", header: "gpio.h".}: int
## * @}
## * @cond INTERNAL_HIDDEN

var GPIO_DIR_MASK* {.importc: "GPIO_DIR_MASK", header: "gpio.h".}: int
## * @endcond
## *
##  @brief Identifies a set of pins associated with a port.
##
##  The pin with index n is present in the set if and only if the bit
##  identified by (1U << n) is set.
##

type
  gpio_port_pins_t* = uint32

## *
##  @brief Provides values for a set of pins associated with a port.
##
##  The value for a pin with index n is high (physical mode) or active
##  (logical mode) if and only if the bit identified by (1U << n) is set.
##  Otherwise the value for the pin is low (physical mode) or inactive
##  (logical mode).
##
##  Values of this type are often paired with a `gpio_port_pins_t` value
##  that specifies which encoded pin values are valid for the operation.
##

type
  gpio_port_value_t* = uint32

## *
##  @brief Provides a type to hold a GPIO pin index.
##
##  This reduced-size type is sufficient to record a pin number,
##  e.g. from a devicetree GPIOS property.
##

type
  gpio_pin_t* = uint8

## *
##  @brief Provides a type to hold GPIO devicetree flags.
##
##  All GPIO flags that can be expressed in devicetree fit in the low 8
##  bits of the full flags field, so use a reduced-size type to record
##  that part of a GPIOS property.
##

type
  gpio_dt_flags_t* = uint8

## *
##  @brief Provides a type to hold GPIO configuration flags.
##
##  This type is sufficient to hold all flags used to control GPIO
##  configuration, whether pin or interrupt.
##

type
  gpio_flags_t* = uint32

## *
##  @brief Provides a type to hold GPIO information specified in devicetree
##
##  This type is sufficient to hold a GPIO device pointer, pin number,
##  and the subset of the flags used to control GPIO configuration
##  which may be given in devicetree.
##

type
  gpio_dt_spec* {.importc: "gpio_dt_spec", header: "gpio.h", bycopy.} = object
    port* {.importc: "port".}: ptr device
    pin* {.importc: "pin".}: gpio_pin_t
    dt_flags* {.importc: "dt_flags".}: gpio_dt_flags_t


## *
##  @brief Static initializer for a @p gpio_dt_spec
##
##  This returns a static initializer for a @p gpio_dt_spec structure given a
##  devicetree node identifier, a property specifying a GPIO and an index.
##
##  Example devicetree fragment:
##
## 	n: node {
## 		foo-gpios = <&gpio0 1 GPIO_ACTIVE_LOW>,
## 			    <&gpio1 2 GPIO_ACTIVE_LOW>;
## 	}
##
##  Example usage:
##
## 	const struct gpio_dt_spec spec = GPIO_DT_SPEC_GET_BY_IDX(DT_NODELABEL(n),
## 								 foo_gpios, 1);
## 	// Initializes 'spec' to:
## 	// {
## 	//         .port = DEVICE_DT_GET(DT_NODELABEL(gpio1)),
## 	//         .pin = 2,
## 	//         .dt_flags = GPIO_ACTIVE_LOW
## 	// }
##
##  The 'gpio' field must still be checked for readiness, e.g. using
##  device_is_ready(). It is an error to use this macro unless the node
##  exists, has the given property, and that property specifies a GPIO
##  controller, pin number, and flags as shown above.
##
##  @param node_id devicetree node identifier
##  @param prop lowercase-and-underscores property name
##  @param idx logical index into "prop"
##  @return static initializer for a struct gpio_dt_spec for the property
##

proc GPIO_DT_SPEC_GET_BY_IDX*(node_id: untyped; prop: untyped; idx: untyped) {.
    importc: "GPIO_DT_SPEC_GET_BY_IDX", header: "gpio.h".}
## *
##  @brief Like GPIO_DT_SPEC_GET_BY_IDX(), with a fallback to a default value
##
##  If the devicetree node identifier 'node_id' refers to a node with a
##  property 'prop', this expands to
##  <tt>GPIO_DT_SPEC_GET_BY_IDX(node_id, prop, idx)</tt>. The @p
##  default_value parameter is not expanded in this case.
##
##  Otherwise, this expands to @p default_value.
##
##  @param node_id devicetree node identifier
##  @param prop lowercase-and-underscores property name
##  @param idx logical index into "prop"
##  @param default_value fallback value to expand to
##  @return static initializer for a struct gpio_dt_spec for the property,
##          or default_value if the node or property do not exist
##

proc GPIO_DT_SPEC_GET_BY_IDX_OR*(node_id: untyped; prop: untyped; idx: untyped;
                                default_value: untyped) {.
    importc: "GPIO_DT_SPEC_GET_BY_IDX_OR", header: "gpio.h".}
## *
##  @brief Equivalent to GPIO_DT_SPEC_GET_BY_IDX(node_id, prop, 0).
##
##  @param node_id devicetree node identifier
##  @param prop lowercase-and-underscores property name
##  @return static initializer for a struct gpio_dt_spec for the property
##  @see GPIO_DT_SPEC_GET_BY_IDX()
##

proc GPIO_DT_SPEC_GET*(node_id: untyped; prop: untyped) {.
    importc: "GPIO_DT_SPEC_GET", header: "gpio.h".}
## *
##  @brief Equivalent to
##         GPIO_DT_SPEC_GET_BY_IDX_OR(node_id, prop, 0, default_value).
##
##  @param node_id devicetree node identifier
##  @param prop lowercase-and-underscores property name
##  @param default_value fallback value to expand to
##  @return static initializer for a struct gpio_dt_spec for the property
##  @see GPIO_DT_SPEC_GET_BY_IDX_OR()
##

proc GPIO_DT_SPEC_GET_OR*(node_id: untyped; prop: untyped; default_value: untyped) {.
    importc: "GPIO_DT_SPEC_GET_OR", header: "gpio.h".}
## *
##  @brief Static initializer for a @p gpio_dt_spec from a DT_DRV_COMPAT
##  instance's GPIO property at an index.
##
##  @param inst DT_DRV_COMPAT instance number
##  @param prop lowercase-and-underscores property name
##  @param idx logical index into "prop"
##  @return static initializer for a struct gpio_dt_spec for the property
##  @see GPIO_DT_SPEC_GET_BY_IDX()
##

proc GPIO_DT_SPEC_INST_GET_BY_IDX*(inst: untyped; prop: untyped; idx: untyped) {.
    importc: "GPIO_DT_SPEC_INST_GET_BY_IDX", header: "gpio.h".}
## *
##  @brief Static initializer for a @p gpio_dt_spec from a DT_DRV_COMPAT
##         instance's GPIO property at an index, with fallback
##
##  @param inst DT_DRV_COMPAT instance number
##  @param prop lowercase-and-underscores property name
##  @param idx logical index into "prop"
##  @param default_value fallback value to expand to
##  @return static initializer for a struct gpio_dt_spec for the property
##  @see GPIO_DT_SPEC_GET_BY_IDX()
##

proc GPIO_DT_SPEC_INST_GET_BY_IDX_OR*(inst: untyped; prop: untyped; idx: untyped;
                                     default_value: untyped) {.
    importc: "GPIO_DT_SPEC_INST_GET_BY_IDX_OR", header: "gpio.h".}
## *
##  @brief Equivalent to GPIO_DT_SPEC_INST_GET_BY_IDX(inst, prop, 0).
##
##  @param inst DT_DRV_COMPAT instance number
##  @param prop lowercase-and-underscores property name
##  @return static initializer for a struct gpio_dt_spec for the property
##  @see GPIO_DT_SPEC_INST_GET_BY_IDX()
##

proc GPIO_DT_SPEC_INST_GET*(inst: untyped; prop: untyped) {.
    importc: "GPIO_DT_SPEC_INST_GET", header: "gpio.h".}
## *
##  @brief Equivalent to
##         GPIO_DT_SPEC_INST_GET_BY_IDX_OR(inst, prop, 0, default_value).
##
##  @param inst DT_DRV_COMPAT instance number
##  @param prop lowercase-and-underscores property name
##  @param default_value fallback value to expand to
##  @return static initializer for a struct gpio_dt_spec for the property
##  @see GPIO_DT_SPEC_INST_GET_BY_IDX()
##

proc GPIO_DT_SPEC_INST_GET_OR*(inst: untyped; prop: untyped; default_value: untyped) {.
    importc: "GPIO_DT_SPEC_INST_GET_OR", header: "gpio.h".}
## *
##  @brief Maximum number of pins that are supported by `gpio_port_pins_t`.
##

var GPIO_MAX_PINS_PER_PORT* {.importc: "GPIO_MAX_PINS_PER_PORT", header: "gpio.h".}: int
## *
##  This structure is common to all GPIO drivers and is expected to be
##  the first element in the object pointed to by the config field
##  in the device structure.
##

type
  gpio_driver_config* {.importc: "gpio_driver_config", header: "gpio.h", bycopy.} = object
    port_pin_mask* {.importc: "port_pin_mask".}: gpio_port_pins_t ##  Mask identifying pins supported by the controller.
                                                              ##
                                                              ##  Initialization of this mask is the responsibility of device
                                                              ##  instance generation in the driver.
                                                              ##


## *
##  This structure is common to all GPIO drivers and is expected to be the first
##  element in the driver's struct driver_data declaration.
##

type
  gpio_driver_data* {.importc: "gpio_driver_data", header: "gpio.h", bycopy.} = object
    invert* {.importc: "invert".}: gpio_port_pins_t ##  Mask identifying pins that are configured as active low.
                                                ##
                                                ##  Management of this mask is the responsibility of the
                                                ##  wrapper functions in this header.
                                                ##


discard "forward decl of gpio_callback"
type
  gpio_callback_handler_t* = proc (port: ptr device; cb: ptr gpio_callback;
                                pins: gpio_port_pins_t)

## *
##  @brief GPIO callback structure
##
##  Used to register a callback in the driver instance callback list.
##  As many callbacks as needed can be added as long as each of them
##  are unique pointers of struct gpio_callback.
##  Beware such structure should not be allocated on stack.
##
##  Note: To help setting it, see gpio_init_callback() below
##

type
  gpio_callback* {.importc: "gpio_callback", header: "gpio.h", bycopy.} = object
    node* {.importc: "node".}: sys_snode_t ## * This is meant to be used in the driver and the user should not
                                       ##  mess with it (see drivers/gpio/gpio_utils.h)
                                       ##
    ## * Actual callback function being called when relevant.
    handler* {.importc: "handler".}: gpio_callback_handler_t ## * A mask of pins the callback is interested in, if 0 the callback
                                                         ##  will never be called. Such pin_mask can be modified whenever
                                                         ##  necessary by the owner, and thus will affect the handler being
                                                         ##  called or not. The selected pins must be configured to trigger
                                                         ##  an interrupt.
                                                         ##
    pin_mask* {.importc: "pin_mask".}: gpio_port_pins_t


## *
##  @cond INTERNAL_HIDDEN
##
##  For internal use only, skip these in public documentation.
##
##  Used by driver api function pin_interrupt_configure, these are defined
##  in terms of the public flags so we can just mask and pass them
##  through to the driver api
##

type
  gpio_int_mode* {.size: sizeof(cint).} = enum
    GPIO_INT_MODE_DISABLED = GPIO_INT_DISABLE,
    GPIO_INT_MODE_LEVEL = GPIO_INT_ENABLE,
    GPIO_INT_MODE_EDGE = GPIO_INT_ENABLE or GPIO_INT_EDGE


type
  gpio_int_trig* {.size: sizeof(cint).} = enum ##  Trigger detection when input state is (or transitions to)
                                          ##  physical low. (Edge Failing or Active Low)
    GPIO_INT_TRIG_LOW = GPIO_INT_LOW_0, ##  Trigger detection when input state is (or transitions to)
                                     ##  physical high. (Edge Rising or Active High)
    GPIO_INT_TRIG_HIGH = GPIO_INT_HIGH_1, ##  Trigger detection on pin rising or falling edge.
    GPIO_INT_TRIG_BOTH = GPIO_INT_LOW_0 or GPIO_INT_HIGH_1


type
  gpio_driver_api* {.importc: "gpio_driver_api", header: "gpio.h", bycopy.} = object
    pin_configure* {.importc: "pin_configure".}: proc (port: ptr device;
        pin: gpio_pin_t; flags: gpio_flags_t): cint
    port_get_raw* {.importc: "port_get_raw".}: proc (port: ptr device;
        value: ptr gpio_port_value_t): cint
    port_set_masked_raw* {.importc: "port_set_masked_raw".}: proc (port: ptr device;
        mask: gpio_port_pins_t; value: gpio_port_value_t): cint
    port_set_bits_raw* {.importc: "port_set_bits_raw".}: proc (port: ptr device;
        pins: gpio_port_pins_t): cint
    port_clear_bits_raw* {.importc: "port_clear_bits_raw".}: proc (port: ptr device;
        pins: gpio_port_pins_t): cint
    port_toggle_bits* {.importc: "port_toggle_bits".}: proc (port: ptr device;
        pins: gpio_port_pins_t): cint
    pin_interrupt_configure* {.importc: "pin_interrupt_configure".}: proc (
        port: ptr device; pin: gpio_pin_t; a3: gpio_int_mode; a4: gpio_int_trig): cint
    manage_callback* {.importc: "manage_callback".}: proc (port: ptr device;
        cb: ptr gpio_callback; set: bool): cint
    get_pending_int* {.importc: "get_pending_int".}: proc (dev: ptr device): uint32


## *
##  @endcond
##
## *
##  @brief Configure pin interrupt.
##
##  @note This function can also be used to configure interrupts on pins
##        not controlled directly by the GPIO module. That is, pins which are
##        routed to other modules such as I2C, SPI, UART.
##
##  @param port Pointer to device structure for the driver instance.
##  @param pin Pin number.
##  @param flags Interrupt configuration flags as defined by GPIO_INT_*.
##
##  @retval 0 If successful.
##  @retval -ENOTSUP If any of the configuration options is not supported
##                   (unless otherwise directed by flag documentation).
##  @retval -EINVAL  Invalid argument.
##  @retval -EBUSY   Interrupt line required to configure pin interrupt is
##                   already in use.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_pin_interrupt_configure*(port: ptr device; pin: gpio_pin_t;
                                  flags: gpio_flags_t): cint {.syscall,
    importc: "gpio_pin_interrupt_configure", header: "gpio.h".}
proc z_impl_gpio_pin_interrupt_configure*(port: ptr device; pin: gpio_pin_t;
    flags: gpio_flags_t): cint {.inline,
                              importc: "z_impl_gpio_pin_interrupt_configure".} =
  let api: ptr gpio_driver_api
  let cfg: ptr gpio_driver_config
  let data: ptr gpio_driver_data
  var trig: gpio_int_trig
  var mode: gpio_int_mode
  __ASSERT_NO_MSG((flags and GPIO_INT_DEBOUNCE) == 0)
  __ASSERT((flags and (GPIO_INT_DISABLE or GPIO_INT_ENABLE)) !=
      (GPIO_INT_DISABLE or GPIO_INT_ENABLE),
           "Cannot both enable and disable interrupts")
  __ASSERT((flags and (GPIO_INT_DISABLE or GPIO_INT_ENABLE)) != 0'u,
           "Must either enable or disable interrupts")
  __ASSERT(((flags and GPIO_INT_ENABLE) == 0) or ((flags and GPIO_INT_EDGE) != 0) or
      ((flags and (GPIO_INT_LOW_0 or GPIO_INT_HIGH_1)) !=
      (GPIO_INT_LOW_0 or GPIO_INT_HIGH_1)), "Only one of GPIO_INT_LOW_0, GPIO_INT_HIGH_1 can be enabled for a level interrupt.")
  __ASSERT(((flags and GPIO_INT_ENABLE) == 0) or
      ((flags and (GPIO_INT_LOW_0 or GPIO_INT_HIGH_1)) != 0),
           "At least one of GPIO_INT_LOW_0, GPIO_INT_HIGH_1 has to be enabled.")
  cast[nil](cfg)
  __ASSERT((cfg.port_pin_mask and cast[gpio_port_pins_t](BIT(pin))) != 0'u,
           "Unsupported pin")
  if ((flags and GPIO_INT_LEVELS_LOGICAL) != 0) and
      ((data.invert and cast[gpio_port_pins_t](BIT(pin))) != 0):
    ##  Invert signal bits
    flags = flags xor (GPIO_INT_LOW_0 or GPIO_INT_HIGH_1)
  trig = cast[gpio_int_trig]((flags and (GPIO_INT_LOW_0 or GPIO_INT_HIGH_1)))
  mode = cast[gpio_int_mode]((flags and
      (GPIO_INT_EDGE or GPIO_INT_DISABLE or GPIO_INT_ENABLE)))
  return api.pin_interrupt_configure(port, pin, mode, trig)

## *
##  @brief Configure pin interrupts from a @p gpio_dt_spec.
##
##  This is equivalent to:
##
##      gpio_pin_interrupt_configure(spec->port, spec->pin, flags);
##
##  The <tt>spec->dt_flags</tt> value is not used.
##
##  @param spec GPIO specification from devicetree
##  @param flags interrupt configuration flags
##  @retval a value from gpio_pin_interrupt_configure()
##

proc gpio_pin_interrupt_configure_dt*(spec: ptr gpio_dt_spec; flags: gpio_flags_t): cint {.
    inline, importc: "gpio_pin_interrupt_configure_dt".} =
  return gpio_pin_interrupt_configure(spec.port, spec.pin, flags)

## *
##  @brief Configure a single pin.
##
##  @param port Pointer to device structure for the driver instance.
##  @param pin Pin number to configure.
##  @param flags Flags for pin configuration: 'GPIO input/output configuration
##         flags', 'GPIO drive strength flags', 'GPIO pin drive flags', 'GPIO pin
##         bias flags', GPIO_INT_DEBOUNCE.
##
##  @retval 0 If successful.
##  @retval -ENOTSUP if any of the configuration options is not supported
##                   (unless otherwise directed by flag documentation).
##  @retval -EINVAL Invalid argument.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_pin_configure*(port: ptr device; pin: gpio_pin_t; flags: gpio_flags_t): cint {.
    syscall, importc: "gpio_pin_configure", header: "gpio.h".}
proc z_impl_gpio_pin_configure*(port: ptr device; pin: gpio_pin_t; flags: gpio_flags_t): cint {.
    inline, importc: "z_impl_gpio_pin_configure".} =
  let api: ptr gpio_driver_api
  let cfg: ptr gpio_driver_config
  var data: ptr gpio_driver_data
  __ASSERT((flags and GPIO_INT_MASK) == 0, "Interrupt flags are not supported")
  __ASSERT((flags and (GPIO_PULL_UP or GPIO_PULL_DOWN)) !=
      (GPIO_PULL_UP or GPIO_PULL_DOWN),
           "Pull Up and Pull Down should not be enabled simultaneously")
  __ASSERT((flags and GPIO_OUTPUT) != 0 or (flags and GPIO_SINGLE_ENDED) == 0, "Output needs to be enabled for \'Open Drain\', \'Open Source\' mode to be supported")
  __ASSERT_NO_MSG((flags and GPIO_SINGLE_ENDED) != 0 or
      (flags and GPIO_LINE_OPEN_DRAIN) == 0)
  __ASSERT((flags and (GPIO_OUTPUT_INIT_LOW or GPIO_OUTPUT_INIT_HIGH)) == 0 or
      (flags and GPIO_OUTPUT) != 0,
           "Output needs to be enabled to be initialized low or high")
  __ASSERT((flags and (GPIO_OUTPUT_INIT_LOW or GPIO_OUTPUT_INIT_HIGH)) !=
      (GPIO_OUTPUT_INIT_LOW or GPIO_OUTPUT_INIT_HIGH),
           "Output cannot be initialized low and high")
  if ((flags and GPIO_OUTPUT_INIT_LOGICAL) != 0) and
      ((flags and (GPIO_OUTPUT_INIT_LOW or GPIO_OUTPUT_INIT_HIGH)) != 0) and
      ((flags and GPIO_ACTIVE_LOW) != 0):
    flags = flags xor (GPIO_OUTPUT_INIT_LOW or GPIO_OUTPUT_INIT_HIGH)
  flags = flags and not GPIO_OUTPUT_INIT_LOGICAL
  cast[nil](cfg)
  __ASSERT((cfg.port_pin_mask and cast[gpio_port_pins_t](BIT(pin))) != 0'u,
           "Unsupported pin")
  if (flags and GPIO_ACTIVE_LOW) != 0:
    data.invert = data.invert or cast[gpio_port_pins_t](BIT(pin))
  else:
    data.invert = data.invert and not cast[gpio_port_pins_t](BIT(pin))
  return api.pin_configure(port, pin, flags)

## *
##  @brief Configure a single pin from a @p gpio_dt_spec and some extra flags.
##
##  This is equivalent to:
##
##      gpio_pin_configure(spec->port, spec->pin, spec->dt_flags | extra_flags);
##
##  @param spec GPIO specification from devicetree
##  @param extra_flags additional flags
##  @retval a value from gpio_pin_configure()
##

proc gpio_pin_configure_dt*(spec: ptr gpio_dt_spec; extra_flags: gpio_flags_t): cint {.
    inline, importc: "gpio_pin_configure_dt".} =
  return gpio_pin_configure(spec.port, spec.pin, spec.dt_flags or extra_flags)

## *
##  @brief Get physical level of all input pins in a port.
##
##  A low physical level on the pin will be interpreted as value 0. A high
##  physical level will be interpreted as value 1. This function ignores
##  GPIO_ACTIVE_LOW flag.
##
##  Value of a pin with index n will be represented by bit n in the returned
##  port value.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param value Pointer to a variable where pin values will be stored.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_get_raw*(port: ptr device; value: ptr gpio_port_value_t): cint {.syscall,
    importc: "gpio_port_get_raw", header: "gpio.h".}
proc z_impl_gpio_port_get_raw*(port: ptr device; value: ptr gpio_port_value_t): cint {.
    inline, importc: "z_impl_gpio_port_get_raw".} =
  let api: ptr gpio_driver_api
  return api.port_get_raw(port, value)

## *
##  @brief Get logical level of all input pins in a port.
##
##  Get logical level of an input pin taking into account GPIO_ACTIVE_LOW flag.
##  If pin is configured as Active High, a low physical level will be interpreted
##  as logical value 0. If pin is configured as Active Low, a low physical level
##  will be interpreted as logical value 1.
##
##  Value of a pin with index n will be represented by bit n in the returned
##  port value.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param value Pointer to a variable where pin values will be stored.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_get*(port: ptr device; value: ptr gpio_port_value_t): cint {.inline,
    importc: "gpio_port_get".} =
  let data: ptr gpio_driver_data
  var ret: cint
  ret = gpio_port_get_raw(port, value)
  if ret == 0:
    value[] = value[] xor data.invert
  return ret

## *
##  @brief Set physical level of output pins in a port.
##
##  Writing value 0 to the pin will set it to a low physical level. Writing
##  value 1 will set it to a high physical level. This function ignores
##  GPIO_ACTIVE_LOW flag.
##
##  Pin with index n is represented by bit n in mask and value parameter.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param mask Mask indicating which pins will be modified.
##  @param value Value assigned to the output pins.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_set_masked_raw*(port: ptr device; mask: gpio_port_pins_t;
                              value: gpio_port_value_t): cint {.syscall,
    importc: "gpio_port_set_masked_raw", header: "gpio.h".}
proc z_impl_gpio_port_set_masked_raw*(port: ptr device; mask: gpio_port_pins_t;
                                     value: gpio_port_value_t): cint {.inline,
    importc: "z_impl_gpio_port_set_masked_raw".} =
  let api: ptr gpio_driver_api
  return api.port_set_masked_raw(port, mask, value)

## *
##  @brief Set logical level of output pins in a port.
##
##  Set logical level of an output pin taking into account GPIO_ACTIVE_LOW flag.
##  Value 0 sets the pin in logical 0 / inactive state. Value 1 sets the pin in
##  logical 1 / active state. If pin is configured as Active High, the default,
##  setting it in inactive state will force the pin to a low physical level. If
##  pin is configured as Active Low, setting it in inactive state will force the
##  pin to a high physical level.
##
##  Pin with index n is represented by bit n in mask and value parameter.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param mask Mask indicating which pins will be modified.
##  @param value Value assigned to the output pins.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_set_masked*(port: ptr device; mask: gpio_port_pins_t;
                          value: gpio_port_value_t): cint {.inline,
    importc: "gpio_port_set_masked".} =
  let data: ptr gpio_driver_data
  value = value xor data.invert
  return gpio_port_set_masked_raw(port, mask, value)

## *
##  @brief Set physical level of selected output pins to high.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pins Value indicating which pins will be modified.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_set_bits_raw*(port: ptr device; pins: gpio_port_pins_t): cint {.syscall,
    importc: "gpio_port_set_bits_raw", header: "gpio.h".}
proc z_impl_gpio_port_set_bits_raw*(port: ptr device; pins: gpio_port_pins_t): cint {.
    inline, importc: "z_impl_gpio_port_set_bits_raw".} =
  let api: ptr gpio_driver_api
  return api.port_set_bits_raw(port, pins)

## *
##  @brief Set logical level of selected output pins to active.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pins Value indicating which pins will be modified.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_set_bits*(port: ptr device; pins: gpio_port_pins_t): cint {.inline,
    importc: "gpio_port_set_bits".} =
  return gpio_port_set_masked(port, pins, pins)

## *
##  @brief Set physical level of selected output pins to low.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pins Value indicating which pins will be modified.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_clear_bits_raw*(port: ptr device; pins: gpio_port_pins_t): cint {.
    syscall, importc: "gpio_port_clear_bits_raw", header: "gpio.h".}
proc z_impl_gpio_port_clear_bits_raw*(port: ptr device; pins: gpio_port_pins_t): cint {.
    inline, importc: "z_impl_gpio_port_clear_bits_raw".} =
  let api: ptr gpio_driver_api
  return api.port_clear_bits_raw(port, pins)

## *
##  @brief Set logical level of selected output pins to inactive.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pins Value indicating which pins will be modified.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_clear_bits*(port: ptr device; pins: gpio_port_pins_t): cint {.inline,
    importc: "gpio_port_clear_bits".} =
  return gpio_port_set_masked(port, pins, 0)

## *
##  @brief Toggle level of selected output pins.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pins Value indicating which pins will be modified.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_toggle_bits*(port: ptr device; pins: gpio_port_pins_t): cint {.syscall,
    importc: "gpio_port_toggle_bits", header: "gpio.h".}
proc z_impl_gpio_port_toggle_bits*(port: ptr device; pins: gpio_port_pins_t): cint {.
    inline, importc: "z_impl_gpio_port_toggle_bits".} =
  let api: ptr gpio_driver_api
  return api.port_toggle_bits(port, pins)

## *
##  @brief Set physical level of selected output pins.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param set_pins Value indicating which pins will be set to high.
##  @param clear_pins Value indicating which pins will be set to low.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_set_clr_bits_raw*(port: ptr device; set_pins: gpio_port_pins_t;
                                clear_pins: gpio_port_pins_t): cint {.inline,
    importc: "gpio_port_set_clr_bits_raw".} =
  __ASSERT((set_pins and clear_pins) == 0, "Set and Clear pins overlap")
  return gpio_port_set_masked_raw(port, set_pins or clear_pins, set_pins)

## *
##  @brief Set logical level of selected output pins.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param set_pins Value indicating which pins will be set to active.
##  @param clear_pins Value indicating which pins will be set to inactive.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_port_set_clr_bits*(port: ptr device; set_pins: gpio_port_pins_t;
                            clear_pins: gpio_port_pins_t): cint {.inline,
    importc: "gpio_port_set_clr_bits".} =
  __ASSERT((set_pins and clear_pins) == 0, "Set and Clear pins overlap")
  return gpio_port_set_masked(port, set_pins or clear_pins, set_pins)

## *
##  @brief Get physical level of an input pin.
##
##  A low physical level on the pin will be interpreted as value 0. A high
##  physical level will be interpreted as value 1. This function ignores
##  GPIO_ACTIVE_LOW flag.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pin Pin number.
##
##  @retval 1 If pin physical level is high.
##  @retval 0 If pin physical level is low.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_pin_get_raw*(port: ptr device; pin: gpio_pin_t): cint {.inline,
    importc: "gpio_pin_get_raw".} =
  let cfg: ptr gpio_driver_config
  var value: gpio_port_value_t
  var ret: cint
  cast[nil](cfg)
  __ASSERT((cfg.port_pin_mask and cast[gpio_port_pins_t](BIT(pin))) != 0'u,
           "Unsupported pin")
  ret = gpio_port_get_raw(port, addr(value))
  if ret == 0:
    ret = if (value and cast[gpio_port_pins_t](BIT(pin))) != 0: 1 else: 0
  return ret

## *
##  @brief Get logical level of an input pin.
##
##  Get logical level of an input pin taking into account GPIO_ACTIVE_LOW flag.
##  If pin is configured as Active High, a low physical level will be interpreted
##  as logical value 0. If pin is configured as Active Low, a low physical level
##  will be interpreted as logical value 1.
##
##  Note: If pin is configured as Active High, the default, gpio_pin_get()
##        function is equivalent to gpio_pin_get_raw().
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pin Pin number.
##
##  @retval 1 If pin logical value is 1 / active.
##  @retval 0 If pin logical value is 0 / inactive.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_pin_get*(port: ptr device; pin: gpio_pin_t): cint {.inline,
    importc: "gpio_pin_get".} =
  let cfg: ptr gpio_driver_config
  var value: gpio_port_value_t
  var ret: cint
  cast[nil](cfg)
  __ASSERT((cfg.port_pin_mask and cast[gpio_port_pins_t](BIT(pin))) != 0'u,
           "Unsupported pin")
  ret = gpio_port_get(port, addr(value))
  if ret == 0:
    ret = if (value and cast[gpio_port_pins_t](BIT(pin))) != 0: 1 else: 0
  return ret

## *
##  @brief Set physical level of an output pin.
##
##  Writing value 0 to the pin will set it to a low physical level. Writing any
##  value other than 0 will set it to a high physical level. This function
##  ignores GPIO_ACTIVE_LOW flag.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pin Pin number.
##  @param value Value assigned to the pin.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_pin_set_raw*(port: ptr device; pin: gpio_pin_t; value: cint): cint {.inline,
    importc: "gpio_pin_set_raw".} =
  let cfg: ptr gpio_driver_config
  var ret: cint
  cast[nil](cfg)
  __ASSERT((cfg.port_pin_mask and cast[gpio_port_pins_t](BIT(pin))) != 0'u,
           "Unsupported pin")
  if value != 0:
    ret = gpio_port_set_bits_raw(port, cast[gpio_port_pins_t](BIT(pin)))
  else:
    ret = gpio_port_clear_bits_raw(port, cast[gpio_port_pins_t](BIT(pin)))
  return ret

## *
##  @brief Set logical level of an output pin.
##
##  Set logical level of an output pin taking into account GPIO_ACTIVE_LOW flag.
##  Value 0 sets the pin in logical 0 / inactive state. Any value other than 0
##  sets the pin in logical 1 / active state. If pin is configured as Active
##  High, the default, setting it in inactive state will force the pin to a low
##  physical level. If pin is configured as Active Low, setting it in inactive
##  state will force the pin to a high physical level.
##
##  Note: If pin is configured as Active High, gpio_pin_set() function is
##        equivalent to gpio_pin_set_raw().
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pin Pin number.
##  @param value Value assigned to the pin.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_pin_set*(port: ptr device; pin: gpio_pin_t; value: cint): cint {.inline,
    importc: "gpio_pin_set".} =
  let cfg: ptr gpio_driver_config
  let data: ptr gpio_driver_data
  cast[nil](cfg)
  __ASSERT((cfg.port_pin_mask and cast[gpio_port_pins_t](BIT(pin))) != 0'u,
           "Unsupported pin")
  if data.invert and cast[gpio_port_pins_t](BIT(pin)):
    value = if (value != 0): 0 else: 1
  return gpio_pin_set_raw(port, pin, value)

## *
##  @brief Toggle pin level.
##
##  @param port Pointer to the device structure for the driver instance.
##  @param pin Pin number.
##
##  @retval 0 If successful.
##  @retval -EIO I/O error when accessing an external GPIO chip.
##  @retval -EWOULDBLOCK if operation would block.
##

proc gpio_pin_toggle*(port: ptr device; pin: gpio_pin_t): cint {.inline,
    importc: "gpio_pin_toggle".} =
  let cfg: ptr gpio_driver_config
  cast[nil](cfg)
  __ASSERT((cfg.port_pin_mask and cast[gpio_port_pins_t](BIT(pin))) != 0'u,
           "Unsupported pin")
  return gpio_port_toggle_bits(port, cast[gpio_port_pins_t](BIT(pin)))

## *
##  @brief Helper to initialize a struct gpio_callback properly
##  @param callback A valid Application's callback structure pointer.
##  @param handler A valid handler function pointer.
##  @param pin_mask A bit mask of relevant pins for the handler
##

proc gpio_init_callback*(callback: ptr gpio_callback;
                        handler: gpio_callback_handler_t;
                        pin_mask: gpio_port_pins_t) {.inline,
    importc: "gpio_init_callback".} =
  __ASSERT(callback, "Callback pointer should not be NULL")
  __ASSERT(handler, "Callback handler pointer should not be NULL")
  callback.handler = handler
  callback.pin_mask = pin_mask

## *
##  @brief Add an application callback.
##  @param port Pointer to the device structure for the driver instance.
##  @param callback A valid Application's callback structure pointer.
##  @return 0 if successful, negative errno code on failure.
##
##  @note Callbacks may be added to the device from within a callback
##  handler invocation, but whether they are invoked for the current
##  GPIO event is not specified.
##
##  Note: enables to add as many callback as needed on the same port.
##

proc gpio_add_callback*(port: ptr device; callback: ptr gpio_callback): cint {.inline,
    importc: "gpio_add_callback".} =
  let api: ptr gpio_driver_api
  if api.manage_callback == nil:
    return -ENOTSUP
  return api.manage_callback(port, callback, true)

## *
##  @brief Remove an application callback.
##  @param port Pointer to the device structure for the driver instance.
##  @param callback A valid application's callback structure pointer.
##  @return 0 if successful, negative errno code on failure.
##
##  @warning It is explicitly permitted, within a callback handler, to
##  remove the registration for the callback that is running, i.e. @p
##  callback.  Attempts to remove other registrations on the same
##  device may result in undefined behavior, including failure to
##  invoke callbacks that remain registered and unintended invocation
##  of removed callbacks.
##
##  Note: enables to remove as many callbacks as added through
##        gpio_add_callback().
##

proc gpio_remove_callback*(port: ptr device; callback: ptr gpio_callback): cint {.
    inline, importc: "gpio_remove_callback".} =
  let api: ptr gpio_driver_api
  if api.manage_callback == nil:
    return -ENOTSUP
  return api.manage_callback(port, callback, false)

## *
##  @brief Function to get pending interrupts
##
##  The purpose of this function is to return the interrupt
##  status register for the device.
##  This is especially useful when waking up from
##  low power states to check the wake up source.
##
##  @param dev Pointer to the device structure for the driver instance.
##
##  @retval status != 0 if at least one gpio interrupt is pending.
##  @retval 0 if no gpio interrupt is pending.
##

proc gpio_get_pending_int*(dev: ptr device): cint {.syscall,
    importc: "gpio_get_pending_int", header: "gpio.h".}
proc z_impl_gpio_get_pending_int*(dev: ptr device): cint {.inline,
    importc: "z_impl_gpio_get_pending_int".} =
  let api: ptr gpio_driver_api
  if api.get_pending_int == nil:
    return -ENOTSUP
  return api.get_pending_int(dev)

## *
##  @}
##
