import std/posix
import std/random

randomize()

const RAND_RANGE = 0'u32..0xD0000000'u32

proc random_ip*(): string =
  var intip: uint32

  while true:
    intip = rand(RAND_RANGE) + 0xFFFFFF
    if not (
      (intip >= 0x0A000000'u32 and intip <= 0x0AFFFFFF'u32) or
      (intip >= 0x64400000'u32 and intip <= 0x647FFFFF'u32) or
      (intip >= 0x7F000000'u32 and intip <= 0x7FFFFFFF'u32) or
      (intip >= 0xA9FE0000'u32 and intip <= 0xA9FEFFFF'u32) or
      (intip >= 0xAC100000'u32 and intip <= 0xAC1FFFFF'u32) or
      (intip >= 0xC0000000'u32 and intip <= 0xC0000007'u32) or
      (intip >= 0xC00000AA'u32 and intip <= 0xC00000AB'u32) or
      (intip >= 0xC0000200'u32 and intip <= 0xC00002FF'u32) or
      (intip >= 0xC0A80000'u32 and intip <= 0xC0A8FFFF'u32) or
      (intip >= 0xC6120000'u32 and intip <= 0xC613FFFF'u32) or
      (intip >= 0xC6336400'u32 and intip <= 0xC63364FF'u32) or
      (intip >= 0xCB007100'u32 and intip <= 0xCB0071FF'u32) or
      (intip >= 0xF0000000'u32 and intip <= 0xFFFFFFFF'u32)
    ):
      return $inet_ntoa(InAddr(s_addr: intip))
