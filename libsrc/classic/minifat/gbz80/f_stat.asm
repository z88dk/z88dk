;
; f_stat. Outline is ChaN ff.c f_stat: mount, follow, reject a bare
; directory origin, fill FILINFO from the entry. fno at sp+2, path at sp+4.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_stat
PUBLIC  f_stat

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_fill_info
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_path
EXTERN  fat_user
EXTERN  fat_noname

_f_stat:
f_stat:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_user),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    jp      NC,fs_bad
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    jp      NC,fs_bad
    ld      a,(fat_noname)
    or      a
    jp      NZ,fs_name
    call    fat_ldhl
    defw    fat_user
    ld      a,h
    or      l
    jp      Z,mf_ok
    jp      mf_fill_info
fs_name:
    ld      a,FR_INVALID_NAME
    jp      fs_clr
fs_bad:
    ld      a,l
fs_clr:
    ld      e,a
    call    fat_ldhl
    defw    fat_user
    ld      a,h
    or      l
    jp      Z,fs_ret
    ld      bc,FI_NAME
    add     hl,bc
    ld      (hl),0
fs_ret:
    ld      a,e
    jp      mf_err
