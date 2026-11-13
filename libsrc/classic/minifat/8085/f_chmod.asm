;
; f_chmod. Outline is ChaN ff.c f_chmod. The mask keeps RDO, HID, SYS
; and ARC. DIR and VOL stay as they are. mask at sp+2, attr at sp+4,
; path at sp+6.
;
; 8085 reads a stacked argument with ld de,sp+n and ld hl,(de).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_chmod
PUBLIC  f_chmod

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_sync_window
EXTERN  fat_path
EXTERN  fat_noname
EXTERN  fat_wflag
EXTERN  dir_ptr
EXTERN  fat_mode
EXTERN  fat_hold

; Call. The mask byte is at sp+2. The attribute byte is at sp+4.
; The path is at sp+6. Each byte occupies a word. The caller removes the arguments.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. The call stores the attribute byte under the mask.
; The call sets the window flag before the sync.
_f_chmod:
f_chmod:
    ld      de,sp+2
    ld      a,(de)
    and     AM_RDO|AM_HID|AM_SYS|AM_ARC     ; only RDO, HID, SYS, and ARC can change
    ld      (fat_mode),a
    ld      de,sp+4
    ld      a,(de)
    ld      (fat_hold),a
    ld      de,sp+6
    ld      hl,(de)
    ld      (fat_path),hl
    call    mf_ensure
    ret     NC                              ; the volume is not mounted. HL holds the FRESULT
    ld      hl,(fat_path)
    call    mf_follow
    ret     NC                              ; follow failed. HL holds the FRESULT
    ld      a,(fat_noname)
    or      a
    jr      Z,fc_set                        ; the path names an entry
    ld      a,FR_INVALID_NAME               ; the path is the directory itself
    jp      mf_err
fc_set:
    ld      hl,(dir_ptr)
    ld      de,hl+DIR_Attr
    ex      de,hl
    ld      b,(hl)
    ld      a,(fat_mode)
    cpl
    and     b                               ; keep the bits the mask does not name
    ld      c,a
    ld      a,(fat_hold)
    ld      b,a
    ld      a,(fat_mode)
    and     b                               ; take the new bits the mask names
    or      c
    ld      (hl),a
    ld      a,1                             ; mark the window dirty
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      C,mf_ok                         ; the window was written
    ld      a,FR_DISK_ERR                   ; the window write failed
    jp      mf_err
