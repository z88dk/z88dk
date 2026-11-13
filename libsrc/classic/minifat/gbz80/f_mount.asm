;
; f_mount. Outline is ChaN ff.c f_mount (R0.16): drive, drop the old
; object, register the new one, mount when opt is not 0.
; 80cc stack-pointer order. The caller cleans. Last argument at sp+2.
; opt at sp+2, path at sp+4, fs at sp+6.
; A dirty file cache is discarded. Close a file before mounting again.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

PUBLIC  _f_mount
PUBLIC  f_mount

EXTERN  mf_drive
EXTERN  mf_bump_id
EXTERN  mf_publish
EXTERN  mf_cwd_reset
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_mount
EXTERN  fat_fs
EXTERN  fat_path
EXTERN  fat_kind
EXTERN  fat_dp
EXTERN  fat_file_valid
EXTERN  fat_file_dirty
EXTERN  _cpm_fat_vol

_f_mount:
f_mount:
    ld      hl,sp+2
    ld      a,(hl)
    ld      (fat_kind),a
    inc     hl
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_dp),de
    call    fat_ldhl
    defw    fat_path
    ld      a,h
    or      l
    jr      Z,fm_reg
    call    mf_drive
    ret     NC
fm_reg:
    xor     a
    ld      (fat_file_valid),a
    ld      (fat_file_dirty),a
    call    mf_bump_id
    call    fat_ldhl
    defw    fat_fs
    ld      a,h
    or      l
    jr      Z,fm_new
    ld      (hl),0
fm_new:
    call    fat_ldhl
    defw    fat_dp
    ld      a,h
    or      l
    jr      Z,fm_off
    call    fat_sthl
    defw    fat_fs
    ld      (hl),0
    inc     hl
    ld      (hl),0
    ld      a,(fat_kind)
    or      a
    jp      Z,mf_ok
    call    fat_mount
    jr      NC,fm_fail
    call    mf_publish
    call    mf_cwd_reset
    jp      mf_ok
fm_fail:
    ld      a,l                     ;1 disk, 3 not ready, 13 no filesystem, 19 csize
    jp      mf_err
fm_off:
    ld      hl,0
    call    fat_sthl
    defw    fat_fs
    xor     a
    ld      (_cpm_fat_vol),a
    jp      mf_ok
