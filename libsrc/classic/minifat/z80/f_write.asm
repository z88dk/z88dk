;
; f_write. Outline is ChaN ff.c f_write: *bw = 0, validate, require
; FA_WRITE, clip a wrap past 4 GiB - 1, follow or allocate, copy.
; A short write at the end of the disk is FR_OK. FA_MODIFIED is set
; even when btw is 0. bw at sp+2, btw at sp+4, buff at sp+6, fp at sp+8.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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
    ld      hl,(fat_out)
    ld      a,h
    or      l
    jr      Z,fw_chk
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
fw_chk:
    ld      hl,(fat_fp)
    call    mf_fil_check
    ret     NC
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_WRITE
    jr      NZ,fw_clip
    ld      a,FR_DENIED
    jp      mf_err
fw_clip:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR+2
    add     hl,de
    ld      a,(hl)
    inc     hl
    and     (hl)
    inc     a
    jr      NZ,fw_go
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jr      Z,fw_go
    ld      hl,0
    or      a
    sbc     hl,de
    ld      de,(fat_left)
    or      a
    sbc     hl,de
    jr      NC,fw_go
    add     hl,de
    ld      (fat_left),hl
fw_go:
    ld      a,1
    ld      (fat_write),a
    jp      mf_transfer
