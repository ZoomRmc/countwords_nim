Beating Go in counting words with Nim.

See the full original article for context and background: [https://benhoyt.com/writings/count-words/](https://benhoyt.com/writings/count-words/)

Original repository [benhoyt/countwords](https://github.com/benhoyt/countwords) is closed for further contributions.

## Status:
Mission accomplished: Currently about 1-3% faster than Go.

Code tries to stay close to the same basic algorithm used by most optimized versions from the original repo.

Probably no point running with `--gc:` other than `arc` or `orc`. Last comparison of various included garbage collectors:
```
arc/orc: 5.6s
boehm: 5.7s
markAndSweep: 5.9s
regions: 6.1s
refc: 6.4s
```

## Timing the current implementation
To get statistically significant result measure multiple times or use specialized tools like [hyperfine](https://github.com/sharkdp/hyperfine)

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
The included Go version: [Ben Hoyt](https://github.com/benhoyt) and [Miguel Angel](https://github.com/ntrrg)

## License
MIT
