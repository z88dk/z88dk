;
; f_write. Outline is ChaN ff.c f_write: *bw = 0, validate, require
; FA_WRITE, clip a wrap past 4 GiB - 1, follow or allocate, copy.
; A short write at the end of the disk is FR_OK. FA_MODIFIED is set
; even when btw is 0. bw at sp+2, btw at sp+4, buff at sp+6, fp at sp+8.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

EXTERN  mf_subhlbc

PUBLIC  _f_write
PUBLIC  f_write

EXTERN  mf_fil_check
EXTERN  mf_transfer
EXTERN  mf_err
EXTERN  fat_fp
EXTERN  fat_user
EXTERN  fat_left
EXTERN  fat_out
EXTERN  fat_write

; Write btw bytes. A short write at the end of the drive is FR_OK.
; Call. The caller removes the arguments.
; bw is at sp+2. btw is at sp+4. buff is at sp+6. fp is at sp+8.
; Return. HL is FR_OK and carry is set. This includes a short write.
; Failure is HL = FRESULT, H is 0, and carry is clear.
; An early ret NC already holds that FRESULT in HL.
; Clobber. AF, BC, DE, HL.
; Writes. *bw and the file bytes.
; FA_MODIFIED means the directory entry needs an update.
; FA_DIRTY means the cache is ahead of the drive.
_f_write:
f_write:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; bw at sp+2
    ld      (fat_out),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; btw at sp+4
    ld      (fat_left),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; buff at sp+6
    ld      (fat_user),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; fp at sp+8
    ld      (fat_fp),de
    ld      hl,(fat_out)
    ld      a,h
    or      l
    jr      Z,fw_chk                        ; bw is null. Do not store a count.
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a                          ; *bw = 0
; The object must belong to this mount and FIL_ERR must be 0.
fw_chk:
    ld      hl,(fat_fp)
    call    mf_fil_check
    ret     NC                              ; HL already holds the FRESULT
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_WRITE                        ; FA_WRITE is $02. The file is open for write.
    jr      NZ,fw_clip                      ; the write bit is set
    ld      a,FR_DENIED
    jp      mf_err
; Clip btw when the file pointer is in the last 64 KiB.
fw_clip:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR+2
    add     hl,de
    ld      a,(hl)
    inc     hl
    and     (hl)
    inc     a                               ; both high bytes were $FF
    jr      NZ,fw_go                        ; the high word is not $FFFF
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; DE is the low word of the file pointer
    ld      a,d
    or      e
    jr      Z,fw_go                         ; the low word is 0. btw cannot pass 4 GiB.
    ld      hl,0
    or      a                               ; clear carry before the subtract
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    ld      de,(fat_left)
    or      a                               ; clear carry before this subtract
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      NC,fw_go                        ; btw fits before the low word wraps
    add     hl,de                           ; carry is set. Restore the room.
    ld      (fat_left),hl                   ; clip btw to that room
; fat_write is 1. mf_transfer copies from the buffer into the file.
; It sets FA_MODIFIED even when btw is 0.
fw_go:
    ld      a,1
    ld      (fat_write),a
    jp      mf_transfer
