# ZX0

**ZX0** is an optimal data compressor for a custom
[LZ77/LZSS](https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Storer%E2%80%93Szymanski)
based compression format, that provides a tradeoff between high compression
ratio, and extremely simple fast decompression. Therefore it's especially
appropriate for low-end platforms, including 8-bit computers like the ZX
Spectrum.

A comparison with other compressors (courtesy of **introspec/spke**) can be seen
[here](https://www.cpcwiki.eu/forum/programming/new-cruncher-zx0/msg197727/#msg197727).


_**WARNING**: The ZX0 file format was changed in version 2. This new format allows
decompressors to be slightly smaller and run slightly faster. If you need to compress
a file to the old "classic" file format from version 1, then execute ZX0 compressor
using parameter "-c"._


## Usage

To compress a file, use the command-line compressor as follows:

```
zx0 Cobra.scr
```

This will generate a compressed file called "Cobra.scr.zx0".

Afterwards you can choose a decompressor routine in assembly Z80, according to
your requirements for speed and size:

* "Standard" routine: 68 bytes only
* "Turbo" routine: 126 bytes, about 21% faster
* "Fast" routine: 187 bytes, about 25% faster
* "Mega" routine: 673 bytes, about 28% faster

Finally compile the chosen decompressor routine and load the compressed file
somewhere in memory. To decompress data, just call the routine specifying the
source address of compressed data in HL and the target address in DE.

For instance, if you compile the decompressor routine to address 65000, load
"Cobra.scr.zx0" at address 51200, and you want to decompress it directly to the
screen, then execute the following code:

```
    LD    HL, 51200  ; source address (put "Cobra.scr.zx0" there)
    LD    DE, 16384  ; target address (screen memory in this case)
    CALL  65000      ; decompress routine compiled at this address
```

It's also possible to decompress data into a memory area that partially overlaps
the compressed data itself (only if you won't need to decompress it again later,
obviously). In this case, the last address of compressed data must be at least
"delta" bytes higher than the last address of decompressed data. The exact value
of "delta" for each case is reported by **ZX0** during compression. See image
below:

```
                       |------------------|    compressed data
    |---------------------------------|       decompressed data
  start >>                            <--->
                                      delta
```

For convenience, there's also a command-line decompressor that works as follows:

```
dzx0 Cobra.scr.zx0
```


## Performance

The **ZX0** optimal compressor algorithm is fairly complex, thus compressing
typical files can take a few seconds. During development, you can speed up this
process simply using **ZX0** in "quick" mode. This will produce a non-optimal
larger compressed file but execute almost instantly:

```
zx0 -q Cobra.scr
```

This way, you can repeatedly modify your files, then quickly compress and test
them. Later, when you finish changing these files, you can compress them again
without "quick" mode for maximum compression. Notice that using "quick" mode
will only affect the size of the compressed file, not its format. Therefore
all decompressor routines will continue to work exactly the same way.

Fortunately all complexity lies on the compression process only. The **ZX0**
compression format itself is very simple and efficient, providing a high
compression ratio that can be decompressed quickly and easily. The provided
**ZX0** decompressor routines in assembly Z80 are small and fast, they only use
main registers (BC, DE, HL, AF), consume very little stack space, and do not
require additional decompression buffer.

The provided **ZX0** decompressor in C writes the output file while reading the
compressed file, without keeping it in memory. Therefore it always use the same
amount of memory, regardless of file size. Thus even large compressed files can
be decompressed in very small computers with limited memory, even if it took
considerable time and memory to compress it originally. It means decompressing
within asymptotically optimal space and time O(n) only, using storage space O(n)
for input and output files, and only memory space O(w) for processing.


## File Format

The **ZX0** compressed format is very simple. There are only 3 types of blocks:

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
    1  Elias(MSB(offset)+1)  LSB(offset)  Elias(length-1)
```

**ZX0** needs only 1 bit to distinguish between these blocks, because literal
blocks cannot be consecutive, and reusing last offset can only happen after a
literal block. The first block is always a literal, so the first bit is omitted.

The offset MSB and all lengths are stored using interlaced
[Elias Gamma Coding](https://en.wikipedia.org/wiki/Elias_gamma_coding). When
offset MSB equals 256 it means EOF. The offset LSB is stored using 7 bits
instead of 8, because it produces better results in most practical cases.


## Advanced Features

The **ZX0** compressor contains a few extra "hidden" features, that are slightly
harder to use properly, and not supported by the **ZX0** decompressor in C. Please
read carefully these instructions before attempting to use any of them!


#### _COMPRESSING BACKWARDS_

When using **ZX0** for "in-place" decompression (decompressing data to overlap the
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
zx0 -b Cobra.scr
```

To decompress it later, you must call one of the supplied "backwards" variants
of the Assembly decompressor, specifying last source address of compressed data
in HL and last target address in DE.

For instance, if you compile a "backwards" Assembly decompressor routine to
address 64000, load backwards compressed file "Cobra.scr.zx0" (with size 2202
bytes) to address 51200, and want to decompress it directly to the ZX Spectrum
screen (with 6912 bytes), then execute the following code:

```
    LD    HL, 51200+2202-1  ; source (last address of "Cobra.scr.zx0")
    LD    DE, 16384+6912-1  ; target (last address of screen memory)
    CALL  64000             ; backwards decompress routine
```

Notice that compressing backwards may sometimes produce slightly smaller
compressed files in certain cases, slightly larger compressed files in others.
Overall it shouldn't make much difference either way.


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

For instance, if you want the first 6144 bytes of a certain file to be skipped
(not compressed but possibly referenced), then use the command-line compressor
as follows:

```
zx0 +6144 Cobra.cbr
```

In practice, suppose an action game uses a few generic sprites that are common
for all levels (such as player graphics), and other sprites are specific for
each level (such as enemies). All generic sprites must stay always accessible at
a certain memory area, but any level specific data can be only decompressed as
needed, to the memory area immediately following it. In this case, the generic
sprites area could be used as prefix when compressing and decompressing each
level, in an attempt to improve compression. For instance, suppose generic
graphics are loaded from file "generic.gfx" to address 56000, occupying 2500
bytes, and level specific graphics will be decompressed immediately afterwards,
to address 58500. To compress each level using "generic.gfx" as a 2500 bytes
prefix, use the command-line compressor as follows:

```
copy /b generic.gfx+level_1.gfx prefixed_level_1.gfx
zx0 +2500 prefixed_level_1.gfx

copy /b generic.gfx+level_2.gfx prefixed_level_2.gfx
zx0 +2500 prefixed_level_2.gfx

copy /b generic.gfx+level_3.gfx prefixed_level_3.gfx
zx0 +2500 prefixed_level_3.gfx
```

To decompress it later, you simply need to use one of the normal variants of the
Assembly decompressor, as usual. In this case, if you loaded compressed file
"prefixed_level_1.gfx.zx0" to address 48000 for instance, decompressing it will
require the following code:

```
    LD    HL, 48000  ; source address (put "prefixed_level_1.gfx.zx0" there)
    LD    DE, 58500  ; target address (level specific memory area in this case)
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

For instance, if you want to skip the last 768 bytes of a certain input file and
compress everything else (possibly referencing this "suffix" of 768 bytes), then
use the command-line compressor as follows:

```
zx0 -b +768 Cobra.cbr
```

In previous example, suppose the action game now stores level-specific sprites
in the memory area from address 33000 to 33511 (512 bytes), just before generic
sprites that are stored from address 33512 to 34535 (1024 bytes). In this case,
these generic sprites could be used as suffix when compressing and decompressing
level-specific data as needed, in an attempt to improve compression. To compress
each level using "generic.gfx" as a 1024 bytes suffix, use the command-line
compressor as follows:

```
copy /b level_1.gfx+generic.gfx level_1_suffixed.gfx
zx0 -b +1024 level_1_suffixed.gfx

copy /b level_2.gfx+generic.gfx level_2_suffixed.gfx
zx0 -b +1024 level_2_suffixed.gfx

copy /b level_3.gfx+generic.gfx level_3_suffixed.gfx
zx0 -b +1024 level_3_suffixed.gfx
```

To decompress it later, use the backwards variant of the Assembly decompressor.
In this case, if you compile a "backwards" decompressor routine to address
64000, and load compressed file "level_1_suffixed.gfx.zx0" (with 217 bytes) to
address 39000 for instance, decompressing it will require the following code:

```
    LD    HL, 39000+217-1  ; source (last address of "level_1_suffixed.gfx.zx0")
    LD    DE, 33000+512-1  ; target (last address of level-specific data)
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

The **ZX0** data compression format and algorithm was designed and implemented
by **Einar Saukas**. Special thanks to **introspec/spke** for several
suggestions and improvements, and together with **uniabis** for providing the
"Fast" decompressor. Also special thanks to **Urusergi** for additional ideas
and improvements.

The optimal C compressor is available under the "BSD-3" license. In practice,
this is relevant only if you want to modify its source code and/or incorporate
the compressor within your own products. Otherwise, if you just execute it to
compress files, you can simply ignore these conditions.

The decompressors can be used freely within your own programs (either for the
ZX Spectrum or any other platform), even for commercial releases. The only
condition is that you must indicate somehow in your documentation that you have
used **ZX0**.


## Links

**ZX0** implemented in other programming languages:

* [ZX0-Java](https://github.com/einar-saukas/ZX0-Java) - Faster
multi-thread data compressor for **ZX0** in [Java](https://www.java.com/).

* [ZX0-Kotlin](https://github.com/einar-saukas/ZX0-Kotlin) - Faster
multi-thread data compressor for **ZX0** in [Kotlin](https://kotlinlang.org/).

* [Salvador](https://github.com/emmanuel-marty/salvador) - A non-optimal but
much faster data compressor for **ZX0** in C.

**ZX0** ported to other platforms:

* [DEC PDP11](https://github.com/ivagorRetrocomp/DeZX) _("classic" file format v1)_

* [Hitachi 6309](https://github.com/dougmasten/zx0-6x09) _("classic" file format v1)_

* [Intel 8080](https://github.com/ivagorRetrocomp/DeZX) _("classic" file format v1)_

* [Intel 8088/x86](https://github.com/emmanuel-marty/unzx0_x86) _(all formats)_

* [MOS 6502](https://github.com/bboxy/bitfire/tree/master/packer/zx0/6502) _(all formats)_

* [MOS 6502](https://xxl.atari.pl/zx0-decompressor/) (stream) - _(all formats)_

* [Motorola 6809](https://github.com/dougmasten/zx0-6x09) _("classic" file format v1)_

* [Motorola 68000](https://github.com/emmanuel-marty/unzx0_68000) _(all formats)_

Tools supporting **ZX0**:

* [z88dk](http://www.z88dk.org/) - The main C compiler for Z80 machines, that
provides built-in support for **ZX0**, **ZX1**, **ZX2**, and **ZX7**.

* [ZX Basic](https://zxbasic.readthedocs.io/) - The main BASIC compiler for
Z80 machines, that provides built-in support for **ZX0**.

* [Mad-Pascal](https://github.com/tebe6502/Mad-Pascal) - The 32-bit Turbo
Pascal compiler for Atari XE/XL, that provides built-in support for **ZX0**.

* [RASM Assembler](https://github.com/EdouardBERGE/rasm/) - A very fast Z80
assembler, that provides built-in support for **ZX0** and **ZX7**.

* [MSXlib](https://github.com/theNestruo/msx-msxlib) - A set of libraries to
create MSX videogame cartridges, that provides built-in support
for **ZX0**, **ZX1**, and **ZX7**.

* [coco-dev](https://github.com/jamieleecho/coco-dev) - A Docker development
environment to create Tandy Color Computer applications, that provides
built-in support for **ZX0**.

* [Gfx2Next](https://github.com/headkaze/Gfx2Next) - A graphics conversion
utility for ZX Spectrum Next development, that provides built-in support
for **ZX0**.

* [ConvImgCpc](https://github.com/DemoniakLudo/ConvImgCpc) - An image
conversion utility for Amstrad CPC development, that provides built-in support
for **ZX0** and **ZX1**.

* [Vortex2_Player_SJASM](https://github.com/andydansby/Vortex2_Player_SJASM_ver2_compress) -
A packaging utility to compile Vortex 2 music for a ZX Spectrum, that compresses
songs using **ZX0**.

Projects using **ZX0**:

* [Bitfire](https://github.com/bboxy/bitfire) - A disk image loader/generator
for Commodore 64, that stores all compressed data using a modified version
of **ZX0**.

* [Defender CoCo 3](http://www.lcurtisboyle.com/nitros9/defender.html) - A
conversion of the official Williams Defender game from the arcades for the
Tandy Color Computer 3 that stores all compressed data using **ZX0** to fit
on two 160K floppy disks.

* [NSID_Emu](https://spectrumcomputing.co.uk/forums/viewtopic.php?f=8&t=2786) -
A SID Player for ZX Spectrum that stores all compressed data using **ZX0**.

* [ZX Interface 2 Cartridges](http://www.fruitcake.plus.com/Sinclair/Interface2/Cartridges/Interface2_RC_New_3rdParty_GameConversions.htm) -
Several ZX Interface 2 conversions were created using either **ZX0** or **ZX7**
so a full game could fit into a small 16K cartridge.

* [Joust CoCo 3](http://www.lcurtisboyle.com/nitros9/joust.html) - A port of
arcade game Joust for the Tandy Color Computer 3, that stores all compressed
data using **ZX0** to fit on a single 160K floppy disk.

* [Sonic GX](http://norecess.cpcscene.net/) - A remake of video game Sonic the
Hedgehog for the GX-4000, that stores all compressed data using **ZX0**.

* [Rit and Tam](http://www.indieretronews.com/2021/02/rit-and-tam-arcade-classic-rodland-is.html) -
A remake of platform game Rodland for the Amstrad, that stores all compressed
data using **ZX0**.

* [others](https://spectrumcomputing.co.uk/entry/36245/ZX-Spectrum/ZX0) -
A list of Sinclair-related programs using **ZX0** is available at **Spectrum Computing**.

Related projects (by the same author):

* [RCS](https://github.com/einar-saukas/RCS) - Use **ZX0** and **RCS** together
to improve compression of ZX Spectrum screens.

* [ZX0](https://github.com/einar-saukas/ZX0) - The official **ZX0** repository.

* [ZX1](https://github.com/einar-saukas/ZX1) - A simpler but faster version
of **ZX0**, that sacrifices about 1.5% compression to run about 15% faster.

* [ZX2](https://github.com/einar-saukas/ZX2) - A minimalist version of **ZX1**,
intended for compressing very small files.

* [ZX5](https://github.com/einar-saukas/ZX5) - An experimental, more complex
compressor based on **ZX0**.

* [ZX7](https://spectrumcomputing.co.uk/entry/27996/ZX-Spectrum/ZX7) - A widely
popular predecessor compressor (now superseded by **ZX0**).
