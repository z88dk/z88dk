;
; f_lseek. Outline is ChaN ff.c f_lseek normal seek: clip a read at the
; file size, and on a write extend the chain up to ofs. Cluster-aligned
; end uses the byte before that offset. ofs low at sp+2, ofs high at
; sp+4, fp at sp+6. The caller cleans.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

EXTERN  mf_subhlbc

PUBLIC  _f_lseek
PUBLIC  f_lseek

EXTERN  mf_fil_check
EXTERN  mf_place
EXTERN  mf_sector_for_fptr
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  mf_copy
EXTERN  fat_fp
EXTERN  fat_seek
EXTERN  fat_hold
EXTERN  fat_write
EXTERN  fat_off

_f_lseek:
f_lseek:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_seek),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_seek+2),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_fp),de
    ex      de,hl
    call    mf_fil_check
    ret     NC
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_WRITE
    jr      Z,fl_clip
    call    fl_past
    jr      NC,fl_set
    jr      fl_ext
fl_clip:
    call    fl_past
    jr      NC,fl_set
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_seek
    ld      bc,4
    call    mf_copy
fl_set:
    ld      hl,fat_seek
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_FPTR
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    jp      mf_place
fl_ext:
    ld      a,1
    ld      (fat_write),a
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    call    mf_copy
    ld      hl,fat_hold
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_FPTR
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
fl_loop:
    call    fl_before
    jp      NC,mf_place
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    ld      (fat_off),a
    inc     hl
    ld      a,(hl)
    and     1
    ld      (fat_off+1),a
    ld      hl,(fat_off)
    ld      de,512
    or      a
    ex      de,hl
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    ld      (fat_hold),hl
    call    fl_gap
    ld      a,(fat_off)
    ld      hl,fat_off+1
    or      (hl)
    jr      NZ,fl_step
    call    mf_sector_for_fptr
    jr      C,fl_step
    ld      a,h
    or      l
    jp      Z,mf_place
    jp      mf_err
fl_step:
    ld      bc,(fat_hold)
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    add     a,c
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    adc     a,b
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    adc     a,0
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    adc     a,0
    ld      (hl),a
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_SIZE
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_MODIFIED
    ld      (hl),a
    jr      fl_loop

; C when fat_seek > FIL size.
fl_past:
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_seek
    or      a
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sub     c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    ret

; C when FIL fptr < fat_seek.
fl_before:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,fat_seek
    or      a
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sub     c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    inc     hl
    inc     de
    ld      a,(de)
    ld      c,a
    ld      a,(hl)
    sbc     a,c
    ret

; fat_hold = min(fat_hold, fat_seek - fptr). fptr < seek here.
fl_gap:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,fat_seek
    or      a
    ld      a,(de)
    sub     (hl)
    ld      c,a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    ld      b,a
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    push    af
    inc     de
    inc     hl
    ld      a,(de)
    sbc     a,(hl)
    pop     de                      ;D is the third byte, E is flags
    or      d
    ret     NZ
    ld      hl,(fat_hold)
    or      a
    call    mf_subhlbc
    ret     C
    ret     Z
    ld      (fat_hold),bc
    ret
