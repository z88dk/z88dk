# Classic mini-FAT

Branch `classic-minifat`.

The core stays one file per CPU. Splitting `fatfs.asm` is later work. That later split removes only optional functions, and only when a program does not call them. The core remains one file.

This is mini-FAT, not ChaN FatFs. There is no option set and no `ffconf.h`. Do not copy `ff.h` or `ffconf.h` into this tree. ChaN and Microsoft fatgen103 are read for on-disk behaviour. They are not headers here. `src/appmake/ff.h` is the host appmake tool. Leave it alone.

## Jobs

1. Copy the CPM-IDE mini-FAT source (`fatfs.asm`, `fatfs_85.asm`, `fat_bss.asm`, `fatfs.h`) and the test harness into the classic library and `test/suites/minifat`. Done.

2. Teach the existing Z80 and 8085 cores FAT12. Update `include/fatfs.h` and `libsrc/classic/minifat/mini-fat.md`.

3. Extension, after the Z80 and 8085 core suite is green. Add ChaN's function contracts to `include/fatfs.h`. Do not add `ff.h`, `ffconf.h`, or `diskio.h`. There is no option set. The first slice is the file calls: `f_mount`, `f_open`, `f_close`, `f_read`, `f_write`, `f_lseek`, `f_sync`. Do not write these in C, and do not start from a blank page. Compile the matching function from ChaN `ff.c` with 80cc in stack-pointer mode (not `-fframe-pointer`) and use that listing as the outline. The delivered file is still hand-written CPU-specific assembly, one function per file, and it links only if the program calls it. The 80cc listing is not linked. The Z80 file lives under `libsrc/classic/minifat/z80/` and the 8085 file under `libsrc/classic/minifat/8085/`. `fatfs.h` gains the types that slice needs (`FRESULT`, `FIL`, `FATFS`, the open mode bits). The rest of the `ff.h` contracts (directory, `f_mkdir`, `f_unlink`, `f_rename`, `f_stat`, `f_chmod`, `f_utime`, `f_chdir`, `f_chdrive`, `f_getcwd`, `f_getfree`, `f_expand`) follow the same way, one assembly file per CPU at a time. Find, label, forward, `f_mkfs`, `f_fdisk`, `f_setcp`, and the string helpers stay out of the first slice. `f_eof`, `f_tell`, `f_size`, and `f_rewind` are macros once `FIL` has the fields they read. Job 3 comes before job 4 because every later CPU needs the same assembly calls, not a C file shared across CPUs.

4. Add 8080, gbz80, and vm1 cores, one file each, with a passing suite row per CPU. Read that CPU skill immediately before writing its file. Do not copy an 8085 core onto 8080, gbz80, or vm1. Each CPU also gets its own assembly copies of the job 3 calls. Those copies are written with the core, after the Z80 and 8085 calls exist to copy from.

## Where the files live

Classic layout, same idea as stdio, gfx, fcntl, and sdcard. `buildbit` does not recurse, so each CPU core has its own directory.

```
include/fatfs.h               mini-FAT C contract

libsrc/classic/minifat/fat_bss.asm
libsrc/classic/minifat/mini-fat.md
libsrc/classic/minifat/minifat.mak
libsrc/classic/minifat/minifat.lst
libsrc/classic/minifat/minifat_8085.lst
libsrc/classic/minifat/minifat_8080.lst
libsrc/classic/minifat/minifat_gbz80.lst
libsrc/classic/minifat/minifat_vm1.lst
libsrc/classic/minifat/z80/fatfs.asm
libsrc/classic/minifat/8085/fatfs.asm
libsrc/classic/minifat/8080/fatfs.asm
libsrc/classic/minifat/gbz80/fatfs.asm
libsrc/classic/minifat/vm1/fatfs.asm
libsrc/classic/minifat/z80/f_*.asm
libsrc/classic/minifat/8085/f_*.asm
libsrc/classic/minifat/8080/f_*.asm
libsrc/classic/minifat/gbz80/f_*.asm
libsrc/classic/minifat/vm1/f_*.asm

test/suites/minifat/
```

