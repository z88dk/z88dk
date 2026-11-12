;
; f_stat. Outline is ChaN ff.c f_stat: mount, follow, reject a bare
; directory origin, fill FILINFO from the entry. fno at sp+2, path at sp+4.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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
    jr      NC,fs_bad
    ld      hl,(fat_path)
    call    mf_follow
    jr      NC,fs_bad
    ld      a,(fat_noname)
    or      a
    jr      NZ,fs_name
    ld      hl,(fat_user)
    ld      a,h
    or      l
    jp      Z,mf_ok
    jp      mf_fill_info
fs_name:
    ld      a,FR_INVALID_NAME
    jr      fs_clr
fs_bad:
    ld      a,l
fs_clr:
    ld      e,a
    ld      hl,(fat_user)
    ld      a,h
    or      l
    jr      Z,fs_ret
    ld      bc,FI_NAME
    add     hl,bc
    ld      (hl),0
fs_ret:
    ld      a,e
    jp      mf_err
