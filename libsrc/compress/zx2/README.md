# ZX2

**ZX2** is a minimalist version of [ZX1](https://github.com/einar-saukas/ZX1). 
It's intended to help compressing programs and data blocks so small that saving 
a few bytes in the decompressor itself can make a difference (for instance to 
create 1Kb demos).


## Usage

To compress a file, use the command-line compressor as follows:

```
zx2 [options] Font.fzx
```

This will generate a compressed file called "Font.fzx.zx2".

Afterwards you must choose a decompressor routine in assembly Z80 that 
corresponds to the compression options you have used. The decompressor size 
varies from 48 to 56 bytes depending on these options:

* Option "-z": Ignore default offset (reduces 1 byte). Starting the decompressor
with an initial default offset usually saves 1 byte per compressed file,
sometimes even more. But for certain files, this initialization may not help at
all, in these cases it's better to reduce 1 byte in the decompressor itself.

* Option "-x": Skip length increment (reduces 4 bytes). Decrementing new offset
lengths before storing them (thus requiring an increment afterwards) usually
saves a bit every 2 blocks on average. However in a few rare cases, the 
compression of certain files may not benefit from this, in this case you can 
save a few bytes in the decompressor size instead.

* Option "-y": Limit block length (reduces 2 bytes). Compressing very small
files usually don't need support for large block lengths, so you may be able
to use a smaller decompressor in these cases.

* Option "-b": Compress backwards (reduces 1 byte). Certain files compress
slightly better with forward compression, others with backwards. Just don't 
forget that backwards compression requires a different decompressor version.


Afterwards compile the chosen decompressor routine according to your chosen
options, and load the compressed file somewhere in memory. To decompress data,
just call the routine specifying the source address of compressed data in HL 
and the target address in DE.

For instance, if you compile the decompressor routine to address 25000, load
"Font.fzx.zx2" at address 25100, and you want to decompress it to address 26000,
then execute the following code:

```
    LD    HL, 25100  ; source address (put "Font.fzx.zx2" there)
    LD    DE, 26000  ; target address
    CALL  25000      ; decompress routine compiled at this address
```

It's also possible to decompress data into a memory area that partially overlaps
the compressed data itself (only if you won't need to decompress it again later,
obviously). In this case, the last address of compressed data must be at least
"delta" bytes higher than the last address of decompressed data. The exact value
of "delta" for each case is reported by **ZX2** during compression. See image
below:

```
                       |------------------|    compressed data
    |---------------------------------|       decompressed data
  start >>                            <--->
                                      delta
```

For convenience, there's also a command-line decompressor that works as follows:

```
dzx2 Font.fzx.zx2
```


## File Format

The **ZX2** compressed format is very simple. There are only 3 types of blocks:

* Literal (copy next N bytes from compressed file)
```
    0  Elias(length)  byte[1]  byte[2]  ...  byte[N]
```

* Copy from last offset (repeat N bytes from last offset)
```
    0  Elias(length)
```

* Copy from new offset (repeat N bytes from new offset)
```
    1  offset  Elias(length-K)
```

**ZX2** needs only 1 bit to distinguish between these blocks, because literal
blocks cannot be consecutive, and reusing last offset can only happen after a
literal block. The first block is always a literal, so the first bit is omitted.

All lengths are stored using interlaced
[Elias Gamma Coding](https://en.wikipedia.org/wiki/Elias_gamma_coding). The
offset is stored using 1 byte only. A special offset value indicates EOF.


## Advanced Features

The **ZX2** compressor contains a few extra "hidden" features, that are slightly
harder to use properly, and not supported by the **ZX2** decompressor in C. Please
read carefully these instructions before attempting to use any of them!


#### _COMPRESSING BACKWARDS_

When using **ZX2** for "in-place" decompression (decompressing data to overlap the
same memory area storing the compressed data), you must always leave a small
margin of "delta" bytes of compressed data at the end. However it won't work to
decompress some large data that will occupy all the upper memory until the last
memory address, since there won't be even a couple bytes left at the end.

A possible workaround is to compress and decompress data backwards, starting at
the last memory address. Therefore you will only need to leave a small margin of
"delta" bytes of compressed data at the beginning instead. Technically, it will
require that lowest address of compressed data should be at least "delta" bytes
lower than lowest address of decompressed data. See image below:

     compressed data    |------------------|
    decompressed data       |---------------------------------|
                        <--->                            << start
                        delta

To compress a file backwards, use the command-line compressor as follows:

```
zx2 -b Font.fzx
```

To decompress it later, you must call one of the supplied "backwards" variants
of the Assembly decompressor, specifying last source address of compressed data
in HL and last target address in DE.

For instance, if you compile a "backwards" Assembly decompressor routine to
address 64000, load backwards compressed file "Font.fzx.zx2" (with size 143
bytes) to address 51200, and want to decompress it to fill the entire ZX Spectrum
printer buffer at address 23296 (with 256 bytes), then execute the following code:

```
    LD    HL, 51200+143-1   ; source (last address of "Font.fzx.zx2")
    LD    DE, 23296+256-1   ; target (last address of printer buffer)
    CALL  64000             ; backwards decompress routine
```

Notice that compressing backwards may sometimes produce slightly smaller
compressed files in certain cases, slightly larger compressed files in others.


#### _COMPRESSING WITH PREFIX_

The LZ77/LZSS compression is achieved by "abbreviating repetitions", such that
certain sequences of bytes are replaced with much shorter references to previous
occurrences of these same sequences. For this reason, it's harder to get very
good compression ratio on very short files, or in the initial parts of larger
files, due to lack of choices for previous sequences that could be referenced.

A possible improvement is to compress data while also taking into account what
else will be already stored in memory during decompression later. Thus the
compressed data may even contain shorter references to repetitions stored in
some previous "prefix" memory area, instead of just repetitions within the
decompressed area itself.

An input file may contain both some prefix data to be referenced only, and the
actual data to be compressed. An optional parameter can specify how many bytes
must be skipped before compression. See below:

```
                                        compressed data
                                     |-------------------|
         prefix             decompressed data
    |--------------|---------------------------------|
                 start >>
    <-------------->                                 <--->
          skip                                       delta
```

As usual, if you want to decompress data into a memory area that partially
overlaps the compressed data itself, the last address of compressed data must be
at least "delta" bytes higher than the last address of decompressed data.

For instance, if you want the first 120 bytes of a certain file to be skipped
(not compressed but possibly referenced), then use the command-line compressor
as follows:

```
zx1 +120 Font.fzx
```

In practice, suppose an action game uses a few generic sprites that are common
for all levels (such as player graphics), and other sprites are specific for
each level (such as enemies). All generic sprites must stay always accessible at
a certain memory area, but any level specific data can be only decompressed as
needed, to the memory area immediately following it. In this case, the generic
sprites area could be used as prefix when compressing and decompressing each
level, in an attempt to improve compression. For instance, suppose generic
graphics are loaded from file "generic.gfx" to address 56000, occupying 180
bytes, and level specific graphics will be decompressed immediately afterwards,
to address 56180. To compress each level using "generic.gfx" as a 180 bytes
prefix, use the command-line compressor as follows:

```
copy /b generic.gfx+level_1.gfx prefixed_level_1.gfx
zx1 +180 prefixed_level_1.gfx

copy /b generic.gfx+level_2.gfx prefixed_level_2.gfx
zx1 +180 prefixed_level_2.gfx

copy /b generic.gfx+level_3.gfx prefixed_level_3.gfx
zx1 +180 prefixed_level_3.gfx
```

To decompress it later, you simply need to use one of the normal variants of the
Assembly decompressor, as usual. In this case, if you loaded compressed file
"prefixed_level_1.gfx.zx1" to address 48000 for instance, decompressing it will
require the following code:

```
    LD    HL, 48000  ; source address (put "prefixed_level_1.gfx.zx1" there)
    LD    DE, 56180  ; target address (level specific memory area in this case)
    CALL  65000      ; decompress routine compiled at this address
```

However decompression will only work properly if exactly the same prefix data is
present in the memory area immediately preceding the decompression address.
Therefore you must be extremely careful to ensure the prefix area does not store
variables, self-modifying code, or anything else that may change prefix content
between compression and decompression. Also don't forget to recompress your
files whenever you modify a prefix!

In certain cases, compressing with a prefix may considerably help compression.
In others, it may not even make any difference. It mostly depends on how much
similarity exists between data to be compressed and its provided prefix.


#### _COMPRESSING BACKWARDS WITH SUFFIX_

Both features above can be used together. A file can be compressed backwards,
with an optional parameter to specify how many bytes should be skipped (not
compressed but possibly referenced) from the end of the input file instead. See
below:

```
       compressed data
    |-------------------|
                 decompressed data             suffix
        |---------------------------------|--------------|
                                     << start
    <--->                                 <-------------->
    delta                                       skip
```

As usual, if you want to decompress data into a memory area that partially
overlaps the compressed data itself, lowest address of compressed data must be
at least "delta" bytes lower than lowest address of decompressed data.

For instance, if you want to skip the last 112 bytes of a certain input file and
compress everything else (possibly referencing this "suffix" of 112 bytes), then
use the command-line compressor as follows:

```
zx2 -b +112 Font.fzx
```

In previous example, suppose the action game now stores level-specific sprites
in the memory area from address 33000 to 33127 (128 bytes), just before generic
sprites that are stored from address 33128 to 33357 (230 bytes). In this case,
these generic sprites could be used as suffix when compressing and decompressing
level-specific data as needed, in an attempt to improve compression. To compress
each level using "generic.gfx" as a 230 bytes suffix, use the command-line
compressor as follows:

```
copy /b "level_1.gfx+generic.gfx level_1_suffixed.gfx
zx2 -b +230 level_1_suffixed.gfx

copy /b "level_2.gfx+generic.gfx level_2_suffixed.gfx
zx2 -b +230 level_2_suffixed.gfx

copy /b "level_3.gfx+generic.gfx level_3_suffixed.gfx
zx2 -b +230 level_3_suffixed.gfx
```

To decompress it later, use the backwards variant of the Assembly decompressor.
In this case, if you compile a "backwards" decompressor routine to address
64000, and load compressed file "level_1_suffixed.gfx.zx1" (with 73 bytes) to
address 39000 for instance, decompressing it will require the following code:

```
    LD    HL, 39000+73-1   ; source (last address of "level_1_suffixed.gfx.zx1")
    LD    DE, 33000+128-1  ; target (last address of level-specific data)
    CALL  64000            ; backwards decompress routine
```

Analogously, decompression will only work properly if exactly the same suffix
data is present in the memory area immediately following the decompression area.
Therefore you must be extremely careful to ensure the suffix area does not store
variables, self-modifying code, or anything else that may change suffix content
between compression and decompression. Also don't forget to recompress your
files whenever you modify a suffix!

Also if you are using "in-place" decompression, you must leave a small margin of
"delta" bytes of compressed data just before the decompression area.


## License

The **ZX2** data compression format and algorithm was designed and implemented
by **Einar Saukas**.

The optimal C compressor is available under the "BSD-3" license. In practice,
this is relevant only if you want to modify its source code and/or incorporate
the compressor within your own products. Otherwise, if you just execute it to
compress files, you can simply ignore these conditions.

The decompressors can be used freely within your own programs (either for the
ZX Spectrum or any other platform), even for commercial releases. The only
condition is that you must indicate somehow in your documentation that you have
used **ZX2**.


## Links

Related projects (by the same author):

* [ZX0](https://github.com/einar-saukas/ZX0) - The original compressor on
which **ZX1** and **ZX2** are based.

* [ZX1](https://github.com/einar-saukas/ZX1) - A simpler but faster version
of **ZX0**, that sacrifices about 1.5% compression to run about 15% faster.

* [ZX2](https://github.com/einar-saukas/ZX2) - The official **ZX2** repository.
