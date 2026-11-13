;
; f_unlink. Outline is ChaN ff.c f_unlink (R0.16). A dot name is
; rejected. A read-only object and the current directory are denied.
; A directory must be empty. "." and ".." do not count. The entry is
; marked deleted and the cluster chain is freed. path at sp+2.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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
    ld      hl,(fat_path)
    call    mf_follow
    ret     NC
    ld      a,(fat_noname)
    or      a
    jr      Z,ul_real
    ld      a,FR_INVALID_NAME
    jp      mf_err
ul_real:
    ld      a,(fat_attr)
    and     AM_RDO
    jr      Z,ul_hold
    ld      a,FR_DENIED
    jp      mf_err
ul_hold:
    ld      hl,(fat_here)
    ld      (fat_hold),hl
    ld      hl,(fat_here+2)
    ld      (fat_hold+2),hl
    ld      a,(fat_attr)
    and     AM_DIR
    jr      Z,ul_zap
    ld      hl,fat_here
    ld      de,fat_cwd
    ld      b,4
ul_cmp:
    ld      a,(de)
    cp      (hl)
    jr      NZ,ul_empty
    inc     hl
    inc     de
    djnz    ul_cmp
    ld      a,FR_DENIED
    jp      mf_err
ul_empty:
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    ld      hl,0
    call    dir_sdi
    jr      NC,ul_disk
ul_walk:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a
    jr      Z,ul_zap
    cp      $E5
    jr      Z,ul_next
    cp      '.'
    jr      Z,ul_next
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    cp      $0F
    jr      Z,ul_next
    and     $DF
    cp      AM_VOL
    jr      Z,ul_next
    ld      a,FR_DENIED
    jp      mf_err
ul_next:
    call    dir_next
    jr      C,ul_walk
    jr      Z,ul_zap                ;clean end: the directory is empty
    jr      ul_disk
ul_zap:
    ld      de,(fat_dirsec)
    ld      bc,(fat_dirsec+2)
    call    fat_move_window
    jr      NC,ul_disk
    ld      hl,(fat_dirofs)
    ld      a,h
    and     1
    ld      h,a
    ld      de,fatwin
    add     hl,de
    ld      (dir_ptr),hl
    call    dir_zap
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,ul_sync
    call    remove_chain
    jr      NC,ul_disk
ul_sync:
    call    fat_sync_window
    jp      C,mf_ok
ul_disk:
    ld      a,FR_DISK_ERR
    jp      mf_err
