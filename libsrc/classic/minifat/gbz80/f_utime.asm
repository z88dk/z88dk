;
; f_utime. Outline is ChaN ff.c f_utime. A zero date leaves the stamp.
; fno at sp+2, path at sp+4. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_utime
PUBLIC  f_utime

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_sync_window
EXTERN  fat_path
EXTERN  fat_user
EXTERN  fat_noname
EXTERN  fat_wflag
EXTERN  dir_ptr

_f_utime:
f_utime:
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
    ret     NC
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    ret     NC
    ld      a,(fat_noname)
    or      a
    jp      Z,fu_set
    ld      a,FR_INVALID_NAME
    jp      mf_err
fu_set:
    call    fat_ldhl
    defw    fat_user
    ld      a,h
    or      l
    jp      Z,fu_sync
    ld      de,FI_DATE
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jp      Z,fu_sync
    push    de
    call    fat_ldhl
    defw    fat_user
    ld      de,FI_TIME
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    call    fat_ldhl
    defw    dir_ptr
    ld      bc,DIR_WrtTime
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    pop     de
    call    fat_ldhl
    defw    dir_ptr
    ld      bc,DIR_WrtDate
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
fu_sync:
    ld      a,1
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      C,mf_ok
    ld      a,FR_DISK_ERR
    jp      mf_err
