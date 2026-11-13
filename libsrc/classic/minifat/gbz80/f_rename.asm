;
; f_rename renames a file or a directory.
; The old directory entry is copied. The new name is registered.
; Bytes 13 to 31 and the attribute are written onto the new entry.
; ".." is updated when a directory moves to another parent.
; The old entry is then deleted.
;
; ld hl,sp+n is native and forces Z = 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

EXTERN  mf_subhlbc

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

; Call. The new path is at sp+2. The old path is at sp+4.
; Call. The caller removes the arguments.
; Return. HL is the FRESULT and H is 0.
; Return. FR_OK is L = 0 and carry set. An error is carry clear.
; Writes. The new directory entry, "..", and the deleted old entry.
; Clobber. AF, BC, DE, HL.
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
    ret     NC                  ;the volume is not mounted. HL is the FRESULT
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    ret     NC                  ;the old path failed. HL is the FRESULT
    ld      a,(fat_noname)
    or      a
    jr      Z,rn_save           ;the old path names an object
    ld      a,FR_INVALID_NAME
    jp      mf_err
rn_save:
    call    fat_ldhl
    defw    dir_ptr
    ld      de,rn_buf
    ld      bc,32               ;one directory entry is 32 bytes
    call    mf_copy
    call    fat_ldhl
    defw    fat_dirsec
    call    fat_sthl
    defw    rn_sect
    call    fat_ldhl
    defw    fat_dirsec+2
    call    fat_sthl
    defw    rn_sect+2
    call    fat_ldhl
    defw    fat_dirofs
    call    fat_sthl
    defw    rn_ofs
    call    fat_ldhl
    defw    fat_parent
    call    fat_sthl
    defw    rn_parent
    call    fat_ldhl
    defw    fat_parent+2
    call    fat_sthl
    defw    rn_parent+2
    call    fat_ldhl
    defw    fat_found_sclust
    call    fat_sthl
    defw    rn_clust
    call    fat_ldhl
    defw    fat_found_sclust+2
    call    fat_sthl
    defw    rn_clust+2
    ld      a,(fat_attr)
    ld      (rn_attr),a
    call    fat_ldhl
    defw    fat_dp
    call    mf_follow
    jr      NC,rn_miss          ;the new path was not found
    call    fat_ldhl
    defw    dir_sect
    ld      de,(rn_sect)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      NZ,rn_exist
    call    fat_ldhl
    defw    dir_sect+2
    ld      de,(rn_sect+2)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      NZ,rn_exist
    call    fat_ldhl
    defw    dir_ofs
    ld      de,(rn_ofs)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      Z,rn_create         ;the new path is the same entry
rn_exist:
    ld      a,FR_EXIST
    jp      mf_err
rn_miss:
    ld      a,l
    cp      FR_NO_FILE          ;a missing final name is the create case
    jp      NZ,mf_err           ;any other FRESULT stays an error
rn_create:
    ld      hl,fat_name11
    call    dir_create
    jr      C,rn_copy           ;the new entry was registered
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
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(rn_attr)
    ld      (hl),a
    and     AM_DIR
    jr      NZ,rn_dirty         ;a directory does not gain the archive bit
    ld      a,(hl)
    or      AM_ARC
    ld      (hl),a
rn_dirty:
    ld      a,1
    ld      (fat_wflag),a
    ld      a,(rn_attr)
    and     AM_DIR
    jp      Z,rn_old            ;a file has no ".." entry to update
    call    fat_ldhl
    defw    fat_parent
    ld      de,(rn_parent)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      NZ,rn_dot           ;the parent cluster changed
    call    fat_ldhl
    defw    fat_parent+2
    ld      de,(rn_parent+2)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      Z,rn_old            ;the parent cluster is unchanged
rn_dot:
    ld      de,(rn_clust)
    ld      bc,(rn_clust+2)
    call    clst2sect
    jr      NC,rn_int           ;the directory cluster has no sector
    call    fat_move_window
    jr      NC,rn_disk          ;the directory sector was not read
    ld      a,(fatwin+33)
    cp      '.'                 ;the second entry should be ".."
    jr      NZ,rn_old           ;there is no ".." entry to update
    ld      hl,fatwin+32+DIR_ClusLO
    ld      de,(fat_parent)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      de,(fat_parent+2)
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32            ;fs_type against FAT32
    jr      Z,rn_phi            ;FAT32 keeps the parent high word
    ld      de,0                ;FAT12 and FAT16 store a high word of 0
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
    jr      NC,rn_disk          ;the old directory sector was not read
    call    fat_ldhl
    defw    rn_ofs
    ld      a,h
    and     1                   ;the offset in this 512-byte sector
    ld      h,a
    ld      de,fatwin
    add     hl,de
    call    fat_sthl
    defw    dir_ptr
    call    dir_zap
    call    fat_sync_window
    jp      C,mf_ok             ;the window is on disk. FR_OK
rn_disk:
    ld      a,FR_DISK_ERR
    jp      mf_err
rn_int:
    ld      a,FR_INT_ERR
    jp      mf_err

SECTION bss_compiler

; Saved directory entry, its location, and the old parent cluster.
rn_buf:             defs 32
rn_sect:            defs 4
rn_ofs:             defs 2
rn_parent:          defs 4
rn_clust:           defs 4
rn_attr:            defs 1
