;
; f_opendir. Outline is ChaN ff.c f_opendir (R0.16). A missing path
; is FR_NO_PATH. A file is FR_NO_PATH. "." and the root are the
; directory itself. path at sp+2, dp at sp+4. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_opendir
PUBLIC  f_opendir

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  dir_sdi
EXTERN  fat_path
EXTERN  fat_dp
EXTERN  fat_noname
EXTERN  fat_attr
EXTERN  fat_here
EXTERN  fat_mount_id

_f_opendir:
f_opendir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jp      Z,od_bad
    ld      (fat_dp),de
    ld      b,20
    xor     a
od_z:
    ld      (de),a
    inc     de
    dec     b
    jr      nz,od_z
    call    mf_ensure
    ret     NC
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    jp      NC,od_miss
    ld      a,(fat_noname)
    or      a
    jr      NZ,od_dir
    ld      a,(fat_attr)
    and     AM_DIR
    jp      Z,od_nopath
od_dir:
    call    fat_ldhl
    defw    fat_dp
    ld      de,(fat_mount_id)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    fat_ldhl
    defw    fat_dp
    ld      de,DIR_SCLUST
    add     hl,de
    ld      de,(fat_here)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(fat_here+2)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    fat_ldhl
    defw    fat_dp
    ld      de,DIR_CLUST
    add     hl,de
    ld      de,(fat_here)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(fat_here+2)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      de,(fat_here)
    ld      bc,(fat_here+2)
    ld      hl,0
    call    dir_sdi
    jp      C,mf_ok
    call    fat_ldhl
    defw    fat_dp
    ld      (hl),0
    inc     hl
    ld      (hl),0
    ld      a,FR_DISK_ERR
    jp      mf_err
od_nopath:
    ld      a,FR_NO_PATH
    jp      mf_err
od_miss:
    ld      a,l
    cp      FR_NO_FILE
    jr      NZ,od_err
    ld      a,FR_NO_PATH
od_err:
    jp      mf_err
od_bad:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err
