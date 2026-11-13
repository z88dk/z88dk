;
; f_chdir. Outline is ChaN ff.c f_chdir. A file is FR_NO_PATH.
; The cluster is fat_cwd. The text is fat_cwd_str. path at sp+2.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

PUBLIC  _f_chdir
PUBLIC  f_chdir

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_cwd_apply
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_path
EXTERN  fat_noname
EXTERN  fat_attr
EXTERN  fat_here
EXTERN  fat_cwd

_f_chdir:
f_chdir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    ret     NC
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    jr      NC,fh_miss
    ld      a,(fat_noname)
    or      a
    jr      NZ,fh_ok
    ld      a,(fat_attr)
    and     AM_DIR
    jr      NZ,fh_ok
    ld      a,FR_NO_PATH
    jp      mf_err
fh_ok:
    call    fat_ldhl
    defw    fat_path
    call    mf_cwd_apply
    ret     NC
    call    fat_ldhl
    defw    fat_here
    call    fat_sthl
    defw    fat_cwd
    call    fat_ldhl
    defw    fat_here+2
    call    fat_sthl
    defw    fat_cwd+2
    jp      mf_ok
fh_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_err
    ld      a,FR_NO_PATH
    jp      mf_err
