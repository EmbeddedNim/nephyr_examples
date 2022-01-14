proc loapic_device_ctrl*(port: ptr device; ctrl_command: uint32; context: ptr uint32;
                        cb: pm_device_cb; arg: pointer): cint {.
    importc: "loapic_device_ctrl", header: "other.h".}