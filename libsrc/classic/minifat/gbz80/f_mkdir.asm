;
; f_mkdir. Outline is ChaN ff.c f_mkdir (R0.16). The new cluster is
; wiped by create_chain. "." and ".." are written and synced before
; the parent entry is registered. No timestamp is invented. A failed
; register frees the cluster. path at sp+2. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

PUBLIC  _f_mkdir
PUBLIC  f_mkdir

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  create_chain
EXTERN  remove_chain
EXTERN  clst2sect
EXTERN  fat_move_window
EXTERN  fat_sync_window
EXTERN  dir_create
EXTERN  fat_path
EXTERN  fat_noname
EXTERN  fat_parent
EXTERN  fat_name11
EXTERN  fat_hold
EXTERN  fat_cfo
EXTERN  fat_wflag
EXTERN  dir_ptr
EXTERN  _cpm_fat_vol
EXTERN  fatwin

_f_mkdir:
f_mkdir:
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
    jp      NC,mk_miss
    ld      a,(fat_noname)
    or      a
    jp      NZ,mk_name
    ld      a,FR_EXIST
    jp      mf_err
mk_name:
    ld      a,FR_INVALID_NAME
    jp      mf_err
mk_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_err
    call    fat_ldhl
    defw    fat_parent
    call    fat_sthl
    defw    fat_cfo
    call    fat_ldhl
    defw    fat_parent+2
    call    fat_sthl
    defw    fat_cfo+2
    ld      de,0
    ld      bc,0
    call    create_chain
    jp      C,mk_got
    ld      a,FR_DENIED
    jp      mf_err
mk_got:
    ld      (fat_hold),de
    ld      (fat_hold+2),bc
    call    clst2sect
    jp      NC,mk_int
    call    fat_move_window
    jp      NC,mk_disk
    ld      hl,fatwin
    ld      (hl),'.'
    inc     hl
    ld      b,10
    ld      a,' '
mk_sp1:
    ld      (hl+),a
    dec     b
    jp      nz,mk_sp1
    ld      (hl),AM_DIR
    ld      hl,fatwin+DIR_ClusLO
    ld      de,(fat_hold)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    mk_hi_self
    ld      hl,fatwin+32
    ld      (hl),'.'
    inc     hl
    ld      (hl),'.'
    inc     hl
    ld      b,9
    ld      a,' '
mk_sp2:
    ld      (hl+),a
    dec     b
    jp      nz,mk_sp2
    ld      (hl),AM_DIR
    ld      hl,fatwin+32+DIR_ClusLO
    ld      de,(fat_cfo)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    mk_hi_parent
    ld      a,1
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      NC,mk_disk
    ld      hl,fat_name11
    call    dir_create
    jp      NC,mk_deny
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_Attr
    add     hl,de
    ld      (hl),AM_DIR
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_ClusLO
    add     hl,de
    ld      de,(fat_hold)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_ClusHI
    add     hl,de
    ld      de,(fat_hold+2)
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32
    jp      Z,mk_ent_hi
    ld      de,0
mk_ent_hi:
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      a,1
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      C,mf_ok
    ld      a,FR_DISK_ERR
    jp      mf_err
mk_deny:
    call    mk_free
    ld      a,FR_DENIED
    jp      mf_err
mk_int:
    call    mk_free
    ld      a,FR_INT_ERR
    jp      mf_err
mk_disk:
    call    mk_free
    ld      a,FR_DISK_ERR
    jp      mf_err

mk_free:
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    jp      remove_chain

; High cluster word of "." at fatwin. FAT12 and FAT16 store 0.
mk_hi_self:
    ld      hl,fatwin+DIR_ClusHI
    ld      de,(fat_hold+2)
    jp      mk_hi_put

; High cluster word of ".." . The parent cluster is fat_cfo.
mk_hi_parent:
    ld      hl,fatwin+32+DIR_ClusHI
    ld      de,(fat_cfo+2)
mk_hi_put:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32
    jp      Z,mk_hi_st
    ld      de,0
mk_hi_st:
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ret
