; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_spriteT(unsigned int sprite, unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_spriteT_callee

EXTERN asm_NIRVANAM_spriteT

NIRVANAM_spriteT_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        pop bc
        ld a,c          ; tile
        ex (sp),hl      ; sprite

	jp asm_NIRVANAM_spriteT

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _NIRVANAM_spriteT_callee
defc _NIRVANAM_spriteT_callee = NIRVANAM_spriteT_callee
ENDIF

