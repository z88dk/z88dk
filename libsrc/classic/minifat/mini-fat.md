# Mini-FAT

Mini-FAT is the FAT12, FAT16, and FAT32 layer in the classic library. The Z80 core is `libsrc/classic/minifat/z80/fatfs.asm`. The 8085 core is `libsrc/classic/minifat/8085/fatfs.asm`. The two files are one program. The 8085 file uses `rra` and `rl de` where the Z80 file uses `srl` and `sla`. The labels, the branch decisions, and the bytes a caller sees are the same. RAM for the volume and the sector window is `libsrc/classic/minifat/fat_bss.asm`. The C names are `include/fatfs.h`.

The on-disk work follows [ChaN FatFs R0.16](http://elm-chan.org/fsw/ff/00index_e.html) for `check_fs`, `find_volume`, `mount_volume`, `move_window`, `sync_window`, `clst2sect`, `get_fat`, `put_fat`, `create_chain`, `remove_chain`, `dir_sdi`, `dir_next`, `dir_find`, and `dir_create`. The core stops at the sector and directory layer. `f_open` and `f_read` are a later extension of `fatfs.h`, one call per file. They are not in the core.

`include/fatfs.h` is the public C header. Link one core, not both, and link `fat_bss.asm` or provide the same public names. A target that wants the objects in its library lists `classic/minifat/minifat.lst` (or `minifat_8085.lst`).

## What is in scope

FAT12, FAT16, and FAT32. 512-byte sectors. One volume. Short 8.3 names. One or two FAT copies. A super-floppy whose boot sector is at LBA 0, or an MBR with four primary partitions. The first sector that looks like a FAT boot sector is the volume. FAT12 uses the FAT16 root shape: a non-zero root entry count and `FATSz16`.

The sector window is `fatwin`, 512 bytes. Every FAT entry and every directory entry is read through that window. A dirty window is written back before a different sector is loaded. `fat_sync` writes it when you are finished.

A cluster number and an LBA are a 32-bit value in BCDE, with E as the low byte. From C, the dword functions take a pointer in HL (`__z88dk_fastcall`) and load that little-endian dword themselves.

Success is `L = 0` and carry set. Failure is `L = 1` and carry clear. A 64 KiB cluster is the exception: `L = 19` (`FR_INVALID_PARAMETER`) and carry clear. sccz80 treats a `char` return as an `int`, so the exits also clear H. 80cc returns the byte in L. Test L, or test carry, and you will agree.

## What ChaN does that this does not

ChaN's [application interface](http://elm-chan.org/fsw/ff/00index_e.html) opens a file, seeks, reads, writes, and closes it, and it can do that for several files at once. Mini-FAT does not. You walk the cluster chain and you read the sectors.

Also out of scope for the core: exFAT, long file names, GPT, extended partitions, and a current directory stack. `BPB_Media` is not read. The jump instruction at the start of the boot sector is not required. The `55 AA` signature is required. ChaN accepts some boot sectors that have no signature. This code does not. There is no `ffconf.h` and no option set.

`dir_next` does not grow a directory. `dir_create` grows a FAT32 directory when the chain is already at its end. A FAT16 root and a FAT16 subdirectory stay the size they were formatted.

## Calling it from your own program

Link one of the two assembly files, not both. Link `fat_bss.asm`, or provide the same public names yourself. The block may be placed at `FAT_BSS_ORG`. A program that runs where it was linked can leave the block in ordinary BSS.

You supply the disk. The core calls three assembly routines. They have no C prototype and they do not follow the C ABI. A C program does not call them.

`asm_disk_initialize`

- In: `L = 0`. That is the only drive the core brings up.
- Out: carry set means the drive is ready. Carry clear means it is not.
- The core tests carry only. It does not read a status byte from HL.
- The core keeps BC across the call. The other registers may change.

`ide_read_sector`

- In: `BCDE` is the absolute LBA, E the least significant byte. `HL` is the destination, 512 bytes.
- Out: carry set means those 512 bytes were stored and `HL` is `HL + 512`. Carry clear means the sector was not read.
- Clobbers AF, BC, DE, and HL.

`ide_write_sector`

- In: `BCDE` is the LBA, E least significant. `HL` is the source, 512 bytes.
- Out: carry set means the sector was written and `HL` is `HL + 512`. Carry clear means it was not written.
- Clobbers AF, BC, DE, and HL.

One sector per call. The LBA is the absolute sector on that drive. The core saves the LBA across the call. These are not ChaN `disk_read` and `disk_write`.

Then:

1. Call `fat_mount` (C: `fat_mount()`). On success `_cpm_fat_vol` describes the volume. `fs_type` is stored only after every check has passed, so a failed mount leaves it zero.
2. Open a directory with `fat_dir_open`. Cluster 0 is the FAT32 root. A FAT16 root is the fixed `dirbase` LBA, and the shell treats cluster 0 as that root as well.
3. `dir_find` looks up an 11-byte name in the directory you opened. `fat_dir_read` copies one 32-byte entry and returns 0 at the end of the directory.
4. To read a file, take its start cluster and size from the entry (`fat_found_sclust`, `fat_found_size` after a successful find). `fat_next` is `get_fat`. `fat_clst2sect` is the first sector of that cluster. Read `csize` sectors, then ask for the next cluster. The end of a FAT12 chain is `$FF8`–`$FFF`, folded to `$0FFFFFFF`. The end of a FAT16 chain is `$FFF8`–`$FFFF`. The end of a FAT32 chain is `$0FFFFFF8` and up. A bad cluster (`$FF7` / `$FFF7` / `$0FFFFFF7`) is an error, not a link.
5. To write a new file, `dir_create` makes an 8.3 entry, `fat_alloc` / `create_chain` links clusters, you write the sectors, you store the size back into the directory entry, and `fat_sync` commits the window. `dir_zap` marks the entry `$E5`. It does not free the chain. Call `fat_free` yourself.
6. `fat_getfree` counts free clusters into the dword you point at. `fat_clusters` turns a byte length into the number of clusters that length needs.

The directory entry layout is Microsoft's. Byte 0 is the name. `$00` ends the directory. `$E5` is a deleted slot and can be reused. A real name that begins with `$E5` is stored as `$05`, and a compare treats `$05` as `$E5`. Attribute `$0F` is a long name. Attribute `$08` is a label and `$10` is a directory. The volume bit is set on a long name, so a test of that bit skips both labels and long names. The archive bit is `$20`.

`n_fatent` is the cluster count plus 2. Cluster numbers below 2 are not data. `csize` is a power of two. `SecPerClus` of 65 or more is refused, because a 64 KiB cluster is 0 in the 16-bit sector arithmetic.

Two boundaries follow ChaN rather than Microsoft FAT specification 1.03. A cluster count of `$0FF5` or below is FAT12. The specification would still call 4085 clusters FAT16. A count of `$FFF5` stays FAT16. The specification would call that FAT32. A count above `$0FFFFFF5` is rejected. `put_fat` stores 28 bits on FAT32 and 12 bits on FAT12. A FAT of `$200000` sectors or more is rejected before the copies are added.

A FAT12 entry is 12 bits packed as `clst + clst/2` bytes from the start of the FAT. An even cluster owns the low 12 bits. An odd cluster owns the high 12 bits. The two bytes can sit in different sectors. The size of the FAT is `(n_fatent * 3 + 1) / 2` bytes, rounded up to sectors. A free count on FAT12 walks clusters 2 through `n_fatent - 1`. Clusters 0 and 1 are reserved.

The IDE address is 28 bits. A partition, FAT, or data area at LBA `$10000000` or above fails the mount. An FSInfo sector past that LBA leaves the hint clear and the mount still succeeds. `$0FFFFFFF` is the last sector the interface can name.

A FAT16 root entry count has to be a non-zero multiple of 16. 2048 entries is the whole 16-bit directory offset. FAT32 requires `FATSz16 = 0`, `FSVer = 0`, and a root entry count of 0. The root cluster is `BPB_RootClus`. When mirroring is off, the active FAT is the one in `BPB_ExtFlags`, and the other copy is not written. FAT32 FSInfo is read at mount. A sync writes the free count and the next free cluster when either has changed.

## The volume block

`fat_vol_t` in `fatfs.h` is the block at `_cpm_fat_vol`:

| Field | Meaning |
|--|--|
| `fs_type` | 0 until mount succeeds, then 1 = FAT12, 2 = FAT16, 3 = FAT32 |
| `csize` | sectors per cluster |
| `n_rootent` | FAT12 and FAT16 root entries, 0 on FAT32 |
| `n_fatent` | clusters plus 2 |
| `fatbase` | LBA of the FAT |
| `dirbase` | FAT16 root LBA, or the FAT32 root cluster |
| `database` | LBA of cluster 2 |
| `fatsz` | sectors in one FAT |
| `n_fats` | 1 or 2 |
| `free_valid` | 1 when `free_clst` is live |
| `free_clst` | free clusters |

`_cpm_dir_sclust` is sixteen dwords. The shell stores the start cluster of drive A: in the first and drive P: in the last. Zero means that letter is not mounted. Mini-FAT does not interpret drive letters. The BDOS does.

## On the RC2014

The product copies the CCP, the BDOS stub, and the BIOS into high RAM. Mini-FAT stays in the ROM and runs where it was linked. From `cboot` until `wboot` latches the ROM back in, RAM covers the ROM window. That stretch of the boot must not call mini-FAT.

`fatwin` is also the buffer the BDOS uses for the function 27 allocation vector. That routine invalidates the window before it returns. The next disk call loads a real sector again.

The shell follows a cluster chain that is more than one run. A file does not have to be contiguous.

<p><a href="../README.md">Back</a></p>
