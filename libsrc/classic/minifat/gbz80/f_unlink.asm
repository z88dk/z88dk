;
; f_unlink. Outline is ChaN ff.c f_unlink (R0.16). A dot name is
; rejected. A read-only object and the current directory are denied.
; A directory must be empty. "." and ".." do not count. The entry is
; marked deleted and the cluster chain is freed. path at sp+2.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

PUBLIC  _f_unlink
PUBLIC  f_unlink

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  dir_sdi
EXTERN  dir_next
EXTERN  dir_zap
EXTERN  remove_chain
EXTERN  fat_move_window
EXTERN  fat_sync_window
EXTERN  fat_path
EXTERN  fat_noname
EXTERN  fat_attr
EXTERN  fat_here
EXTERN  fat_cwd
EXTERN  fat_dirsec
EXTERN  fat_dirofs
EXTERN  fat_hold
EXTERN  dir_ptr
EXTERN  fatwin

_f_unlink:
f_unlink:
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
    ret     NC
    ld      a,(fat_noname)
    or      a
    jp      Z,ul_real
    ld      a,FR_INVALID_NAME
    jp      mf_err
ul_real:
    ld      a,(fat_attr)
    and     AM_RDO
    jp      Z,ul_hold
    ld      a,FR_DENIED
    jp      mf_err
ul_hold:
    call    fat_ldhl
    defw    fat_here
    call    fat_sthl
    defw    fat_hold
    call    fat_ldhl
    defw    fat_here+2
    call    fat_sthl
    defw    fat_hold+2
    ld      a,(fat_attr)
    and     AM_DIR
    jp      Z,ul_zap
    ld      hl,fat_here
    ld      de,fat_cwd
    ld      b,4
ul_cmp:
    ld      a,(de)
    cp      (hl)
    jp      NZ,ul_empty
    inc     hl
    inc     de
    dec     b
    jp      nz,ul_cmp
    ld      a,FR_DENIED
    jp      mf_err
ul_empty:
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    ld      hl,0
    call    dir_sdi
    jp      NC,ul_disk
ul_walk:
    call    fat_ldhl
    defw    dir_ptr
    ld      a,(hl)
    or      a
    jp      Z,ul_zap
    cp      $E5
    jp      Z,ul_next
    cp      '.'
    jp      Z,ul_next
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    cp      $0F
    jp      Z,ul_next
    and     $DF
    cp      AM_VOL
    jp      Z,ul_next
    ld      a,FR_DENIED
    jp      mf_err
ul_next:
    call    dir_next
    jp      NC,ul_zap
    jp      ul_walk
ul_zap:
    ld      de,(fat_dirsec)
    ld      bc,(fat_dirsec+2)
    call    fat_move_window
    jp      NC,ul_disk
    call    fat_ldhl
    defw    fat_dirofs
    ld      a,h
    and     1
    ld      h,a
    ld      de,fatwin
    add     hl,de
    call    fat_sthl
    defw    dir_ptr
    call    dir_zap
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    ld      a,b
    or      c
    or      d
    or      e
    jp      Z,ul_sync
    call    remove_chain
    jp      NC,ul_disk
ul_sync:
    call    fat_sync_window
    jp      C,mf_ok
ul_disk:
    ld      a,FR_DISK_ERR
    jp      mf_err
