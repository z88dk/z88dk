; Invalidate mini-FAT windows between red-team cases.
SECTION code_compiler

PUBLIC  _rt_invalidate
PUBLIC  _rt_dir_ofs_wrap
PUBLIC  _rt_wflag

EXTERN  fat_winsect
EXTERN  fat_wflag
EXTERN  clst_cache_sclust
EXTERN  dir_ofs
EXTERN  dir_next

_rt_invalidate:
    ld      hl,$FFFF
    ld      (fat_winsect),hl
    ld      (fat_winsect+2),hl
    ld      (clst_cache_sclust),hl
    ld      (clst_cache_sclust+2),hl
    xor     a
    ld      (fat_wflag),a
    ret

; dir_next 16-bit ofs wrap (2048 dirents). L=1 if NC (stopped).
_rt_dir_ofs_wrap:
    ld      hl,$FFE0
    ld      (dir_ofs),hl
    call    dir_next
    ld      l,1
    ret     NC
    ld      l,0
    ret

_rt_wflag:
    ld      a,(fat_wflag)
    ld      l,a
    ld      h,0
    ret
