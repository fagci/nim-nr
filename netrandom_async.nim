import std/asyncnet
import asyncdispatch

import ./gen

type
  TargetResult = ref object
    ip: string
    open: bool

proc check(ip: string, port: int): Future[TargetResult] {.async.} =
  let s = newAsyncSocket()
  let future = s.connect(ip, Port(port))
  yield future

  result = TargetResult(ip: ip, open: not future.failed)
  s.close()
  
  if result.open: echo ip

var futures = newSeq[Future[TargetResult]]()

# TODO: infinite, deal with max open files
for _ in 1..1024:
  futures.add(check(random_ip(), 80))

discard waitFor all(futures).withTimeout(700)
