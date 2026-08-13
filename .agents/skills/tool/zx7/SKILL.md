---
name: tool-zx7
description: >
  z88dk-zx7 / dzx7 ZX7 compression tools. Use when packing with ZX7.
---

# Tool — zx7

| | |
|--|--|
| Binary | `z88dk-zx7` |
| Help | src/zx7 sources |
| Wiki (local draft) | `wiki/tools/Tool---zx7.md` |



## Condensed reference (from wiki / tree)

# Tool — z88dk-zx7

Host-side **ZX7** compressor. Companion decompressors live in the z80 libraries.

```text
Usage: z88dk-zx7 [-f] [-b] input [output.zx7]
  -f      Force overwrite of output file
  -b      Compress backwards
ZX7: Optimal LZ77/LZSS compression by Einar Saukas
```

Related: `z88dk-dzx7`, [compress_zx7](compress_zx7), [Decompression](Decompression).

## Related

- Driver front end: `tool/zcc`
- Measurement: `methodology/measure`, `tool/ticks`