`libsrc/Makefile` includes `classic/minifat/minifat.mak` after `sdcard.mak`.

Objects are built. They are not pulled into every classic link. A target that wants the core lists `@classic/minifat/minifat.lst`, `minifat_8085.lst`, `minifat_8080.lst`, `minifat_gbz80.lst`, or `minifat_vm1.lst`, the way osca lists sdcard. `classic/z80.lst` is shared by ixiy, z80n, and kc160, so this list does not belong there. The suite compiles the asm on the zcc line and does not need the archive.

`fat_bss.asm` is the only asm in the parent directory. The core file for a CPU is not split in this work.

## Truth and scope of the core

Truth for the on-disk format: the copied CPM-IDE core, then ChaN's FAT12/16/32 entry layout, then Microsoft fatgen103. The code in the tree is mini-FAT.

In scope: one volume, 512-byte sectors, 8.3 names, FAT12, FAT16, and FAT32.

Out of scope for the core: exFAT, LFN, GPT, more than one volume, and ChaN `FF_USE_*` switches. The `f_*` calls are job 3. They are declared in `fatfs.h` and implemented in CPU-specific assembly. They are not C, not a second library, and not a copied `ff.h`.

`fs_type`: 1 = FAT12, 2 = FAT16, 3 = FAT32. The pending type sits at `_cpm_fat_vol+26` and is published to `+0` only when mount succeeds.

FAT12 is the same band the core already used to reject a volume: `nclst <= $0FF5`. Spec 1.03 would still call 4085 FAT16. Keep that edge. `nclst == $FFF5` stays FAT16. `nclst > $0FFFFFF5` is rejected.

FAT12 uses the FAT16 root shape: non-zero root entry count, FATSz16, fixed `dirbase`. An empty root fails the mount. FAT32 still requires FATSz16 == 0, FSVer == 0, and RootEntCnt == 0.

FAT12 size is `bytes = (n_fatent * 3 + 1) / 2`, sectors = `(bytes + 511) >> 9`. Do not use the FAT16 `(n_fatent + 255) >> 8` formula. `n_fatent` fits in 16 bits (`<= $FF7`), so `n * 3` fits in 16 bits.

Packed entry: byte offset `clst + clst / 2`. Even cluster: low 12 bits. Odd cluster: `>> 4`. The 16-bit field can cross a 512-byte boundary (cluster 341, offset 511). On a write, store the first byte and set the window dirty before the window moves, then store the second byte. EOC is `>= $FF8`, folded to `$0FFFFFFF`. Bad is `$FF7` (carry clear). Free is 0.

Any `cp FS_FAT32 / jr nz → FAT16` path treats FAT12 as FAT16. Branch FAT12 first in `fat_fatent`, `get_fat`, `put_fat`, `fat_win_is_free`, the fatsz check, mount, and getfree. `create_chain`, `remove_chain`, and the directory ops stay as they are once get and put are right.

getfree on FAT12 walks clusters 2 .. `n_fatent - 1` through `get_fat`. Clusters 0 and 1 are reserved. Carry clear from `get_fat` fails getfree. Do not count a disk error as a free cluster.

`get_fat` and `put_fat` must not use `fat_work` as scratch. Callers such as `create_chain` own it. `pack_sv` is live across `_fat_next`.

C contract: success is L = 0 (carry set in the asm ops). Fail is L = 1, carry clear. A 64 KiB cluster is L = 19. Cluster and LBA values are BCDE, E least significant. Pointers are `__z88dk_fastcall` in HL.

8085 code uses the 8085 file's existing style: `rra`, `jp`, `sub hl,bc`. No `srl`, `djnz`, or `ldir` in the FAT12 patch. Prefer `ld hl,(nn)` for new loads. 8080 has no 8085 extras and no IX. gbz80 has no IX/IY and `ex de,hl` is a long synthetic. vm1 is 8080 plus its own extras; `$10` and `$18` are not Z80 relative jumps. Never `pop af` on vm1 unless the word came from `push af`.

