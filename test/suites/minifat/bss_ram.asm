; High-RAM cells for +test (no PHASE). Layout matches BIOS BSS names.

SECTION bss_compiler

PUBLIC _cpm_fat_vol, fatwin, _fatwin, fat_winsect, fat_wflag
PUBLIC fat_cwd, fat_found_sclust, fat_found_size
PUBLIC dir_ptr, dir_sclust, dir_clust, dir_sect, dir_ofs
PUBLIC fat_work, pack_sv, fat_last_clst, _fat_last_clst, _cpm_dir_sclust
PUBLIC fat_fsi_lba, _fat_fsi_lba, fat_fsi_dirty, _fat_fsi_dirty
PUBLIC clst_cache_sclust, clst_cache_ci, clst_cache_clst
PUBLIC _fat_cwd, _fat_found_sclust, _fat_found_size, _fat_dir_ptr, _fat_dir_sclust

_cpm_dir_sclust:        defs 64     ;A: through P:. 0 is not mounted
_cpm_fat_vol:           defs 32
_fatwin:
fatwin:                 defs 512
fat_winsect:            defs 4
fat_wflag:              defs 1
_fat_dir_sclust:
dir_sclust:             defs 4  ;directory start cluster; 0 = FAT16 static root
dir_clust:              defs 4  ;cluster of the current directory sector
dir_sect:               defs 4  ;LBA of the current directory sector
dir_ofs:                defs 2  ;byte offset in the directory
_fat_dir_ptr:
dir_ptr:                defs 2  ;current 32-byte dirent in fatwin
_fat_found_sclust:
fat_found_sclust:       defs 4
_fat_found_size:
fat_found_size:         defs 4
clst_cache_sclust:      defs 4
clst_cache_ci:          defs 2  ;cluster index from start
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

; v2.6 deblock names. This branch's cpm22bios.asm does not define hstbuf.
; The BDOS disk harness defines BDOS_NO_DEBLOCK. It does not link bios_disk.
IFNDEF BDOS_NO_DEBLOCK
PUBLIC hstbuf, _hstbuf, hstdsk, _hstdsk, hsttrk, _hsttrk, hstsec, _hstsec
PUBLIC hstwrt, _hstwrt
PUBLIC wrtype, dmaadr, erflag, hstact, _hstact
PUBLIC _cpm_dsk0_base
PUBLIC sekdsk, sektrk, seksec, sekhst
PUBLIC unacnt, unadsk, unatrk, unasec
PUBLIC rsflag, readop
PUBLIC DIRBUF, _dirbuf
PUBLIC ldi_body, _ldi_body
_cpm_dsk0_base:         defs 16     ; 4 x 32-bit LBA bases
_hstbuf:
hstbuf:                 defs 512
_hstdsk:
hstdsk:                 defs 1
_hsttrk:
hsttrk:                 defs 1
_hstsec:
hstsec:                 defs 1
_hstwrt:
hstwrt:                 defs 1
wrtype:                 defs 1
dmaadr:                 defs 2
erflag:                 defs 1
sekdsk:                 defs 1
sektrk:                 defs 2
seksec:                 defs 2
sekhst:                 defs 1
_hstact:
hstact:                 defs 1
unacnt:                 defs 1
unadsk:                 defs 1
unatrk:                 defs 2
unasec:                 defs 2
rsflag:                 defs 1
readop:                 defs 1
DIRBUF:
_dirbuf:                defs 2
_ldi_body:
ldi_body:               defs 65     ;Z80 33; 8085 65; copy_build fills this
ENDIF
