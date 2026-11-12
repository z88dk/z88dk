;
; f_getcwd. The string kept by f_chdir is copied. len includes the NUL.
; len at sp+2, buff at sp+4. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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
    ld      de,sp+2
    ld      hl,(de)
    ld      (fat_left),hl
    ld      de,sp+4
    ld      hl,(de)
    ld      (fat_user),hl
    ld      a,h
    or      l
    jr      Z,fg_par
    ld      a,(fat_left)
    or      a
    ld      hl,(fat_left)
    or      h
    jr      Z,fg_par
    call    mf_ensure
    ret     NC
    ld      hl,(fat_user)
    ld      (hl),0
    ld      de,(fat_left)
    dec     de
    ld      a,d
    or      e
    jr      Z,fg_core
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
    jr      NZ,fg_cp
fg_core:
    ld      hl,(fat_user)
    ld      (hl),0
    ld      a,FR_NOT_ENOUGH_CORE
    jp      mf_err
fg_par:
    ld      a,FR_INVALID_PARAMETER
    jp      mf_err
