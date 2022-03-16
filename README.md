Beating Go in counting words with Nim.

See the full original article for context and background: [https://benhoyt.com/writings/count-words/](https://benhoyt.com/writings/count-words/)

Original repository [benhoyt/countwords](https://github.com/benhoyt/countwords) is closed for further contributions.

## Details and discussion
See the nim-lang forum thread: https://forum.nim-lang.org/t/7926

⚠️ There's a [separate branch with a faster hashing hack](https://github.com/ZoomRmc/countwords_nim/tree/hashrearhatch) applied. See details in the commit messages.

## Status:
🍾*Mission accomplished!* Currently faster than Go by a factor dependent on input size:
```
x1: 19%
x10: 3.7%
x50: 1.7%
```

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
