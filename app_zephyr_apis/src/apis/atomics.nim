import mcu_utils/logging

import std/atomics

proc runAtomics*() =
  logInfo("atomics start")
  # Atomic
  var loc: Atomic[int]
  loc.store(4)
  assert loc.load == 4
  loc.store(2)
  assert loc.load(moRelaxed) == 2
  loc.store(9)
  assert loc.load(moAcquire) == 9
  loc.store(0, moRelease)
  assert loc.load == 0

  assert loc.exchange(7) == 0
  assert loc.load == 7

  var expected = 7
  assert loc.compareExchange(expected, 5, moRelaxed, moRelaxed)
  assert expected == 7
  assert loc.load == 5

  assert not loc.compareExchange(expected, 12, moRelaxed, moRelaxed)
  assert expected == 5
  assert loc.load == 5

  assert loc.fetchAdd(1) == 5
  assert loc.fetchAdd(2) == 6
  assert loc.fetchSub(3) == 8

  loc.atomicInc(1)
  assert loc.load == 6

  # AtomicFlag
  var flag: AtomicFlag

  assert not flag.testAndSet
  assert flag.testAndSet
  flag.clear(moRelaxed)
  assert not flag.testAndSet

  logInfo("atomics done")
