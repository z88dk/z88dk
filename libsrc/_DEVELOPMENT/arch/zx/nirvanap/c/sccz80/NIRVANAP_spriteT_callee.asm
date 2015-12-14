; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_spriteT(unsigned int sprite, unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_spriteT_callee

EXTERN asm_NIRVANAP_spriteT

NIRVANAP_spriteT_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        pop bc
        ld a,c          ; tile
        ex (sp),hl      ; sprite

	jp asm_NIRVANAP_spriteT
