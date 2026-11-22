;
; fat_dir_read: copy the current 32-byte directory entry.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_dir_read

EXTERN  cc_zero
EXTERN  dir_next
EXTERN  dir_ptr

; Copy the current 32-byte directory entry.
; The f_* layer does not call this function.
; Call. HL points at a 32-byte buffer.
; Return. L = 0 and H = 0 when the entry is copied. Carry is set.
; Return. A first byte of $00 stores 0 in the buffer.
; Return. That exit is L = 1 and H = 0. Carry stays clear because or a cleared it.
; Return. A disk or chain error is L = 1 and H = 0. Carry is clear.
; Return. The buffer already holds the entry on that error.
; Writes. A clean end with no $00 sets dir_ptr to cc_zero.
; Clobber. AF, BC, DE, HL.
_fat_dir_read:
    push    hl
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a
    jr      Z,fat_dir_read_end      ;$00 ends the directory
    pop     de
    ld      bc,32                   ;a directory entry is 32 bytes
    ldir
    call    dir_next                ;step to the next entry
    jr      C,fat_dir_read_ok       ;another entry follows
    jr      NZ,fat_dir_read_err     ;disk or chain error
    ld      hl,cc_zero              ;clean end with no trailing $00
    ld      (dir_ptr),hl
fat_dir_read_ok:
    ld      hl,0
    scf                             ;entry copied
    ret
fat_dir_read_err:
    ld      hl,1
    or      a                       ;clear carry
    ret
fat_dir_read_end:
    pop     hl
    ld      (hl),0                  ;store 0 in the caller buffer
    ld      hl,1                    ;L = 1. ld does not change flags.
    ret
