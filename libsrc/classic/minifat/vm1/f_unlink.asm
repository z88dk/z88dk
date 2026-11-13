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

; Delete the file or the empty directory named by path.
; Call. The caller removes the arguments. path is at sp+2.
; Return. HL is FR_OK and carry is set.
; Failure is HL = FRESULT, H is 0, and carry is clear.
; A failed mount returns the same L that fat_mount stored, or FR_NOT_ENABLED.
; 1 is a sector error. 3 is not ready. 13 is no filesystem.
; 19 is a cluster size of 64 KiB or more.
; An early ret NC from follow already holds that FRESULT in HL.
; Clobber. AF, BC, DE, HL.
; Writes. The directory entry becomes $E5. The chain is freed.
_f_unlink:
f_unlink:
    ld      hl,sp+2
    ld      e,(hl+)
    ld      d,(hl)                          ; path at sp+2
    ld      (fat_path),de
    call    mf_ensure
    ret     NC                              ; HL already holds the FRESULT
    ld      hl,(fat_path)
    call    mf_follow
    ret     NC                              ; HL already holds the FRESULT
    ld      a,(fat_noname)
    or      a
    jr      Z,ul_real                       ; the path names a real entry
    ld      a,FR_INVALID_NAME               ; a dot name or the directory itself
    jp      mf_err
; A read-only entry is refused.
ul_real:
    ld      a,(fat_attr)
    and     AM_RDO
    jr      Z,ul_hold                       ; the entry is not read-only
    ld      a,FR_DENIED
    jp      mf_err
; Remember the cluster. A directory must not be the current directory.
ul_hold:
    ld      hl,(fat_here)
    ld      (fat_hold),hl
    ld      hl,(fat_here+2)
    ld      (fat_hold+2),hl
    ld      a,(fat_attr)
    and     AM_DIR
    jr      Z,ul_zap                        ; a file has no children
    ld      hl,fat_here
    ld      de,fat_cwd
    ld      b,4
; Compare the next cluster byte with the current directory.
ul_cmp:
    ld      a,(de)
    cp      (hl)
    jr      NZ,ul_empty                     ; this byte differs. The directory is not current.
    inc     hl
    inc     de
    dec     b
    jr      nz,ul_cmp
    ld      a,FR_DENIED                     ; this directory is the current directory
    jp      mf_err
; Walk the directory. "." and ".." do not count as children.
ul_empty:
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    ld      hl,0                            ; offset 0
    call    dir_sdi
    jr      NC,ul_disk                      ; the directory sector was not read
ul_walk:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a
    jr      Z,ul_zap                        ; $00 ends the directory. It is empty.
    cp      $E5
    jr      Z,ul_next                       ; $E5 is a deleted entry
    cp      '.'
    jr      Z,ul_next                       ; a dot name, including ".."
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    cp      $0F
    jr      Z,ul_next                       ; $0F is a long name
    and     $DF                             ; clear the archive bit
    cp      AM_VOL
    jr      Z,ul_next                       ; a volume label
    ld      a,FR_DENIED                     ; the directory is not empty
    jp      mf_err
ul_next:
    call    dir_next
    jr      C,ul_walk                       ; carry is set. Another entry follows.
    jr      Z,ul_zap                        ; xor a at dir_next_end. The directory is empty.
    jr      ul_disk                         ; dir_next_io is ld a,1 then or a
; Put the parent sector in the window and mark the entry deleted.
ul_zap:
    ld      de,(fat_dirsec)
    ld      bc,(fat_dirsec+2)
    call    fat_move_window
    jr      NC,ul_disk                      ; the parent sector was not read
    ld      hl,(fat_dirofs)
    ld      a,h
    and     1                               ; keep the offset inside the 512-byte sector
    ld      h,a
    ld      de,fatwin
    add     hl,de
    ld      (dir_ptr),hl
    call    dir_zap                         ; dir_zap writes $E5. The caller frees the chain.
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,ul_sync                       ; the cluster is 0. There is no chain.
    call    remove_chain
    jr      NC,ul_disk                      ; the chain was not freed
ul_sync:
    call    fat_sync_window
    jp      C,mf_ok                         ; the window is on the drive
ul_disk:
    ld      a,FR_DISK_ERR
    jp      mf_err
