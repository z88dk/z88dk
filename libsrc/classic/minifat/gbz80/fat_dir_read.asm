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
EXTERN  fat_copy
EXTERN  fat_ldhl
EXTERN  fat_sthl

; HL -> 32-byte dirent. Copy dir_ptr; first byte 0x00 is EOT (L=1).
_fat_dir_read:
    push    hl
    call    fat_ldhl
    defw    dir_ptr
    ld      a,(hl)
    or      a
    jr      Z,fat_dir_read_end      ;0x00 is end of directory
    pop     de
    ld      bc,32
    call    fat_copy                ;32-byte dirent; not ldir
    call    dir_next                ;C: a following dirent exists
    jr      C,fat_dir_read_ok       ;advance succeeded
    jr      NZ,fat_dir_read_err     ;disk error is not the end
    ld      hl,cc_zero              ;no trailing 0x00: next read is end
    call    fat_sthl
    defw    dir_ptr
fat_dir_read_ok:
    ld      hl,0
    scf                             ;C: dirent copied
    ret
fat_dir_read_err:
    ld      hl,1
    or      a
    ret
fat_dir_read_end:
    pop     hl
    ld      (hl),0
    ld      hl,1
    ret
