;
; f_closedir. Outline is ChaN ff.c f_closedir: a live object is dropped.
; dp at sp+2. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

EXTERN  mf_subhlbc

PUBLIC  _f_closedir
PUBLIC  f_closedir

EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_dp
EXTERN  fat_mount_id
EXTERN  _cpm_fat_vol

_f_closedir:
f_closedir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jr      Z,fd_bad
    ld      (fat_dp),de
    ld      a,(de)
    ld      l,a
    inc     de
    ld      a,(de)
    ld      h,a
    or      l
    jr      Z,fd_bad
    ld      de,(fat_mount_id)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      NZ,fd_bad
    ld      a,(_cpm_fat_vol)
    or      a
    jr      Z,fd_bad
    ld      hl,(fat_dp)
    ld      (hl),0
    inc     hl
    ld      (hl),0
    jp      mf_ok
fd_bad:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err
