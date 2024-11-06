
; Hector support
;

SECTION code_clib

PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native

EXTERN  asm_toupper

INCLUDE "target/hector/def/hector1.def"


fputc_cons_native:
_fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    cp      12
    jp      z,cls
    call    asm_toupper
    ld      c,a
    call    FW_PUTC
IF FORhectorhr
    ld      (IO_MODE_HR_VRAM),a
ENDIF
    ret

cls:
    ld      hl,0
    ld      ($49a6),hl
IF FORhectorhr
    call    FW_CLS
    ld      (IO_MODE_HR_VRAM),a
    ret
ELSE
    jp      FW_CLS
ENDIF
