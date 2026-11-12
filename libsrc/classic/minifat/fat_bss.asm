;
; Copyright (c) October 2026 Phillip Stevens (feilipu)
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
; The +test harness does not link this file; it defines the same names
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
_cpm_fat_vol:           defs 32
_fatwin:
fatwin:                 defs 512
fat_winsect:            defs 4
fat_wflag:              defs 1
dir_sclust:             defs 4
dir_clust:              defs 4
dir_sect:               defs 4
dir_ofs:                defs 2
_fat_dir_ptr:
dir_ptr:                defs 2
_fat_found_sclust:
fat_found_sclust:       defs 4
_fat_found_size:
fat_found_size:         defs 4
clst_cache_sclust:      defs 4
clst_cache_ci:          defs 2
clst_cache_clst:        defs 4
_fat_cwd:
fat_cwd:                defs 4
fat_work:               defs 16
pack_sv:                defs 16
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
