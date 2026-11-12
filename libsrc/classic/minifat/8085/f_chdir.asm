;
; f_chdir. Outline is ChaN ff.c f_chdir. A file is FR_NO_PATH.
; The cluster is fat_cwd. The text is fat_cwd_str. path at sp+2.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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
    ld      de,sp+2
    ld      hl,(de)
    ld      (fat_path),hl
    call    mf_ensure
    ret     NC
    ld      hl,(fat_path)
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
    ld      hl,(fat_path)
    call    mf_cwd_apply
    ret     NC
    ld      hl,(fat_here)
    ld      (fat_cwd),hl
    ld      hl,(fat_here+2)
    ld      (fat_cwd+2),hl
    jp      mf_ok
fh_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_err
    ld      a,FR_NO_PATH
    jp      mf_err
