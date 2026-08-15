---
name: tool-zx0
description: >
  z88dk-zx0 / dzx0 ZX0 compression tools. Use when packing data/code with ZX0.
---

# Tool — zx0

| | |
|--|--|
| Binary | `z88dk-zx0` |
| Help | src/zx0/README.md |
| Wiki (local draft) | `wiki/tools/Tool---zx0.md` |



## Condensed reference (from wiki / tree)

# Tool — z88dk-zx0

Host-side **ZX0** compressor (optimal LZ77/LZSS-style format for small machines). Companion **decompressors** live in the z80 libraries (classic and newlib since v2.2).

## Host usage (live binary)

```text
z88dk-zx0 [-f] [-b] [-q] input [output.zx0]
  -f      Force overwrite of output file
  -b      Compress backwards
  -q      Quick non-optimal compression
```

Upstream-style default name is `input.zx0` when output is omitted (see `src/zx0/README.md`). The z88dk binary uses the flags above.

Decompress on the host with **`z88dk-dzx0`**.

## Target library

Changelog v2.2: ZX0/1/2 decompression functions in classic; ZX0 in newlib. Appmake can use zx0 for compressed ROM data sections.

## Related

- [Tool — zx7](Tool---zx7)
- [Decompression](Decompression)
- [compress_zx7](compress_zx7)
- `src/zx0/README.md`

## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
