;
; f_mkdir. Outline is ChaN ff.c f_mkdir (R0.16). The new cluster is
; wiped by create_chain. "." and ".." are written and synced before
; the parent entry is registered. No timestamp is stored.
; A failed register frees the cluster. path is at sp+2.
; The caller removes the arguments.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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

; Create one directory. The parent entry is registered after the dot entries.
; Call. The caller removes the arguments. path is at sp+2.
; Return. HL is FR_OK and carry is set.
; Failure is HL = FRESULT, H is 0, and carry is clear.
; A failed mount returns the same L that fat_mount stored, or FR_NOT_ENABLED.
; 1 is a sector error. 3 is not ready. 13 is no filesystem.
; 19 is a cluster size of 64 KiB or more.
; Clobber. AF, BC, DE, HL.
; Writes. The new cluster, the dot entries, and the parent directory entry.
_f_mkdir:
f_mkdir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                  ;path at sp+2
    ld      (fat_path),de
    call    mf_ensure
    ret     NC                      ;HL already holds the FRESULT
    ld      hl,(fat_path)
    call    mf_follow
    jr      NC,mk_miss              ;the path was not found
    ld      a,(fat_noname)
    or      a
    jr      NZ,mk_name              ;the path does not end in a new name
    ld      a,FR_EXIST              ;the name is already in the directory
    jp      mf_err
mk_name:
    ld      a,FR_INVALID_NAME
    jp      mf_err
; Follow failed. Only FR_NO_FILE can become a new directory.
mk_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_err               ;the failure is not a missing name. Keep L.
    ld      hl,(fat_parent)
    ld      (fat_cfo),hl
    ld      hl,(fat_parent+2)
    ld      (fat_cfo+2),hl          ;the parent cluster, for ".."
    ld      de,0
    ld      bc,0                    ;cluster 0 starts a new chain
    call    create_chain
    jr      C,mk_got                ;BCDE is the new cluster
    ld      a,FR_DENIED             ;no free cluster
    jp      mf_err
mk_got:
    ld      (fat_hold),de
    ld      (fat_hold+2),bc
    call    clst2sect
    jp      NC,mk_int               ;the new cluster has no sector
    call    fat_move_window
    jp      NC,mk_disk              ;the sector was not read
    ld      hl,fatwin
    ld      (hl),'.'                ;the first directory entry is "."
    inc     hl
    ld      b,10
    ld      a,' '
; The rest of the 8.3 name is spaces.
mk_sp1:
    ld      (hl),a
    inc     hl
    djnz    mk_sp1
    ld      (hl),AM_DIR
    ld      hl,fatwin+DIR_ClusLO
    ld      de,(fat_hold)
    ld      (hl),e
    inc     hl
    ld      (hl),d                  ;the low cluster word of "."
    call    mk_hi_self
    ld      hl,fatwin+32            ;32 is the size of one directory entry
    ld      (hl),'.'
    inc     hl
    ld      (hl),'.'                ;the next directory entry is ".."
    inc     hl
    ld      b,9
    ld      a,' '
mk_sp2:
    ld      (hl),a
    inc     hl
    djnz    mk_sp2                  ;more name bytes remain
    ld      (hl),AM_DIR
    ld      hl,fatwin+32+DIR_ClusLO
    ld      de,(fat_cfo)
    ld      (hl),e
    inc     hl
    ld      (hl),d                  ;the low cluster word of ".."
    call    mk_hi_parent
    ld      a,1
    ld      (fat_wflag),a           ;the window holds the dot entries
    call    fat_sync_window
    jr      NC,mk_disk              ;the dot entries were not written
    ld      hl,fat_name11
    call    dir_create
    jr      NC,mk_deny              ;the parent has no free directory entry
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de
    ld      (hl),AM_DIR
    ld      hl,(dir_ptr)
    ld      de,DIR_ClusLO
    add     hl,de
    ld      de,(fat_hold)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      hl,(dir_ptr)
    ld      de,DIR_ClusHI
    add     hl,de
    ld      de,(fat_hold+2)
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32
    jr      Z,mk_ent_hi             ;the volume is FAT32. Keep the high word.
    ld      de,0                    ;FAT12 and FAT16 store 0 in the high word
mk_ent_hi:
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      a,1
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      C,mf_ok                 ;the parent entry is on the drive
    ld      a,FR_DISK_ERR           ;the parent entry was not written
    jp      mf_err
; Free the new cluster, then return FR_DENIED.
mk_deny:
    call    mk_free
    ld      a,FR_DENIED
    jp      mf_err
; Free the new cluster, then return FR_INT_ERR.
mk_int:
    call    mk_free
    ld      a,FR_INT_ERR
    jp      mf_err
; Free the new cluster, then return FR_DISK_ERR.
mk_disk:
    call    mk_free
    ld      a,FR_DISK_ERR
    jp      mf_err

; Free the cluster in fat_hold.
; Call. fat_hold is the cluster from create_chain.
; Return. Carry comes from remove_chain. The caller ignores it.
; Clobber. AF, BC, DE, HL.
mk_free:
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    jp      remove_chain

; High cluster word of "." at fatwin. FAT12 and FAT16 store 0.
; Call. fat_hold holds the new cluster.
; Return. The high word is stored. The caller ignores AF.
; Clobber. AF, DE, HL. BC stays.
mk_hi_self:
    ld      hl,fatwin+DIR_ClusHI
    ld      de,(fat_hold+2)
    jr      mk_hi_put

; High cluster word of "..". The parent cluster is fat_cfo.
; Call. fat_cfo holds the parent cluster.
; Return. The high word is stored. The caller ignores AF.
; Clobber. AF, DE, HL. BC stays.
mk_hi_parent:
    ld      hl,fatwin+32+DIR_ClusHI ;32 is the size of one directory entry
    ld      de,(fat_cfo+2)
; FAT32 stores the high word. FAT12 and FAT16 store 0.
mk_hi_put:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32
    jr      Z,mk_hi_st              ;the volume is FAT32
    ld      de,0
mk_hi_st:
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ret
