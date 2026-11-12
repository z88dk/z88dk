;
; f_getfree. Outline is ChaN ff.c f_getfree. The count comes from the
; core walk. fatfs at sp+2, nclst at sp+4, path at sp+6.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_getfree
PUBLIC  f_getfree

EXTERN  mf_ensure
EXTERN  mf_drive
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  _fat_getfree
EXTERN  fat_fs
EXTERN  fat_path
EXTERN  fat_user
EXTERN  fat_dp

_f_getfree:
f_getfree:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_dp),de
    inc     hl
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
    ld      a,h
    or      l
    jp      Z,fg_cnt
    call    mf_drive
    ret     NC
fg_cnt:
    call    fat_ldhl
    defw    fat_user
    ld      a,h
    or      l
    jp      NZ,fg_call
    ld      a,FR_INVALID_PARAMETER
    jp      mf_err
fg_call:
    call    _fat_getfree
    jp      C,fg_ptr
    ld      a,FR_DISK_ERR
    jp      mf_err
fg_ptr:
    call    fat_ldhl
    defw    fat_dp
    ld      a,h
    or      l
    jp      Z,mf_ok
    ld      de,(fat_fs)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    jp      mf_ok
