import std/asyncnet
import asyncdispatch

import ./gen

type
  TargetResult = ref object
    ip: string
    open: bool

let http_port = Port(80)

proc check(ip: string): Future[TargetResult] {.async.} =
  let s = newAsyncSocket()
  let future = s.connect(ip, http_port)
  yield future

  result = TargetResult(ip: ip, open: not future.failed)
  s.close()
  if result.open: echo ip
  

var futures = newSeq[Future[void]]()

proc worker(): Future[void] {.async.} =
  while true:
    let res = await check(random_ip()).withTimeout(700)

for _ in 1..1024:
  futures.add(worker())

runForever()
