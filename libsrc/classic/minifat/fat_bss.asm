;
; Copyright (c) November 2026 Phillip Stevens (feilipu)
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;
;
; RAM for the shell mini-FAT. CRT BSS (after data, at the rc2014 RAM
; origin). The BIOS high page has no room under the serial rings.
; The +test harness does not link this file. It defines the same names
; in bss_ram.asm.
;

SECTION bss_compiler

;
; Product link defines FAT_BSS_ORG and copies nothing: the preamble
; zeros this block at the run address. The +test harness does not
; link this file.
;
IFDEF FAT_BSS_ORG
PHASE FAT_BSS_ORG
PUBLIC _fat_bss_head
_fat_bss_head:
ENDIF

PUBLIC _cpm_fat_vol
PUBLIC _fatwin
PUBLIC fatwin
PUBLIC fat_winsect
PUBLIC fat_wflag
PUBLIC _fat_cwd
PUBLIC fat_cwd
PUBLIC _fat_found_sclust
PUBLIC fat_found_sclust
PUBLIC _fat_found_size
PUBLIC fat_found_size
PUBLIC _fat_dir_ptr
PUBLIC dir_ptr
PUBLIC dir_sclust
PUBLIC dir_clust
PUBLIC dir_sect
PUBLIC dir_ofs
PUBLIC fat_work
PUBLIC pack_sv
PUBLIC fat_last_clst
PUBLIC _fat_last_clst
PUBLIC fat_fsi_lba
PUBLIC _fat_fsi_lba
PUBLIC fat_fsi_dirty
PUBLIC _fat_fsi_dirty
PUBLIC clst_cache_sclust
PUBLIC clst_cache_ci
PUBLIC clst_cache_clst
PUBLIC _cpm_dir_sclust

_cpm_dir_sclust:        defs 64     ;A: through P:, one start cluster each. 0 is not mounted
; Mounted volume. 32 bytes.
; +0 fs_type. 1 is FAT12. 2 is FAT16. 3 is FAT32.
; +1 csize. csize is 2^n sectors per cluster.
; +2 n_rootent. +4 n_fatent. n_fatent is nclst + 2.
; +8 fatbase. +12 dirbase. +16 database. +20 fatsz.
; +24 n_fats. +25 free_valid. 1 means free_clst is live.
; +26 is unused. +28 free_clst.
_cpm_fat_vol:           defs 32     ;mounted volume record
_fatwin:
fatwin:                 defs 512    ;sector window
fat_winsect:            defs 4      ;sector number in the window
fat_wflag:              defs 1      ;1 means the window needs a write
dir_sclust:             defs 4      ;start cluster of the open directory
dir_clust:              defs 4      ;cluster that holds the current entry
dir_sect:               defs 4      ;sector of the current directory entry
dir_ofs:                defs 2      ;byte offset in the open directory
_fat_dir_ptr:
dir_ptr:                defs 2      ;address of the current directory entry
_fat_found_sclust:
fat_found_sclust:       defs 4      ;start cluster from the last find
_fat_found_size:
fat_found_size:         defs 4      ;byte length from the last find
clst_cache_sclust:      defs 4      ;start cluster of the cached chain walk
clst_cache_ci:          defs 2      ;cluster index in that walk
clst_cache_clst:        defs 4      ;cluster number at that index
_fat_cwd:
fat_cwd:                defs 4      ;start cluster of the current directory
fat_work:               defs 16     ;scratch dwords for the core
pack_sv:                defs 16     ;scratch for a pointer or a cluster
_fat_last_clst:
fat_last_clst:          defs 4      ;last cluster this session allocated
_fat_fsi_lba:
fat_fsi_lba:            defs 4      ;absolute FSInfo LBA, or 0 if none
_fat_fsi_dirty:
fat_fsi_dirty:          defs 1      ;1 = free count or next-free needs a write

IFDEF FAT_BSS_ORG
PUBLIC _fat_bss_tail
_fat_bss_tail:
DEPHASE
ENDIF
