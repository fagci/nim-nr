import std/asyncdispatch
import std/asyncnet
import std/strformat
import std/strutils

import ./gen

const PATH = "/wp-content/uploads/"

const CONN_TIMEOUT = 300
const SEND_TIMEOUT = 700
const RECV_TIMEOUT = 2000
const BODY_LEN = 1024
const WORKERS = 2048

const PORT = 80.Port
const MSG_T = "GET " & PATH & " HTTP/1.1\r\nHost: {ip}\r\n\r\n"

proc check(ip: string): Future[void] {.async.} =
  let s = newAsyncSocket()

  var fut = s.connect(ip, PORT)

  yield fut.withTimeout(CONN_TIMEOUT)

  if not fut.failed:
    fut = s.send(MSG_T.fmt)
    yield fut.withTimeout(SEND_TIMEOUT)

    if not fut.failed:
      let body = s.recv(BODY_LEN)
      await body.withTimeout(RECV_TIMEOUT):

  if "Index of" in body.read():
    echo &"http://{ip}{PATH}"

  s.close()

proc worker(): Future[void] {.async.} =
  while true:
    yield check random_ip()

var futures = newSeq[Future[void]]()

for _ in 1..WORKERS:
  futures.add worker()

waitFor all(futures)
