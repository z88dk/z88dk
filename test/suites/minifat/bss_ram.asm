; High-RAM cells for +test (no PHASE). Layout matches the mini-FAT names.

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
