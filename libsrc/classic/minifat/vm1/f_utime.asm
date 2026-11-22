;
; f_utime. Outline is ChaN ff.c f_utime. A zero date leaves the stamp.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_utime
PUBLIC  f_utime

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_sync_window
EXTERN  fat_path
EXTERN  fat_user
EXTERN  fat_noname
EXTERN  fat_wflag
EXTERN  dir_ptr

; Call. The FILINFO pointer is at sp+2. The path is at sp+4.
; The caller removes the arguments.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. An accepted entry stores the time and the date when the date word is not 0.
; An accepted entry sets the window flag even when the stamp stays.
_f_utime:
f_utime:
    ld      hl,sp+2
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_user),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    ret     NC                      ; the volume is not mounted. HL holds the FRESULT
    ld      hl,(fat_path)
    call    mf_follow
    ret     NC                      ; follow failed. HL holds the FRESULT
    ld      a,(fat_noname)
    or      a
    jr      Z,fu_set                ; the path names an entry
    ld      a,FR_INVALID_NAME       ; the path is the directory itself
    jp      mf_err
fu_set:
    ld      hl,(fat_user)
    ld      a,h
    or      l
    jr      Z,fu_sync               ; the FILINFO pointer is 0
    ld      de,FI_DATE
    add     hl,de                   ; the date word in FILINFO
    ld      e,(hl+)
    ld      d,(hl)
    ld      a,d
    or      e
    jr      Z,fu_sync               ; the date word is 0
    push    de
    ld      hl,(fat_user)
    ld      de,FI_TIME
    add     hl,de                   ; the time word in FILINFO
    ld      e,(hl+)
    ld      d,(hl)
    ld      hl,(dir_ptr)
    ld      bc,DIR_WrtTime
    add     hl,bc
    ld      (hl+),e                 ; store the write time
    ld      (hl),d
    pop     de
    ld      hl,(dir_ptr)
    ld      bc,DIR_WrtDate
    add     hl,bc
    ld      (hl+),e                 ; store the write date
    ld      (hl),d
fu_sync:
    ld      a,1                     ; mark the window dirty
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      C,mf_ok                 ; the window was written
    ld      a,FR_DISK_ERR           ; the window write failed
    jp      mf_err
