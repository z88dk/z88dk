# Generating Big SNAs with Z88DK

It turns out that NextOS and various emulators are happy with 128k sna snapshots as long as the
standard portion contains what is expected.  They are not too finicky about these snapshots being
too long which has opened up another possibility for sna snapshots - the big sna with data for
extra memory banks appended to the end.  In this way a single sna snapshot can hold the entire
contents of the zx next's memory space and this can be loaded automatically when the sna snapshot
runs.

Appmake, the program responsible for generating output in z88dk, has been updated to generate
these big SNAs.  To generate them, blocks of form {page,8k} are appended; that is, one byte
identifies the destination memory page and 8k of data follows that.  In addition, a special
page id of 255 is used to tell the loader to stop loading and return.  The program will then
have a file pointer position pointing after the 255 byte that can be used to load extra data
at runtime.  The intention is to allow even more data to be appended to the big SNA by the user
that is SEEKed and loaded as needed at runtime.

Appmake can generate two types of big SNAs: the extended SNA and the new SNX.

## The Extended SNA

This is just a standard 128k SNA with extra bank data appended.  Many emulators are able to
start this snapshot type without any changes.  To load the appended bank data, the program
needs to know its filename on disk so that it can open its own file and find that data.
Appmake will write the filename into the snapshot if you provide a space of 13 characters
with label `__z_sna_filename` in the main bank.  The filename will match the name of the
output sna generated.  If the name is changed on disk, the load process will fail.

The example `sna.c` shows how the load process works.  The load process could have been
hidden in the crt code but it was decided to keep it exposed for reasons that should be
clear shortly.  The example creates a buffer with name `_z_sna_filename` (C adds an extra
leading underscore) which will be filled in with the sna filename by appmake.  Then it opens
the file and calls function `extended_sna_load` which handles the loading.  On return, if
you have appended extra data with page id 255 delimiter, the file pointer will now point
just past the 255 byte.  In this example, the file is just closed and the program continues
knowing all memory banks have loaded.  If you do not supply label `__z_sna_filename`,
appmake will not write the sna filename into the snapshot.  Instead you can open a fixed
filename that must match the name used on disk.

The bank loading should happen right after the sna starts.  There are a couple of caveats
for `extended_sna_load`.  One is that it must lie at address 24576 (0x6000) or above
because it uses mmu2 to load into the extra pages.  The other is it assumes page 10 is
in mmu2 when it is called; this is correct if it is run just after the sna loads and you
haven't done any banking in mmu2 yet.

The options necessary on the compile line to generate this sna type are described below.

## The New SNX Form

This is actually identical to the extended SNA except NextOS 1.98E and higher will leave
the file handle used to read the sna file open when the sna starts.  This means it is
no longer necessary to know the sna filename on disk and there is no problem if the user
renames the file either.  This is great except it won't work on emulators that do not
run NextOS and are not modified to support his new type.  NextOS will always uses file
handle zero to open the file.  The file position after loading the standard portion of
the sna is indeterminant so a seek is necessary to get to the portion appended to the sna.

The example `snx.c` shows how things change from the extended sna type.  Everything is the
same except no file open is necessary; instead file handle 0 is used directly.

## Compile Line Arguments for Generating SNAs

All forms will be reviewed here.

`-subtype=sna -Cz"--clean --fullsize --pages" -create-app`

This will generate either a 48k or 128k sna depending on whether the program has stuff in
the 128k memory banks. "--clean" means the sna generator will remove binaries produced by
the compile as it uses them to generate the output. Any remaining binary files are your
responsibility to load into memory. Things placed into zx next memory that cannot normally
be stored in a standard sna (ie 16k banks 8 and above) will be output as separate binary
files. "--fullsize" says those binary files should be padded to a full 8k or 16k. "--pages"
indicates contents of memory should be output as 8k pages.

`-subtype=sna -Cz"--128 --clean --fullsize --pages" -create-app`

As above but this time force a 128k snapshot. NextOS does treat 48k and 128k snas differently.
In particular 48k snapshots have port 7ffd locked when started.

`-subtype=sna -Cz"--ext --clean --fullsize --pages" -create-app`

This is the new big sna type. The contents of BANK and PAGE space will be added to the end
of the sna. You can manually append even more data to the sna if you add a single byte "255"
preceeding the appended data. This appended data will be ignored by the loader. "--fullsize
--pages" will only affect the binary files produced for other bankspaces like divmmc memory
that will not be placed in the sna.

`-subtype=snx -Cz"--fullsize --clean" -create-app`

This produces an snx file.  Identical to the big sna form just described except with file
extension .snx.

## Compile

The extended sna example can be compiled like this:

zsdcc compile
```
zcc +zxn -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sna.c mem.asm -o sna -subtype=sna -Cz"--ext --fullsize --clean" -create-app
```

sccz80 compile
```
zcc +zxn -vn -startup=0 -clib=new sna.c mem.asm -o sna -subtype=sna -Cz"--ext --fullsize --clean" -create-app
```

The snx example can be compiled like this:

zsdcc compile
```
zcc +zxn -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 snx.c mem.asm -o snx -subtype=snx -Cz"--fullsize --clean" -create-app
```

sccz80 compile
```
zcc +zxn -vn -startup=0 -clib=new snx.c mem.asm -o snx -subtype=snx -Cz"--fullsize --clean" -create-app
```

In both examples, data is placed into some of the zx next's memory banks by the asm file `mem.asm`.
The 2k pattern placed in BANK_5 will appear on the screen as vertical stripes when the sna is loaded.
The rest of the program prints out the contents of the loaded pages uses two hex digits for each byte.
Eight rows of 0s should be seen (corresponding to 128 zero bytes), followed by eight rows of page
numbers in hex, followed by eight rows of 0xff bytes (corresponding to 128 0xff bytes).

`mem.asm` also places an item into divmmc page 1.  This will not be part of the sna and you will
instead see it ouput as a separate binary.  Existing as a separate binary (with "--clean" option)
means it is not in the sna/snx and the program is responsible for loading it into memory somehow.
In this example, the divmmc page is only there to verify the sna generation is working.

Note that the examples are using the nextos-api with functions prefixed with `esx_*` instead of
`esxdos_*`.  The `esx_*` functions use the [esxdos api as documented by NextOS](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/arch/zxn/esxdos.h#L19) whereas the `esxdos_*`
functions use the [original esxdos api](https://github.com/z88dk/z88dk/blob/master/include/_DEVELOPMENT/sdcc/arch/zx/esxdos.h).  At the moment the code is separate but as each function
is verified to be identical between the two, they will point at the same code.  If you want to
guarantee your programs work with original esxdos, use the `esxdos_*` api.  NextOS expands the
esxdos api so some functions can only be found with `esx_*` prefix.
