;
; f_read. Outline is ChaN ff.c f_read: *br = 0, validate, require
; FA_READ, clip to the bytes still in the file, copy through the cache.
; br at sp+2, btr at sp+4, buff at sp+6, fp at sp+8. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_read
PUBLIC  f_read

EXTERN  mf_fil_check
EXTERN  mf_transfer
EXTERN  mf_err
EXTERN  fat_fp
EXTERN  fat_user
EXTERN  fat_left
EXTERN  fat_out
EXTERN  fat_write

_f_read:
f_read:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_out),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_left),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_user),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_fp),de
    call    fat_ldhl
    defw    fat_out
    ld      a,h
    or      l
    jp      Z,fr_chk
    xor     a
    ld      (hl+),a
    ld      (hl),a
fr_chk:
    call    fat_ldhl
    defw    fat_fp
    call    mf_fil_check
    ret     NC
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_READ
    jp      NZ,fr_go
    ld      a,FR_DENIED
    jp      mf_err
fr_go:
    xor     a
    ld      (fat_write),a
    jp      mf_transfer
