/*
 * Copyright (c) October 2026 Phillip Stevens (feilipu)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef CPM_IDE_FATFS_H
#define CPM_IDE_FATFS_H

#include <stdint.h>

/*
 * Public C API for mini-FAT. Include this header. Link
 * libsrc/classic/minifat/z80/fatfs.asm or the 8085 file, and
 * libsrc/classic/minifat/fat_bss.asm. The long form is
 * libsrc/classic/minifat/mini-fat.md.
 *
 * asm_disk_initialize, ide_read_sector, and ide_write_sector are
 * assembly calls. They have no C prototype and they do not follow
 * the C ABI. The register contract is in mini-fat.md.
 *
 * fs_type is 1 for FAT12, 2 for FAT16, 3 for FAT32, and 0 until
 * mount succeeds. f_open, f_read, and the other ChaN file calls are
 * added to this header as a later extension. Each one is CPU-specific
 * assembly, one function per file.
 *
 * Success is 0 in L. 80cc and sccz80 return that byte in L, and
 * sccz80 widens it to an int, so H is 0.
 * Pointer arguments are __z88dk_fastcall (HL).
 * DWORD cluster/LBA marshals load little-endian *(uint32_t *) into BCDE.
 * fat_getfree writes the free-cluster count through that pointer.
 */

typedef struct {
    uint8_t  fs_type;
    uint8_t  csize;
    uint16_t n_rootent;
    uint32_t n_fatent;
    uint32_t fatbase;
    uint32_t dirbase;
    uint32_t database;
    uint32_t fatsz;
    uint8_t  n_fats;
    uint8_t  free_valid;            /* 1 = free_clst live */
    uint8_t  pad[2];
    uint32_t free_clst;
} fat_vol_t;

extern fat_vol_t  cpm_fat_vol;
extern uint32_t   cpm_dir_sclust[16];
extern uint32_t   fat_cwd;
extern uint32_t   fat_found_sclust;
extern uint32_t   fat_found_size;
extern uint8_t  * fat_dir_ptr;

extern uint8_t fat_mount(void);
extern uint8_t dir_find(uint8_t *name11) __z88dk_fastcall;
extern uint8_t dir_create(uint8_t *name11) __z88dk_fastcall;
extern uint8_t dir_zap(void);
extern uint8_t fat_sync(void);
extern void fat_dirty(void);
extern uint8_t fat_dir_open(uint32_t *sclust) __z88dk_fastcall;
extern uint8_t fat_dir_read(uint8_t *ent32) __z88dk_fastcall;
extern uint8_t fat_next(uint32_t *clst) __z88dk_fastcall;
extern uint8_t fat_alloc(uint32_t *clst) __z88dk_fastcall;
extern uint8_t fat_free(uint32_t *clst) __z88dk_fastcall;
extern uint8_t fat_clst2sect(uint32_t *clst) __z88dk_fastcall;
extern uint8_t fat_getfree(uint32_t *nclst) __z88dk_fastcall;
/* *bytes in: file size. Out: clusters to allocate, or 0 if that rounds to none. */
extern void fat_clusters(uint32_t *bytes) __z88dk_fastcall;

#define FR_OK                  0
#define FR_DISK_ERR            1
#define FR_INT_ERR             2
#define FR_NOT_READY           3
#define FR_NO_FILE             4
#define FR_NO_PATH             5
#define FR_INVALID_NAME        6
#define FR_DENIED              7
#define FR_EXIST               8
#define FR_INVALID_OBJECT      9
#define FR_WRITE_PROTECTED     10
#define FR_INVALID_DRIVE       11
#define FR_NOT_ENABLED         12
#define FR_NO_FILESYSTEM       13
#define FR_MKFS_ABORTED        14
#define FR_TIMEOUT             15
#define FR_LOCKED              16
#define FR_NOT_ENOUGH_CORE     17
#define FR_TOO_MANY_OPEN_FILES 18
#define FR_INVALID_PARAMETER   19

#define AM_RDO  0x01
#define AM_HID  0x02
#define AM_SYS  0x04
#define AM_VOL  0x08
#define AM_DIR  0x10
#define AM_ARC  0x20
#define AM_LFN  0x0F

#endif
