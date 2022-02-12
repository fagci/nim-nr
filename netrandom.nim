import asyncdispatch
import asyncnet
import strformat
import strutils

import ./gen

const
  PATH = "/wp-content/uploads/"

  CONN_TIMEOUT = 300
  SEND_TIMEOUT = 700
  RECV_TIMEOUT = 2000
  BODY_LEN = 1024
  WORKERS = 2048

  PORT = 80.Port
  OUTPUT_T = "http://{{ip}}{PATH}".fmt

const MSG_T = [
  "GET {PATH} HTTP/1.1",
  "Host: {{ip}}",
  "User-Agent: Mozilla/5.0",
].join("\r\n").fmt & "\r\n\r\n"


proc check(ip: string): Future[void] {.async.} =
  let s = newAsyncSocket()

  var fut = s.connect(ip, PORT)
  yield fut.withTimeout(CONN_TIMEOUT)

  if not fut.failed:
    fut = s.send(MSG_T.fmt)
    yield fut.withTimeout(SEND_TIMEOUT)

    if not fut.failed:
      let body = s.recv(BODY_LEN)

      if await body.withTimeout(RECV_TIMEOUT):
        if "Index of" in body.read():
          echo OUTPUT_T.fmt

  s.close()


proc worker(): Future[void] {.async.} =
  while true:
    yield check random_ip()


var futures = newSeq[Future[void]]()

for _ in 1..WORKERS:
  futures.add worker()

waitFor all(futures)
