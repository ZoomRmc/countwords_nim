from tables import initCountTable, inc, sort, pairs, len
from algorithm import SortOrder, sortedByIt, sort
from hashes import Hash, `!$`, `!&`

proc hash*(x: string): Hash {.inline.} =
  # FNV-1a 64
  var h = 0x100000001b3'u64
  for c in x:
    h = h xor cast[uint64](c)
    h *= 0x84222325'u64
  return cast[Hash](h)

# Workaround for superfluous copying on table insertion by @alaviss
template `^^`(s, i: untyped): untyped =
  (when i is BackwardsIndex: s.len - int(i) else: int(i))

template `{}`[T, U](s: string, slice: HSlice[T, U]): untyped =
  s.toOpenArray(s ^^ slice.a, s ^^ slice.b)

func copy(s: var string, data: openArray[char]) {.inline.} =
  s.setLen(data.len())
  for idx, c in data:
    s[idx] = c
# end of workaround

template isWhitespace(c: char): untyped = (c <= ' ')

template notWhitespace(c: char): untyped = (c > ' ')

proc main() =
  const bufLen = 64 * 1024
  var
    words = initCountTable[string]()
    buf = newString(bufLen)
    offset = 0
    wordBuf: string

  while true:
    # Fill buffer starting from offset (remainder from prev. iteration)
    let totalBytes = offset + stdin.readChars(buf{offset .. ^1})
    if totalBytes == 0:
      break
    # Scan the buffer for the last word bound
    # to process only up to the potential partial at the end 
    var lastChar = totalBytes - 1 # an index, never < 0
    while lastChar > 0 and buf[lastChar].notWhitespace():
      lastChar.dec()
    offset = totalBytes - lastChar - 1

    # Split buffer into words and process
    var 
      inside = false
      wstart, wend = 0
    while wstart <= lastChar:
      if inside:
        if buf[wend].isWhitespace: # leaving word
          inside = false
          wordBuf.copy(buf{wstart..<wend})
          words.inc(wordBuf)
          wstart = wend + 1
          continue
        else: # traversing a word
          if buf[wend] in {'A'..'Z'}:
            buf[wend] = chr(ord(buf[wend]) + (ord('a') - ord('A')))
          wend.inc()
      else:
        if buf[wstart].isWhitespace: # skipping whitespace
          wstart.inc()
          continue
        else: # entering a word
          inside = true
          wend = wstart
      
    if offset > 0:
      # if offset is positive, overflow is impossible
      moveMem(buf[0].addr(), buf[lastChar + 1].addr(), offset)

  words.sort(SortOrder.Descending)
  for (word, count) in words.pairs():
    echo(word, ' ', count)

when isMainModule:
  main()
