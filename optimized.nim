from tables import initCountTable, inc, sort, pairs
from algorithm import SortOrder
from hashes import Hash, `!$`, `!&`

proc hash*(x: string): Hash {.inline.} =
  for c in x:
    result = result !& cast[Hash](ord(c))
  result = !$result

proc main() =
  const bufLen = 64 * 1024
  var
    words = initCountTable[string]()
    buf = newString(bufLen)
    offset = 0

  while true:
    # Fill buffer starting from offset (remainder from prev. iteration)
    let bytesRead = stdin.readBuffer(addr(buf[offset]), bufLen - offset)
    if bytesRead == 0:
      break
    
    let totalBytes = offset + bytesRead
    # Scan the buffer for the last word bound
    # to process only up to the potential partial at the end 
    var lastChar = totalBytes - 1 # an index, never < 0
    while lastChar >= 0:
      if buf[lastChar] <= ' ':
        break
      lastChar.dec()

    # Whole buffer is a word/whitespace edgecase. #DELETEME or not?
    if lastChar < 0:
      lastChar = totalBytes - 1
    
    # Split buffer into words and process
    var wstart = 0
    while wstart < lastChar:
      # Skip leading whitespace
      while buf[wstart] <= ' ':
        wstart.inc()
      var wend = wstart
      # Iterate and lowercase chars until word ends
      while buf[wend] > ' ':
        if buf[wend] in {'A'..'Z'}:
          buf[wend] = chr(ord(buf[wend]) + (ord('a') - ord('A')))
        wend.inc()
      if wend > lastChar:
        break
      # Increment counter
      words.inc(buf[wstart..<wend])
      wstart = wend + 1
    
    # Copy unaccounted partial to the start of a buffer
    if wstart < totalBytes:
      offset = totalBytes - wstart
      moveMem(buf[0].addr(), buf[wstart].addr(), offset)
    else:
      offset = 0

  words.sort(SortOrder.Descending)
  for (word, count) in words.pairs():
    echo(word, ' ', count)

when isMainModule:
  main()
