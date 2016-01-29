; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_nirvanam

PUBLIC asm_NIRVANAM_spriteT

asm_NIRVANAM_spriteT:

        add hl,hl
        add hl,hl
        add hl,hl       ; HL=sprite*8
        ld bc,57577
        add hl,bc       ; HL=57577+sprite*8
        ld (hl),a       ; tile
        dec l
        dec hl
        ld (hl),d       ; lin
        dec l
        ld (hl),e       ; col
        ret
