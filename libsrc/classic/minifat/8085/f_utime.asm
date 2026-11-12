;
; f_utime. Outline is ChaN ff.c f_utime. A zero date leaves the stamp.
; fno at sp+2, path at sp+4. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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
    ld      de,sp+2
    ld      hl,(de)
    ld      (fat_user),hl
    ld      de,sp+4
    ld      hl,(de)
    ld      (fat_path),hl
    call    mf_ensure
    ret     NC
    ld      hl,(fat_path)
    call    mf_follow
    ret     NC
    ld      a,(fat_noname)
    or      a
    jr      Z,fu_set
    ld      a,FR_INVALID_NAME
    jp      mf_err
fu_set:
    ld      hl,(fat_user)
    ld      a,h
    or      l
    jr      Z,fu_sync
    ld      de,hl+FI_DATE
    ex      de,hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jr      Z,fu_sync
    push    de
    ld      hl,(fat_user)
    ld      de,hl+FI_TIME
    ex      de,hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,(dir_ptr)
    ld      bc,DIR_WrtTime
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    pop     de
    ld      hl,(dir_ptr)
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
