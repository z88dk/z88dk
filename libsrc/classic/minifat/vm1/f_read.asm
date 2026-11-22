;
; f_read. Outline is ChaN ff.c f_read: *br = 0, validate, require
; FA_READ, clip to the bytes still in the file, copy through the cache.
; br is at sp+2, btr is at sp+4, buff is at sp+6, fp is at sp+8.
; The caller removes the arguments.
; f_read and f_write share mf_transfer. fat_write is 0 on this path.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_read
PUBLIC  f_read

EXTERN  mf_fil_check
EXTERN  mf_transfer
EXTERN  mf_err
EXTERN  fat_fp
EXTERN  fat_user
EXTERN  fat_left
EXTERN  fat_out
EXTERN  fat_write

; Read btr bytes. A short read at the end of the file is FR_OK.
; Call. The caller removes the arguments.
; br is at sp+2. btr is at sp+4. buff is at sp+6. fp is at sp+8.
; Return. HL is FR_OK and carry is set. This includes a short read.
; Failure is HL = FRESULT, H is 0, and carry is clear.
; An early ret NC already holds that FRESULT in HL.
; Clobber. AF, BC, DE, HL.
; Writes. The caller buffer and *br. A drive error is stored in FIL_ERR.
_f_read:
f_read:
    ld      hl,sp+2
    ld      e,(hl+)
    ld      d,(hl)                  ;br at sp+2
    ld      (fat_out),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)                  ;btr at sp+4
    ld      (fat_left),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)                  ;buff at sp+6
    ld      (fat_user),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)                  ;fp at sp+8
    ld      (fat_fp),de
    ld      hl,(fat_out)
    ld      a,h
    or      l
    jr      Z,fr_chk                ;br is null. Do not store a count.
    xor     a
    ld      (hl+),a
    ld      (hl),a                  ;*br = 0
; The object must belong to this mount and FIL_ERR must be 0.
fr_chk:
    ld      hl,(fat_fp)
    call    mf_fil_check
    ret     NC                      ;HL already holds the FRESULT
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_READ                 ;FA_READ is $01. The file is open for read.
    jr      NZ,fr_go                ;the read bit is set
    ld      a,FR_DENIED
    jp      mf_err
; fat_write is 0. mf_transfer copies from the file into the buffer.
fr_go:
    xor     a
    ld      (fat_write),a
    jp      mf_transfer
