; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_readC(unsigned char *attrs, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_readC_callee

EXTERN asm_NIRVANAM_readC

NIRVANAM_readC_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        pop bc          ; attrs
        push hl

	jp asm_NIRVANAM_readC