Zilog mnemonics. Hand-written asm is assembled as-is. No new language and no new host tool in the suite. The C test builds its own sector images. Do not import `mkfat.py`.

## Disk calls

`asm_disk_initialize`, `ide_read_sector`, and `ide_write_sector` are assembly calls. They have no C prototype and they do not follow the C ABI. A C program does not call them. The core calls them. The same contract is in `libsrc/classic/minifat/mini-fat.md`. The symbol is `asm_disk_initialize`.

`asm_disk_initialize`

- In: `L = 0`. That is the only drive the core brings up.
- Out: carry set means the drive is ready. Carry clear means it is not.
- The core tests carry only. It does not read a status byte from HL.
- The core keeps BC across the call. The other registers may change.

`ide_read_sector`

- In: `BCDE` is the absolute LBA, E the least significant byte. `HL` is the destination, 512 bytes.
- Out: carry set means those 512 bytes were stored and `HL` is `HL + 512`. Carry clear means the sector was not read.
- Clobbers AF, BC, DE, and HL.
- One sector. Not ChaN `disk_read` (`pdrv`, buffer, LBA, count).

`ide_write_sector`

- In: `BCDE` is the LBA, E least significant. `HL` is the source, 512 bytes.
- Out: carry set means the sector was written and `HL` is `HL + 512`. Carry clear means it was not written.
- Clobbers AF, BC, DE, and HL.
- One sector. Not ChaN `disk_write`.

## Bugs in the copied cores

A defect in the copied `fatfs.asm` or `fatfs_85.asm` behaviour is written here and left for a later pass. Do not patch it while adding FAT12. FAT12 code that does not assemble or does not write the bytes it computed is unfinished work, not one of these notes.

None recorded yet.

## Tests

`test/suites/minifat`, wired from `test/suites/Makefile`. `zcc +test`, then `z88dk-ticks` with the CPU flag before the binary. The harness prints `MINIFAT_OK` or `MINIFAT_BAD`. Link the core, the RAM disk, `bss_ram.asm`, and the BIOS glue. Do not also link `fat_bss.asm` (same public names).

The old FAT12 case expected mount to fail. After job 2 it must mount (`fs_type == 1`, `n_fatent == 42`) and then cover getfree, `fat_next`, and `fat_alloc`. A second volume covers cluster 341, where the entry spans two FAT sectors. That volume's data area is outside the 48-sector RAM image; the test must only touch the VBR and the FAT. Call `rt_invalidate()` after a dirty `fat_alloc` before the next image is written.

Do not claim the suite passes until ticks prints `MINIFAT_OK`.

## Order of work

1. This file.
2. Finish the Z80 FAT12 writer and the getfree walk. Assemble that one file.
3. Same behaviour in the 8085 core. Read the 8085 skill first.
4. Update `include/fatfs.h` comments and `mini-fat.md`.
5. Update the suite expects and run Z80 and 8085 until `MINIFAT_OK`.
6. `make -C libsrc classic-minifat` so the objects exist. Do not `make install`.
7. Job 3, the basic file calls, in Z80 assembly and then 8085 assembly. One function per file. Outline each one from `ff.c` compiled with 80cc stack-pointer mode. Each call gets a test. No C in the library.
8. Job 4, one CPU at a time, skill first. The core and the job 3 assembly calls for that CPU, then a passing suite row.

## State

Jobs 1 to 4 are done. Each CPU has one core, `fatfs.asm`, under `z80`, `8085`, `8080`, `gbz80`, and `vm1`. The `f_*` calls are CPU-specific assembly, one function per file, in that same directory. `include/fatfs.h` declares them. Find, label, forward, `f_mkfs`, `f_fdisk`, `f_setcp`, and the string helpers stay out. `test/suites/minifat` prints `MINIFAT_OK` for all five CPUs under sccz80 and under 80cc. `make -C libsrc classic-minifat` builds the objects. Do not `make install`.
