#from tables import initCountTable, inc, sort, pairs
from algorithm import SortOrder, sort
from hashes import Hash

# Tables hacks
include tables

proc rawGet[A](t: CountTable[A], key: A, hash: Hash): int =
  if t.data.len == 0:
    return -1
  var h: Hash = hash and high(t.data) # start with real hash value
  while t.data[h].val != 0:
    if t.data[h].key == key: return h
    h = nextTry(h, high(t.data))
  result = -1 - h # < 0 => MISSING; insert idx = -1 - result

proc inc*[A](t: var CountTable[A], key: A, hash: Hash) =
  var index = rawGet(t, key, hash)
  if index >= 0:
    inc(t.data[index].val)
    if t.data[index].val == 0:
      delImplIdx(t, index, cntMakeEmpty, cntCellEmpty, cntCellHash)
  else:
    if t.dataLen == 0: initImpl(t, defaultInitialSize)
    if mustRehash(t): enlarge(t)
    ctRawInsert(t, t.data, key, 1)
    inc(t.counter)
# end of table hacks

const 
  FNVp = 0x100000001b3'u64
  FNVm = 0x84222325'u64

proc hash*(x: string): Hash {.inline.} =
  # FNV-1a 64
  var h = FNVp 
  for c in x:
    h = h xor cast[uint64](c)
    h *= FNVm
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
    hash64 = FNVp

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
        if buf[wend].isWhitespace(): # leaving word
          inside = false
          wordBuf.copy(buf{wstart..<wend})
          words.inc(wordBuf, hash = cast[Hash](hash64))
          wstart = wend + 1
          continue
        else: # traversing a word
          if buf[wend] in {'A'..'Z'}:
            buf[wend] = chr(ord(buf[wend]) + (ord('a') - ord('A')))
          hash64 = (hash64 xor cast[uint64](buf[wend])) * FNVm # hash as we go
          wend.inc()
      else:
        if buf[wstart].isWhitespace(): # skipping whitespace
          wstart.inc()
          continue
        else: # entering a word
          inside = true
          hash64 = FNVp # init hash for the new word
          wend = wstart
      
    if offset > 0:
      # if offset is positive, overflow is impossible
      moveMem(buf[0].addr(), buf[lastChar + 1].addr(), offset)

  words.sort(SortOrder.Descending)
  for (word, count) in words.pairs():
    echo(word, ' ', count)

when isMainModule:
  main()
