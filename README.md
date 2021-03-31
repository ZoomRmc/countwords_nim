Beating Go in counting words with Nim.
See the full original article for context and background: [https://benhoyt.com/writings/count-words/](https://benhoyt.com/writings/count-words/)
Original repository [benhoyt/countwords](https://github.com/benhoyt/countwords) is closed for further contributions.

## Status:
Currently about 25-30% slower than Go.
Probably no point running with `--gc:` other than `arc` or `orc`. Last comparison of various included garbage collectors:
`arc: 7.1s, refc: 9.2s, markAndSweep: 10.7s, regions: 13.1s, boehm: 21.2s`

## Timing the current implementation

Required:
- Bash
- Go
- Nim
- Writable /tmp/

```bash
./test.sh
```

To just build the Nim version:
```bash
nim c --gc:arc -d:danger --passC:"-flto" --passL:"-flto" -o:optimized_nim optimized.nim
```

## Credits
The included Go version: [ben Hoyt](https://github.com/benhoyt) and [Miguel Angel](https://github.com/ntrrg)

## License
MIT
