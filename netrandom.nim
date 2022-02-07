import std/net
import threadpool

import ./gen

proc check(ip: string, port: int): bool=
  let s = newSocket()
  try:
    s.connect(ip, Port(port), 700)
    result = true
  except:
    result = false
  finally:
    s.close()

proc check_loop() =
  while true:
    var ip = random_ip()
    if check(ip, 80):
      echo ip

for i in 1..128:
  spawn check_loop()

