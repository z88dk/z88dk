;
; f_chmod. Outline is ChaN ff.c f_chmod. The mask keeps RDO, HID, SYS
; and ARC. DIR and VOL stay as they are. mask at sp+2, attr at sp+4,
; path at sp+6.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_chmod
PUBLIC  f_chmod

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_sync_window
EXTERN  fat_path
EXTERN  fat_noname
EXTERN  fat_wflag
EXTERN  dir_ptr
EXTERN  fat_mode
EXTERN  fat_hold

_f_chmod:
f_chmod:
    ld      hl,sp+2
    ld      a,(hl)
    and     AM_RDO|AM_HID|AM_SYS|AM_ARC
    ld      (fat_mode),a
    inc     hl
    inc     hl
    ld      a,(hl)
    ld      (fat_hold),a
    inc     hl
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    ret     NC
    ld      hl,(fat_path)
    call    mf_follow
    ret     NC
    ld      a,(fat_noname)
    or      a
    jr      Z,fc_set
    ld      a,FR_INVALID_NAME
    jp      mf_err
fc_set:
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de
    ld      b,(hl)
    ld      a,(fat_mode)
    cpl
    and     b
    ld      c,a
    ld      a,(fat_hold)
    ld      b,a
    ld      a,(fat_mode)
    and     b
    or      c
    ld      (hl),a
    ld      a,1
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      C,mf_ok
    ld      a,FR_DISK_ERR
    jp      mf_err
