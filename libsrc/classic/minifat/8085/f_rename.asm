;
; f_rename. Outline is ChaN ff.c f_rename (R0.16) for FAT. The old
; 32-byte entry is copied, the new name is registered, bytes 13..31
; and the attribute are written onto it, and ".." is updated when a
; directory moves to another parent. The old entry is then deleted.
; new path at sp+2, old path at sp+4. The caller cleans.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_rename
PUBLIC  f_rename

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  mf_copy
EXTERN  dir_create
EXTERN  dir_zap
EXTERN  clst2sect
EXTERN  fat_move_window
EXTERN  fat_sync_window
EXTERN  fat_path
EXTERN  fat_dp
EXTERN  fat_noname
EXTERN  fat_parent
EXTERN  fat_name11
EXTERN  fat_attr
EXTERN  fat_dirsec
EXTERN  fat_dirofs
EXTERN  fat_found_sclust
EXTERN  fat_wflag
EXTERN  dir_ptr
EXTERN  dir_sect
EXTERN  dir_ofs
EXTERN  _cpm_fat_vol
EXTERN  fatwin

_f_rename:
f_rename:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_dp),de
    inc     hl
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
    jr      Z,rn_save
    ld      a,FR_INVALID_NAME
    jp      mf_err
rn_save:
    ld      hl,(dir_ptr)
    ld      de,rn_buf
    ld      bc,32
    call    mf_copy
    ld      hl,(fat_dirsec)
    ld      (rn_sect),hl
    ld      hl,(fat_dirsec+2)
    ld      (rn_sect+2),hl
    ld      hl,(fat_dirofs)
    ld      (rn_ofs),hl
    ld      hl,(fat_parent)
    ld      (rn_parent),hl
    ld      hl,(fat_parent+2)
    ld      (rn_parent+2),hl
    ld      hl,(fat_found_sclust)
    ld      (rn_clust),hl
    ld      hl,(fat_found_sclust+2)
    ld      (rn_clust+2),hl
    ld      a,(fat_attr)
    ld      (rn_attr),a
    ld      hl,(fat_dp)
    call    mf_follow
    jr      NC,rn_miss
    ld      hl,(dir_sect)
    ld      de,(rn_sect)
    or      a
    push    bc
    ld      bc,de
    sub     hl,bc
    pop     bc
    jr      NZ,rn_exist
    ld      hl,(dir_sect+2)
    ld      de,(rn_sect+2)
    or      a
    push    bc
    ld      bc,de
    sub     hl,bc
    pop     bc
    jr      NZ,rn_exist
    ld      hl,(dir_ofs)
    ld      de,(rn_ofs)
    or      a
    push    bc
    ld      bc,de
    sub     hl,bc
    pop     bc
    jr      Z,rn_create
rn_exist:
    ld      a,FR_EXIST
    jp      mf_err
rn_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_err
rn_create:
    ld      hl,fat_name11
    call    dir_create
    jr      C,rn_copy
    ld      a,FR_DENIED
    jp      mf_err
rn_copy:
    ld      hl,rn_buf+13
    ld      de,(dir_ptr)
    ld      a,e
    add     a,13
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,19
    call    mf_copy
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(rn_attr)
    ld      (hl),a
    and     AM_DIR
    jr      NZ,rn_dirty
    ld      a,(hl)
    or      AM_ARC
    ld      (hl),a
rn_dirty:
    ld      a,1
    ld      (fat_wflag),a
    ld      a,(rn_attr)
    and     AM_DIR
    jr      Z,rn_old
    ld      hl,(fat_parent)
    ld      de,(rn_parent)
    or      a
    push    bc
    ld      bc,de
    sub     hl,bc
    pop     bc
    jr      NZ,rn_dot
    ld      hl,(fat_parent+2)
    ld      de,(rn_parent+2)
    or      a
    push    bc
    ld      bc,de
    sub     hl,bc
    pop     bc
    jr      Z,rn_old
rn_dot:
    ld      de,(rn_clust)
    ld      bc,(rn_clust+2)
    call    clst2sect
    jr      NC,rn_int
    call    fat_move_window
    jr      NC,rn_disk
    ld      a,(fatwin+33)
    cp      '.'
    jr      NZ,rn_old
    ld      hl,fatwin+32+DIR_ClusLO
    ld      de,(fat_parent)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      de,(fat_parent+2)
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32
    jr      Z,rn_phi
    ld      de,0
rn_phi:
    ld      hl,fatwin+32+DIR_ClusHI
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      a,1
    ld      (fat_wflag),a
rn_old:
    ld      de,(rn_sect)
    ld      bc,(rn_sect+2)
    call    fat_move_window
    jr      NC,rn_disk
    ld      hl,(rn_ofs)
    ld      a,h
    and     1
    ld      h,a
    ld      de,fatwin
    add     hl,de
    ld      (dir_ptr),hl
    call    dir_zap
    call    fat_sync_window
    jp      C,mf_ok
rn_disk:
    ld      a,FR_DISK_ERR
    jp      mf_err
rn_int:
    ld      a,FR_INT_ERR
    jp      mf_err

SECTION bss_compiler

rn_buf:             defs 32
rn_sect:            defs 4
rn_ofs:             defs 2
rn_parent:          defs 4
rn_clust:           defs 4
rn_attr:            defs 1
