proc sF05CheckCrc*(data: ptr U8t; nbrOfBytes: U8t; checksum: U8t): cint =
  ## ==============================================================================
  var bit: U8t
  ##  bit mask
  var crc: U8t = 0
  ##  calculated checksum
  var byteCtr: U8t
  ##  byte counter
  ##  calculates 8-Bit checksum with given polynomial
  byteCtr = 0
  while byteCtr < nbrOfBytes:
    crc = crc xor (data[byteCtr])
    bit = 8
    while bit > 0:
      if crc and 0x80:
        crc = (crc shl 1) xor polynomial
      else:
        crc = (crc shl 1)
      dec(bit)
    inc(byteCtr)
  ##  verify checksum
  if crc != checksum:
    return checksum_Error
  else:
    return no_Error
  