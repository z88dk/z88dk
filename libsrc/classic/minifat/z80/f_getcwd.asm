;
; f_getcwd. Copy the current directory text into the caller buffer.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_getcwd
PUBLIC  f_getcwd

EXTERN  mf_ensure
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_cwd_str
EXTERN  fat_user
EXTERN  fat_left

; Call. The length is at sp+2. The buffer is at sp+4. The caller removes the arguments.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. Success copies the current directory text into the buffer.
; FR_NOT_ENOUGH_CORE stores 0 in the first byte.
_f_getcwd:
f_getcwd:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_left),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_user),de
    ld      a,d
    or      e
    jr      Z,fg_par                ; the buffer pointer is 0
    ld      a,(fat_left)
    or      a
    ld      hl,(fat_left)           ; ld does not change flags
    or      h                       ; include the high byte of the length
    jr      Z,fg_par                ; the length is 0
    call    mf_ensure
    ret     NC                      ; the volume is not mounted. HL holds the FRESULT
    ld      hl,(fat_user)
    ld      (hl),0                  ; store 0 at the first byte
    ld      de,(fat_left)
    dec     de                      ; the copy writes at most len-1 bytes
    ld      a,d
    or      e
    jr      Z,fg_core               ; the length is 1
    ld      hl,fat_cwd_str
    ld      bc,(fat_user)
fg_cp:
    ld      a,(hl)
    ld      (bc),a
    or      a
    jp      Z,mf_ok                 ; the copied byte is the terminating 0
    inc     hl
    inc     bc
    dec     de
    ld      a,d
    or      e
    jr      NZ,fg_cp                ; bytes of the length remain
; the text does not fit in len-1 bytes
fg_core:
    ld      hl,(fat_user)
    ld      (hl),0                  ; clear the first byte of the buffer
    ld      a,FR_NOT_ENOUGH_CORE
    jp      mf_err
; the buffer pointer or the length is 0
fg_par:
    ld      a,FR_INVALID_PARAMETER
    jp      mf_err
