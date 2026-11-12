;
; f_getcwd. The string kept by f_chdir is copied. len includes the NUL.
; len at sp+2, buff at sp+4. The caller cleans.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_getcwd
PUBLIC  f_getcwd

EXTERN  mf_ensure
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_cwd_str
EXTERN  fat_user
EXTERN  fat_left

_f_getcwd:
f_getcwd:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_left),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_user),de
    ld      a,d
    or      e
    jp      Z,fg_par
    ld      a,(fat_left)
    or      a
    call    fat_ldhl
    defw    fat_left
    or      h
    jp      Z,fg_par
    call    mf_ensure
    ret     NC
    call    fat_ldhl
    defw    fat_user
    ld      (hl),0
    ld      de,(fat_left)
    dec     de
    ld      a,d
    or      e
    jp      Z,fg_core
    ld      hl,fat_cwd_str
    ld      bc,(fat_user)
fg_cp:
    ld      a,(hl)
    ld      (bc),a
    or      a
    jp      Z,mf_ok
    inc     hl
    inc     bc
    dec     de
    ld      a,d
    or      e
    jp      NZ,fg_cp
fg_core:
    call    fat_ldhl
    defw    fat_user
    ld      (hl),0
    ld      a,FR_NOT_ENOUGH_CORE
    jp      mf_err
fg_par:
    ld      a,FR_INVALID_PARAMETER
    jp      mf_err
