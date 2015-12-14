; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_spriteT

asm_NIRVANAP_spriteT:

        add hl,hl
        add hl,hl
        add hl,hl       ; HL=sprite*8
        ld bc,56472
        add hl,bc       ; HL=56472+sprite*8
        ld (hl),a       ; tile
        dec l
        dec l
        ld (hl),d       ; lin
        dec hl
        ld (hl),e       ; col
        ret
