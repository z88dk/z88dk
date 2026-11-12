;
; f_write. Outline is ChaN ff.c f_write: *bw = 0, validate, require
; FA_WRITE, clip a wrap past 4 GiB - 1, follow or allocate, copy.
; A short write at the end of the disk is FR_OK. FA_MODIFIED is set
; even when btw is 0. bw at sp+2, btw at sp+4, buff at sp+6, fp at sp+8.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

EXTERN  mf_subhlbc

PUBLIC  _f_write
PUBLIC  f_write

EXTERN  mf_fil_check
EXTERN  mf_transfer
EXTERN  mf_err
EXTERN  fat_fp
EXTERN  fat_user
EXTERN  fat_left
EXTERN  fat_out
EXTERN  fat_write

_f_write:
f_write:
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
    jp      Z,fw_chk
    xor     a
    ld      (hl+),a
    ld      (hl),a
fw_chk:
    call    fat_ldhl
    defw    fat_fp
    call    mf_fil_check
    ret     NC
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_WRITE
    jp      NZ,fw_clip
    ld      a,FR_DENIED
    jp      mf_err
fw_clip:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR+2
    add     hl,de
    ld      a,(hl+)
    and     (hl)
    inc     a
    jp      NZ,fw_go
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jp      Z,fw_go
    ld      hl,0
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    ld      de,(fat_left)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jp      NC,fw_go
    add     hl,de
    call    fat_sthl
    defw    fat_left
fw_go:
    ld      a,1
    ld      (fat_write),a
    jp      mf_transfer
